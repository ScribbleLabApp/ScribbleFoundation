//
//  Retryable+Extension.swift
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

import Foundation

@available(iOS 18.0, macOS 15.0, *)
public extension Retryable {
    
    /// Executes a retryable operation with configurable retry attempts and intervals.
    ///
    /// This method attempts to execute the given asynchronous operation, retrying if it fails, based on the specified
    /// number of retry attempts and interval between retries. If the operation continues to fail after the maximum
    /// number of retry attempts, the last error encountered is thrown.
    ///
    /// - Parameter operation: An asynchronous closure that represents the operation to be retried. This closure may throw an error.
    /// - Returns: The result of the operation if it succeeds within the allowed retry attempts.
    /// - Throws: The error encountered in the final retry attempt if all retries fail.
    /// - Note: This method uses `Task.sleep(nanoseconds:)` to wait between retry attempts. The retry interval is specified in seconds,
    ///   and is converted to nanoseconds for the sleep duration.
    /// - Precondition: `retryAttempts` must be greater than 0 to make retry attempts.
    func retry<T>(_ operation: () async throws -> T) async throws -> T {
        var attempts = 0
        while attempts < retryAttempts {
            do {
                return try await operation()
            } catch {
                attempts += 1
                if attempts >= retryAttempts {
                    throw error
                }
                
                try await Task.sleep(nanoseconds: UInt64(retryInterval * 1_000_000_000))
            }
        }
        fatalError("Unreachable code")
    }
}
