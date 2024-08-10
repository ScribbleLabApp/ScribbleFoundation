//
//  Cancellable.swift
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

/// A protocol for managing cancellable tasks.
///
/// This protocol defines methods for canceling tasks and checking their cancellation status.
/// It can be useful for handling asynchronous tasks that may need to be canceled before completion.
@available(iOS 18.0, macOS 15.0, *)
public protocol Cancellable {
    /// Cancels the task.
    ///
    /// This method should be called to terminate the ongoing task or operation. Implementations
    ///  should ensure that the task is properly stopped and any resources are released.
    func cancel()
    
    /// A boolean indicating whether the task has been cancelled.
    ///
    /// - Returns: A boolean value `true` if the task has been cancelled, otherwise `false`.
    func isCancelled() -> Bool
    
    /// Registers a callback to be executed when the task is cancelled.
    ///
    /// - Parameter callback: A closure to be executed when the task is cancelled.
    func onCancel(_ callback: @escaping () -> Void)
    
    /// Resumes the task if it was paused or interrupted due to cancellation.
    ///
    /// - Throws: An error if the task cannot be resumed.
    /// - Note: This method is optional and only applicable if the implementation supports resuming tasks.
    func resume() throws
}
