//
//  RateLimit.swift
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

/// Enumeration for rate limit status.
///
/// This enumeration represents the possible states of rate limit status, providing insight into whether the current
/// rate limit has been reached or exceeded, and when it will be lifted.
@available(iOS 18.0, macOS 15.0, *)
public enum RateLimitStatus {
    
    /// Indicates that the current rate limit is within the allowed limit.
    ///
    /// This status means that the number of operations performed is below the configured rate limit, and no further
    /// action is required.
    case withinLimit
    
    /// Indicates that the rate limit has been exceeded.
    ///
    /// This status means that the number of operations performed has surpassed the allowed rate limit, and further
    /// operations are restricted until the limit is reset or the rate limit window expires.
    case limitExceeded
    
    /// Indicates that the rate limit has been exceeded and provides the time until when the limit is enforced.
    ///
    /// This status provides information about when the rate limit will be lifted, allowing for future operations
    /// once the specified time has passed.
    ///
    /// - Parameter Date: The date and time when the rate limit will be lifted, after which operations will be allowed
    ///                   again.
    case rateLimitedUntil(Date)
}

/// Enumeration for rate limit event types.
///
/// This enumeration defines the different types of events related to rate limits, helping to categorize and log
/// various rate limit-related actions and occurrences.
@available(iOS 18.0, macOS 15.0, *)
public enum RateLimitEventType {
    
    /// Represents a standard request event.
    ///
    /// This event type is used for logging and monitoring regular requests that are subject to rate limits.
    case request
    
    /// Represents a burst request event.
    ///
    /// This event type is used for logging and monitoring bursts of requests that are subject to burst rate limits.
    case burst
    
    /// Represents a rate limit reset event.
    ///
    /// This event type is used for logging and monitoring when the rate limit is reset, allowing for a new set of
    /// operations to be performed within the allowed limits.
    case reset
    
    /// Represents an error event related to rate limits.
    ///
    /// This event type is used for logging and monitoring errors that occur due to rate limiting, such as exceeding
    /// the allowed request rate or other related issues.
    case error
}

/// Struct for rate limit configuration.
///
/// This struct encapsulates the configuration settings for rate limits, including both standard and burst limits.
/// It provides the necessary parameters to configure and enforce rate limits on operations.
@available(iOS 18.0, macOS 15.0, *)
public struct RateLimitConfiguration {
    
    /// The maximum number of requests allowed in a given time frame.
    ///
    /// This value specifies the upper limit of operations that can be performed within the defined time frame.
    /// Once this limit is reached, further operations are restricted until the time frame resets.
    let maxRequests: Int
    
    /// The time frame in which the maximum number of requests is allowed.
    ///
    /// This value defines the duration (in seconds) over which the maximum number of requests (`maxRequests`) is counted.
    /// For example, if `maxRequests` is 100 and `timeFrame` is 3600 seconds (1 hour), a maximum of 100 requests can
    /// be made within each hour.
    let timeFrame: TimeInterval
    
    /// The maximum number of requests allowed in a burst.
    ///
    /// This value specifies the upper limit of operations that can be performed in a short burst, allowing for
    /// temporary spikes in activity. It is `nil` if burst limits are not used.
    ///
    /// - Note: This setting works in conjunction with `burstWindow` to manage burst requests.
    let burstLimit: Int?
    
    /// The time window for the burst limit.
    ///
    /// This value defines the duration (in seconds) during which the `burstLimit` applies. For example, if `burstLimit`
    /// is 10 and `burstWindow` is 60 seconds, up to 10 requests can be made within any 60-second window.
    /// It is `nil` if burst limits are not used.
    ///
    /// - Note: This setting works in conjunction with `burstLimit` to manage burst requests.
    let burstWindow: TimeInterval?
}
