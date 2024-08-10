//
//  SCRLog.swift
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

import os
import Foundation

@available(iOS 18.0, macOS 15.0, *)
public struct SCRLog {
    
    /// The subsystem to categorize log messages.
    ///
    /// This is typically used to represent the application or module generating the log messages.
    /// Example: use the bundle identifier of your app to provide a unique subsystem.
    public let subsystem: String
    
    /// The category within the subsystem to further categorize log messages.
    ///
    /// This provides a finer level of granularity for organizing log messages.
    public var category: Category
    
    
    /// Initializes a new `SCRLog` instance with the provided subsystem and category.
    ///
    /// - Parameters:
    ///   - subsystem: The subsystem to categorize log messages. Typically, you'd use the bundle identifier of your app.
    ///   - category: The category within the subsystem to further categorize log messages.
    public init(subsystem: String, category: Category) {
        self.subsystem = subsystem
        self.category = category
    }
    
    /// Creates a `Logger` instance configured with the specified subsystem and category.
    ///
    /// - Parameter category: The category of log messages for this `Logger` instance.
    /// - Returns: A `Logger` instance configured with the current subsystem and the provided category.
    public func logger(for category: Category) -> Logger {
        return Logger(subsystem: subsystem, category: category.rawValue)
    }
    
    
    /// Enumeration of log message categories.
    ///
    /// Categories help to classify log messages into different types of information.
    public enum Category: String {
        case error
        case debug
        case warning
        case memoryWarning
        case log
        
        /// Returns a string representation of the category for logging purposes.
        ///
        /// - Returns: A string representing the category.
        var categoryName: String {
            switch self {
            case .error: return "ERROR"
            case .debug: return "DEBUG"
            case .warning: return "WARNING"
            case .memoryWarning: return "MEM_WARNING"
            case .log: return "LOG"
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public extension SCRLog {
    
    /// Logs an error message.
    ///
    /// - Parameters:
    ///   - message: The error message to log.
    func error(_ message: String) {
        let logger = self.logger(for: .error)
        logger.error("ERROR: \(message)")
    }
    
    /// Logs a debug message.
    ///
    /// - Parameters:
    ///   - message: The debug message to log.
    func debug(_ message: String) {
        let logger = self.logger(for: .debug)
        logger.debug("DEBUG: \(message)")
    }
    
    /// Logs a warning message.
    ///
    /// - Parameters:
    ///   - message: The warning message to log.
    func warning(_ message: String) {
        let logger = self.logger(for: .warning)
        logger.warning("WARNING: \(message)")
    }
    
    /// Logs a memory warning message.
    ///
    /// - Parameters:
    ///   - message: The memory warning message to log.
    func memoryWarning(_ message: String) {
        let logger = self.logger(for: .memoryWarning)
        logger.warning("MEM_WARNING: \(message)")
    }
    
    /// Logs a general message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    func log(_ message: String) {
        let logger = self.logger(for: .log)
        logger.log("LOG: \(message)")
    }
}
