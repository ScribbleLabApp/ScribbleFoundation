//
//  File.swift
//  ScribbleFoundation
//
//  Created by Nevio Hirani on 10.08.24.
//

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
    /// - Note: This method uses `Task.sleep` to wait between retry attempts. The retry interval is specified in seconds,
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
                await Task.sleep(UInt64(retryInterval * 1_000_000_000))
            }
        }
        fatalError("Unreachable code")
    }
}
