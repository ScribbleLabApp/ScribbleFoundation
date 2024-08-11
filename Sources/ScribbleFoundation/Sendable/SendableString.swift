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

/// A thread-safe wrapper for a mutable `String` value that supports asynchronous mutation.
///
/// The `SendableString` class provides a way to safely access and modify a `String` value
/// across concurrent tasks. It uses a `DispatchQueue` with a concurrent attribute to handle
/// synchronization, ensuring thread-safe operations on the string value. This class also supports
/// asynchronous mutations with the `asyncMutate` method.
@available(iOS 18.0, macOS 15.0, *)
public final class SendableString: Sendable {
    
    /// A concurrent dispatch queue used for thread-safe access and modifications.
    private let queue = DispatchQueue(label: "SendableStringQueue", attributes: .concurrent)
    
    /// The underlying string value that is being managed.
    @MainActor private var _value: String
    
    
    /// Initializes a new `SendableString` with the given initial value.
    ///
    /// - Parameter value: The initial value to set for the `SendableString`.
    public init(_ value: String) {
        self._value = value
    }
    
    
    /// Retrieves the current string value.
    ///
    /// This method performs a synchronous read of the string value, ensuring thread safety
    /// by using a concurrent dispatch queue.
    ///
    /// - Returns: The current string value.
    @MainActor public func get() -> String {
        queue.sync { _value }
    }
    
    /// Sets a new value for the string.
    ///
    /// This method performs an asynchronous write of the new string value. It uses a barrier
    /// flag to ensure that writes are exclusive and do not interfere with other concurrent operations.
    ///
    /// - Parameter newValue: The new value to set.
    public func set(_ newValue: String) {
        queue.async(flags: .barrier) {
            Task { @MainActor in
                self._value = newValue
            }
        }
    }
    
    
    /// Asynchronously mutates the current string value.
    ///
    /// This method allows for asynchronous transformation of the string value. It uses a `Task.detached`
    /// to perform the mutation and ensures that changes are applied atomically. The method keeps trying
    /// to update the value until it succeeds, guaranteeing that the mutation function is applied correctly.
    ///
    /// - Parameter mutate: A closure that takes the current string value and returns a new string value.
    ///
    /// - Throws: An error if the operation fails (though the current implementation does not throw specific errors).
    public func asyncMutate(_ mutate: @Sendable @escaping (String) -> String) async {
        await withCheckedContinuation { continuation in
            Task.detached(priority: .medium) { @MainActor in
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
