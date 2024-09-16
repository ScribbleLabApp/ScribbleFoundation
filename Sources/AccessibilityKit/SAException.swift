//
//  SAException.swift
//  AccessibilityKit
//
//  Copyright (c) 2024 ScribbleLabApp LLC. All rights reserved
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this
//     list of conditions and the following disclaimer in the documentation
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
//

import Foundation
import ScribbleFoundation

public enum SAError: Error {
    case failedConfig(UInt16)
    case unsupportedFeature(String)
    case accessibilityNotEnabled(UInt16)
    case invalidAccessibilityElement(UInt16)
    case focusFailure
    case missingLabel
    case actionNotAvailable(UInt16)
    case hapticError(String)
    case invalidTraits(UInt16)
    case viewNotFound(UInt16)
    case missingHint
    case dynamicTextSizeUnsupported
    case gestureRecognitionFailed
    case systemVersionIncompatible(String)
    case insufficientPermissions(UInt16)
    case unknown(UInt16)
    
    var errorCodes: CustomStringConvertible {
        switch self {
        case .failedConfig(let uInt16):
            return -300
        case .unsupportedFeature(let string):
            return string
        case .accessibilityNotEnabled(let uInt16):
            return -301
        case .invalidAccessibilityElement(let uInt16):
            return -302
        case .focusFailure:
            return -303
        case .missingLabel:
            return -304
        case .actionNotAvailable(let uInt16):
            return -305
        case .hapticError(let string):
            return string
        case .invalidTraits(let uInt16):
            return -306
        case .viewNotFound(let uInt16):
            return -307
        case .missingHint:
            return -308
        case .dynamicTextSizeUnsupported:
            return -309
        case .gestureRecognitionFailed:
            return -310
        case .systemVersionIncompatible(let string):
            return string
        case .insufficientPermissions(let uInt16):
            return -311
        case .unknown(let uInt16):
            return -399
        }
    }
}

/// A class to handle custom exceptions for accessibility-related errors in the application.
///
/// The `SAException` class allows for better management of unexpected accessibility failures or edge cases
/// that can affect the user experience, particularly those involving VoiceOver, dynamic text size, or haptic feedback.
@MainActor
public final class SAException: Error, @preconcurrency CustomStringConvertible {
    
    /// The underlying error causing the exception.
    private let error: SAError
    
    /// A custom message associated with the exception.
    private let message: String
    
    /// Additional context or metadata about the exception.
    private let context: [String: Any]?
    
    /// A timestamp for when the exception was thrown.
    private let timestamp: Date
    
    /// Creates an `SAException` instance with the provided error and message.
    ///
    /// - Parameters:
    ///   - error: The underlying `SAError` that triggered this exception.
    ///   - message: A custom message providing more information about the exception.
    ///   - context: Optional additional context or metadata about the exception.
    public init(
        error: SAError,
        message: String,
        context: [String: Any]? = nil
    ) {
        self.error = error
        self.message = message
        self.context = context
        self.timestamp = Date()
    }
    
    /// A description of the exception, including the error, message, and context.
    public var description: String {
        var output = "[SAException] Error: \(error)\nMessage: \(message)\nTimestamp: \(timestamp)"
        if let context = context {
            output += "\nContext: \(context)"
        }
        return output
    }
    
    /// Logs the exception details to the ScribbleFoundation logging system.
    ///
    /// This method provides a way to record the exception details for future debugging
    /// or analysis. It integrates with `SCRLog` for logging accessibility-specific issues.
    public func logException(
        signal: UInt16,
        message: String
    ) {
        a11yLogger.log(
            "AccessibilityKit has raised an exception with signal (\(signal)) and message '\(message)'",
            with: .info
        )
    }
    
    /// Raises the exception in a controlled manner, capturing the error and logging it.
    ///
    /// - Throws: The captured `SAException`.
    public func raiseException(
        signal: UInt16,
        message: String
    ) throws {
        logException(signal: signal, message: message)
        throw self
    }
    
    /// Handles an exception by throwing it or providing a fallback mechanism.
    ///
    /// This function can be used in critical accessibility operations where certain errors can either be thrown
    /// or handled gracefully with a fallback mechanism.
    ///
    /// - Parameters:
    ///   - fallback: A closure that provides a fallback action if the error should be handled gracefully.
    public func handleWithFallback(_ fallback: () -> Void) {
        do {
            try raiseException(signal: errorCode(), message: message)
        } catch {
            print("Handled with fallback: \(error)")
            fallback()
        }
    }
    
    /// Returns the error code associated with the `SAError`.
    ///
    /// - Returns: A `UInt16` representing the error code for logging or signaling purposes.
    private func errorCode() -> UInt16 {
        switch error {
        case .failedConfig(let code),
             .accessibilityNotEnabled(let code),
             .invalidAccessibilityElement(let code),
             .actionNotAvailable(let code),
             .invalidTraits(let code),
             .viewNotFound(let code),
             .insufficientPermissions(let code),
             .unknown(let code):
            return code
        default:
            return 0
        }
    }
}
