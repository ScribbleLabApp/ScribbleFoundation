//
//  ExceptionHandling.swift
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

/// A protocol for handling exceptions and generating crash reports.
///
/// The `ExceptionHandling` protocol defines methods and properties for managing exceptions, generating crash reports,
/// and sending those reports to a specified endpoint. It helps to capture, record, and report exceptions in a consistent manner.
/// This is useful for debugging and monitoring the stability of applications.
@available(iOS 18.0, macOS 15.0, *)
public protocol ExceptionHandling {
    
    /// A boolean indicating if an exception has occurred.
    ///
    /// This property is used to check whether an exception has been recorded or detected. It allows the application
    /// to respond appropriately if an exception has occurred and needs to be addressed.
    var hasExceptionOccurred: Bool { get }
    
    /// Handles an uncaught exception.
    ///
    /// This method is called to handle exceptions that were not caught by the application's standard exception handling mechanisms.
    ///
    /// - Parameter exception: The uncaught exception to handle. This is an instance of `NSException` that
    ///                        contains details about the error.
    func handleException(_ exception: NSException)
    
    /// Handles a signal-based crash.
    ///
    /// This method is used to handle crashes that occur due to signals, such as segmentation faults or illegal instruction signals.
    ///
    /// - Parameter signal: The signal that caused the crash. This is an integer value representing the signal number.
    func handleSignal(_ signal: Int32)
    
    /// Records an exception with a description and additional context.
    ///
    /// This method records the details of an exception along with a description and any additional context to help diagnose the issue.
    ///
    /// - Parameters:
    ///   - exception: The error or exception that occurred. This is an instance of `Error` that provides information about the failure.
    ///   - description: A brief description of the context in which the exception occurred. This helps provide additional information about the error.
    ///   - additionalContext: Optional additional context or metadata about the exception. This can include relevant information that
    ///                        may aid in debugging.
    func recordException(_ exception: Error, description: String, additionalContext: [String: Any]?)
    
    /// Generates a crash report containing details of the recorded exceptions.
    ///
    /// This method compiles a report based on the recorded exceptions and other relevant details. The report can be used for debugging and analysis.
    ///
    /// - Returns: A string representation of the crash report. This includes the details of the exceptions and any other relevant information.
    func generateCrashReport() -> String
    
    /// Sends the crash report to a specified endpoint.
    ///
    /// This method sends the generated crash report to a server or endpoint for further analysis or storage.
    ///
    /// - Parameters:
    ///   - endpoint: The URL to which the crash report should be sent. This is the destination where the report will be uploaded.
    /// - Throws: An error if the crash report cannot be sent. This includes network errors or issues with the endpoint.
    func sendCrashReport(to endpoint: URL) async throws
    
    /// Resets the exception state, clearing any recorded exceptions.
    ///
    /// This method clears any recorded exceptions and resets the state, preparing the system to handle new exceptions.
    func resetExceptionState()
}
