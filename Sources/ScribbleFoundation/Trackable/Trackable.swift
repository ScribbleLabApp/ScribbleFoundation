//
//  Trackable.swift
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

/// A protocol for objects that can track and update their progress or state.
///
/// Conforming types implement mechanisms to track their progress or state, as well as update it.
/// This protocol provides a way to monitor and modify progress, which can be useful in scenarios such as
/// downloading files, processing tasks, or managing ongoing operations.
@available(iOS 18.0, macOS 15.0, *)
public protocol Trackable: Cancellable {
    
    /// The current progress or state.
    ///
    /// This property represents the current level of progress or state of the conforming object.
    /// The value is typically a percentage or a ratio between 0.0 (no progress) and 1.0 (complete).
    var progress: Double { get }
    
    /// Updates the current progress or state.
    ///
    /// This method allows the progress or state of the conforming object to be updated with a new value.
    /// The new progress value should be within the valid range, typically between 0.0 and 1.0.
    ///
    /// - Parameter newProgress: The new progress or state value to be set. This value is a `Double`
    ///   representing the updated progress or state. It should be between 0.0 and 1.0.
    func updateProgress(to newProgress: Double)
}
