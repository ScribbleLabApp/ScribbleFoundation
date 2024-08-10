//
//  SendableString.swift
//  ScribbleFoundation
//
//  Copyright (c) 2024 ScribbleLabApp LLC. All rights reserved
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
                    
                    let updated = self.queue.sync {
                        if self._value == currentValue {
                            self._value = newValue
                            return true
                        }
                        return false
                    }
                    
                    if updated {
                        continuation.resume()
                        break
                    }
                }
            }
        }
    }
}
