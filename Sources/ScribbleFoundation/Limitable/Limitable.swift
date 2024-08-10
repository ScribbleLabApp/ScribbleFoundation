//
//  Limitable.swift
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

/// A protocol for enforcing rate limits on operations.
///
/// This protocol provides methods for enforcing rate limits on operations, including standard and burst limits.
/// It allows configuring rate limits, checking current status, and logging events related to rate limiting.
@available(iOS 18.0, macOS 15.0, *)
public protocol Limitable {
    
    /// Attempts to perform an operation while adhering to the rate limit.
    ///
    /// This method ensures that the operation is executed only if it conforms to the defined rate limits.
    ///
    /// - Parameter operation: The closure representing the operation to perform.
    /// - Throws: An error if the rate limit is exceeded or if the operation fails.
    func performOperation(withRateLimit operation: () throws -> Void) throws
    
    /// Checks the current rate limit status.
    ///
    /// This method returns the current status of the rate limits, indicating whether they have been reached or exceeded.
    ///
    /// - Returns: A `RateLimitStatus` indicating whether the rate limit has been reached or exceeded.
    func checkRateLimitStatus() -> RateLimitStatus
    
    /// Configures the rate limit settings.
    ///
    /// This method sets the maximum number of requests allowed within a specified time frame.
    ///
    /// - Parameters:
    ///   - maxRequests: The maximum number of requests allowed in a given time frame.
    ///   - timeFrame: The time frame in which the maximum number of requests is allowed.
    func configureRateLimit(maxRequests: Int, timeFrame: TimeInterval)
    
    /// Resets the rate limit count.
    ///
    /// This method resets the rate limit counter, allowing for a fresh start.
    func resetRateLimit()
    
    /// Sets a burst rate limit which allows for a higher number of requests in a short burst.
    ///
    /// This method configures a burst rate limit that permits a higher number of requests over a brief time window.
    ///
    /// - Parameters:
    ///   - burstLimit: The maximum number of requests allowed in a burst.
    ///   - burstWindow: The time window for the burst limit.
    func configureBurstLimit(burstLimit: Int, burstWindow: TimeInterval)
    
    /// Retrieves the current rate limit configuration.
    ///
    /// This method provides the current settings for both standard and burst rate limits.
    ///
    /// - Returns: A `RateLimitConfiguration` object containing the current settings.
    func getRateLimitConfiguration() -> RateLimitConfiguration
    
    /// Records the occurrence of a rate-limited action.
    ///
    /// This method logs the time when a rate-limited action was applied.
    ///
    /// - Parameter timestamp: The time at which the rate limit was applied.
    func recordRateLimitedAction(at timestamp: Date)
    
    /// Logs rate limit events for monitoring and debugging.
    ///
    /// This method logs various rate limit-related events to aid in monitoring and debugging.
    ///
    /// - Parameters:
    ///   - eventType: The type of rate limit event.
    ///   - details: Optional details about the event.
    func logRateLimitEvent(_ eventType: RateLimitEventType, details: [String: Any]?)
}
