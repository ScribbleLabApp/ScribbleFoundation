//
//  AnalyticsLogger.swift
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

/// A concrete implementation of the `Analytics` protocol for logging and tracking events.
///
/// `AnalyticsLogger` provides a basic implementation for logging events, errors, and user
/// sessions. It also supports setting user IDs and batch logging of events.
///
/// - Note: This implementation prints log messages to the console for demonstration purposes.
@available(iOS 18.0, macOS 15.0, *)
public final class AnalyticsLogger: Analytics {
    
    private var currentSessionId: String?
    private var userId: String?
    
    /// Logs an event with optional parameters.
    ///
    /// - Parameters:
    ///   - eventName: The name of the event to be logged.
    ///   - parameters: Optional dictionary of parameters associated with the event.
    public func logEvent(
        _ eventName: String,
        parameters: [String: Any]?
    ) {
        print("Logging event: \(eventName), parameters: \(String(describing: parameters))")
    }
    
    /// Logs an error event with optional parameters.
    ///
    /// - Parameters:
    ///   - error: The error to be logged.
    ///   - parameters: Optional dictionary of parameters associated with the error.
    public func logError(
        _ error: Error,
        parameters: [String: Any]?
    ) {
        print("Logging error: \(error.localizedDescription), parameters: \(String(describing: parameters))")
    }
    
    /// Logs a custom event with a specified log level.
    ///
    /// - Parameters:
    ///   - eventName: The name of the event to be logged.
    ///   - level: The log level for the event.
    ///   - parameters: Optional dictionary of parameters associated with the event.
    public func logEvent(
        _ eventName: String,
        level: _LogLevel,
        parameters: [String: Any]?
    ) {
        print("Logging event: \(eventName), level: \(level.rawValue), parameters: \(String(describing: parameters))")
    }
    
    /// Tracks the start of a user session.
    ///
    /// - Parameter sessionId: The unique identifier for the user session.
    public func startSession(_ sessionId: String) {
        currentSessionId = sessionId
        print("Started session: \(sessionId)")
    }
    
    /// Tracks the end of a user session.
    ///
    /// - Parameter sessionId: The unique identifier for the user session.
    public func endSession(_ sessionId: String) {
        guard currentSessionId == sessionId else { return }
        currentSessionId = nil
        print("Ended session: \(sessionId)")
    }
    
    /// Sets or updates the user ID for tracking purposes.
    ///
    /// - Parameter userId: The unique identifier for the user.
    public func setUserId(_ userId: String) {
        self.userId = userId
        print("Set user ID: \(userId)")
    }
    
    /// Logs multiple events in a batch.
    ///
    /// - Parameters:
    ///   - events: An array of events to be logged, where each event includes the event name and optional parameters.
    public func logEvents(
        _ events: [
            (eventName: String,
             parameters: [String: Any]?)
    ]) {
        for event in events {
            logEvent(event.eventName, parameters: event.parameters)
        }
    }
}

/// Enumeration for custom log levels.
///
/// - debug: Logs detailed information for debugging purposes.
/// - info: Logs general informational messages.
/// - warning: Logs warnings that may indicate potential issues.
/// - error: Logs errors that indicate a failure or issue.
/// - critical: Logs critical errors that require immediate attention.
@available(iOS 18.0, macOS 15.0, *)
public enum _LogLevel: String {
    case debug
    case info
    case warning
    case error
    case critical
}
