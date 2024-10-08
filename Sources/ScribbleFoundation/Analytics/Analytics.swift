//
//  Analytics.swift
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

/// A protocol for logging and tracking events with extended functionalities.
///
/// The `Analytics` protocol defines methods for logging events, errors, and user sessions.
/// It also supports setting user identifiers, batch logging of events, and categorizing events
/// with different log levels.
@available(iOS 18.0, macOS 15.0, *)
public protocol Analytics {
    
    /// Logs an event with optional parameters.
    ///
    /// - Parameters:
    ///   - eventName: The name of the event to be logged.
    ///   - parameters: Optional dictionary of parameters associated with the event.
    func logEvent(_ eventName: String, parameters: [String: Any]?)
    
    /// Logs an error event with optional parameters.
    ///
    /// - Parameters:
    ///   - error: The error to be logged.
    ///   - parameters: Optional dictionary of parameters associated with the error.
    func logError(_ error: Error, parameters: [String: Any]?)
    
    /// Logs a custom event with a specified log level.
    ///
    /// - Parameters:
    ///   - eventName: The name of the event to be logged.
    ///   - level: The log level for the event.
    ///   - parameters: Optional dictionary of parameters associated with the event.
    func logEvent(_ eventName: String, level: _LogLevel, parameters: [String: Any]?)
    
    /// Tracks the start of a user session.
    ///
    /// - Parameter sessionId: The unique identifier for the user session.
    func startSession(_ sessionId: String)
    
    /// Tracks the end of a user session.
    ///
    /// - Parameter sessionId: The unique identifier for the user session.
    func endSession(_ sessionId: String)
    
    /// Sets or updates the user ID for tracking purposes.
    ///
    /// - Parameter userId: The unique identifier for the user.
    func setUserId(_ userId: String)
    
    /// Logs multiple events in a batch.
    ///
    /// - Parameters:
    ///   - events: An array of events to be logged, where each event includes the event name and optional parameters.
    func logEvents(_ events: [(eventName: String, parameters: [String: Any]?)])
}
