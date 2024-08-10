//
//  Retryable.swift
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

/// A protocol for objects that can perform retryable operations.
///
/// Conforming types implement retry logic to handle operations that may need to be retried
/// upon failure. This protocol provides properties to configure the number of retry attempts
/// and the interval between each attempt.
///
/// Example use case includes network requests that should be retried upon failure.
@available(iOS 18.0, macOS 15.0, *)
public protocol Retryable {
    
    /// Number of retry attempts.
    ///
    /// This property specifies the maximum number of times an operation will be retried if it fails.
    /// The default value is usually set to a reasonable number depending on the use case.
    var retryAttempts: Int { get set }
    
    /// Interval between retry attempts.
    ///
    /// This property defines the duration to wait between consecutive retry attempts.
    /// The value is specified in seconds. A higher interval can reduce the frequency of retries,
    /// while a lower interval may increase the retry rate.
    var retryInterval: TimeInterval { get set }
    
    /// Executes a retryable operation.
    ///
    /// This method will attempt to execute the provided asynchronous operation. If the operation fails,
    /// it will be retried up to the specified number of times with the specified interval between attempts.
    ///
    /// - Parameter operation: A closure representing the operation to be retried. This closure is an
    ///   asynchronous function that can throw an error. The closure returns a value of type `T`.
    /// - Returns: The result of the operation if successful.
    /// - Throws: The error thrown by the operation if it fails after the maximum number of retries.
    func retry<T>(_ operation: () async throws -> T) async throws -> T
}
