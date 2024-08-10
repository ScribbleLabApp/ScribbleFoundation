//
//  Auditable.swift
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

/// A protocol for logging audit trails with enhanced functionality.
///
/// This protocol defines methods and properties for logging and managing audit trail entries, including
/// the ability to log entries with different severity levels, retrieve the most recent entry, and clear
/// all entries. It also supports setting and retrieving a user ID associated with the audit logs.
@available(iOS 18.0, macOS 15.0, *)
public protocol Auditable {
    
    /// Logs an audit trail entry with a specified level.
    ///
    /// This method logs an audit trail entry, categorizing it by the specified level and including any
    /// additional details about the action performed.
    ///
    /// - Parameters:
    ///   - action: The action performed that is being logged.
    ///   - level: The level of the audit entry, indicating its importance or severity.
    ///   - details: Optional additional details about the action, provided as a dictionary of key-value pairs.
    func logAuditTrail(action: String, level: AuditLevel, details: [String: Any]?)
    
    /// Retrieves the last logged audit trail entry.
    ///
    /// This method returns the most recent audit trail entry that was logged. If no entries exist, it returns `nil`.
    ///
    /// - Returns: The most recent `AuditEntry`, or `nil` if no entry has been logged.
    func getLastAuditEntry() -> AuditEntry?
    
    /// Clears all audit trail entries.
    ///
    /// This method removes all previously logged audit trail entries, effectively resetting the audit log.
    func clearAuditTrail()
    
    /// Sets the user ID for audit trail entries.
    ///
    /// This method allows setting a unique user identifier that will be associated with subsequent audit trail entries.
    ///
    /// - Parameter userId: The unique identifier for the user, which will be included in audit trail entries.
    func setUserId(_ userId: String)
    
    /// Retrieves the current user ID used in audit trail entries.
    ///
    /// This method returns the user ID currently set for audit trail entries. If no user ID has been set, it returns `nil`.
    ///
    /// - Returns: The current user ID, or `nil` if no user ID has been set.
    func getUserId() -> String?
}

/// Enumeration for audit levels.
///
/// This enumeration categorizes the importance or severity of audit entries, providing different levels
/// to indicate the nature of the logged action.
///
/// - `info`: Represents informational messages or actions of general interest.
/// - `warning`: Represents potential issues or situations that may require attention.
/// - `error`: Represents errors or failures that indicate problems in the system.
/// - `critical`: Represents severe issues that may cause significant impact or require immediate attention.
public enum AuditLevel: String {
    case info
    case warning
    case error
    case critical
}

/// Struct for representing an audit trail entry.
///
/// This struct encapsulates the details of an audit trail entry, providing information about the action performed,
/// the level of the entry, the time it was logged, and optionally, the user ID associated with the entry.
///
/// - `action`: The action performed that is being logged.
/// - `level`: The level of the audit entry, indicating its importance or severity.
/// - `timestamp`: The date and time when the audit entry was logged.
/// - `details`: Optional additional details about the action, provided as a dictionary of key-value pairs.
/// - `userId`: Optional user identifier associated with the audit entry.
public struct AuditEntry {
    let action: String
    let level: AuditLevel
    let timestamp: Date
    let details: [String: Any]?
    let userId: String?
}
