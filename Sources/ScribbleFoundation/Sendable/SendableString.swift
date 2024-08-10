//
//  File.swift
//  ScribbleFoundation
//
//  Created by Nevio Hirani on 10.08.24.
//

import Atomics
import Foundation

@available(iOS 18.0, macOS 15.0, *)
public final class SendableString: Sendable {
    private let queue = DispatchQueue(label: "SendableStringQueue", attributes: .concurrent)
    private var _value: String
    
    public init(_ value: String) {
        self._value = value
    }
    
    public func get() -> String {
        queue.sync { _value }
    }
    
    public func set(_ newValue: String) {
        queue.async(flags: .barrier) {
            self._value = newValue
        }
    }
    
    public func asyncMutate(_ mutate: @Sendable @escaping (String) -> String) async {
        await withCheckedContinuation { continuation in
            Task.detached(priority: .medium) {
                while true {
                    let currentValue = self.queue.sync { self._value }
                    let newValue = mutate(currentValue)
                    
                    if self.queue.sync(execute: {
                        let result = self._value == currentValue
                        if result {
                            self._value = newValue
                        }
                        result
                    }) {
                        continuation.resume()
                        break
                    }
                }
            }
        }
    }
}
