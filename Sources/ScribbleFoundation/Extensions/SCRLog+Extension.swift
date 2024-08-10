//
//  SCRLog+Extension.swift
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
public extension SCRLog {
    
    /// Logs a custom message with a specific log level.
    ///
    /// This method creates a `Logger` instance with the specified category and logs the provided message with the given log level prefix.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - level: The log level to use for the message.
    func log(_ message: String, with level: LogLevel) {
        let logger = self.logger(for: level.category)
        logger.log("\(level.prefix): \(message)")
    }
    
    /// Enumeration of custom log levels.
    ///
    /// Custom log levels help to define additional granularity for log messages.
    enum LogLevel {
        case info
        case trace
        
        /// Returns the category and prefix for the log level.
        var category: Category {
            switch self {
            case .info: return .log
            case .trace: return .debug
            }
        }
        
        var prefix: String {
            switch self {
            case .info: return "INFO"
            case .trace: return "TRACE"
            }
        }
    }
}
