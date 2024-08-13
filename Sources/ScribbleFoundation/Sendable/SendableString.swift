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
///
/// > Warning:
/// > `SendableString` is only guaranteed to be thread-safe on the main thread.
@available(iOS 18.0, macOS 15.0, *)
public actor SendableString: Sendable {
    
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
        _value
    }
    
    /// Sets a new value for the string.
    ///
    /// This method performs an asynchronous write of the new string value. It uses a barrier
    /// flag to ensure that writes are exclusive and do not interfere with other concurrent operations.
    ///
    /// - Parameter newValue: The new value to set.
    @MainActor public func set(_ newValue: String) {
        _value = newValue
    }
    
    
    /// Asynchronously mutates the current string value.
    ///
    /// This method allows for asynchronous transformation of the string value. It retries until
    /// the mutation function successfully applies the change, ensuring atomic updates.
    ///
    /// - Parameter mutate: A closure that takes the current string value and returns a new string value.
    public func asyncMutate(_ mutate: @Sendable @escaping (String) -> String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Task.detached(priority: .medium) {
                while true {
                    let currentValue = await self._value
                    let newValue = mutate(currentValue)
                    
                    if Task.isCancelled {
                        continuation.resume(throwing: CancellationError())
                        return
                    }
                    
                    let success = await self.withTransaction {
                        if await self._value == currentValue {
                            Task { @MainActor in
                                self._value = newValue
                                return true
                            }
                        }
                        return false
                    }
                    
                    if success {
                        continuation.resume()
                        break
                    }
                }
            }
        }
    }
    
    /// Performs an operation in a transaction-like manner, ensuring consistency.
    ///
    /// - Parameter operation: A closure that performs the operation and returns a result indicating success or failure.
    /// - Returns: A boolean indicating if the operation was successful.
    private func withTransaction<T: Sendable>(_ operation: () async -> T) async -> T {
        await operation()
    }
}
