//
//  Validatable.swift
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

/// A protocol for objects that can validate their state or data.
///
/// Conforming types implement a validation mechanism to check the integrity, correctness, or compliance of their state or data.
/// This is useful for ensuring that data or objects meet certain criteria before being processed or used.
@available(iOS 18.0, macOS 15.0, *)
public protocol Validatable {
    
    /// Checks if the provided email address is valid.
    ///
    /// This static method validates the format of an email address based on standard email formatting rules.
    /// It is a utility function that can be used to determine if an email address meets common standards.
    ///
    /// - Parameter email: The email address to validate.
    /// - Returns: `true` if the email address is valid according to the formatting rules,
    ///   or `false` otherwise.
    static func isValidEmail(_ email: String) -> Bool
    
    /// Checks if the provided password is strong.
    ///
    /// This static method evaluates the strength of a password based on common security criteria.
    /// It typically involves checking for minimum length, inclusion of various character types, and other security measures.
    ///
    /// - Parameter password: The password to validate.
    /// - Returns: `true` if the password meets the strength criteria,
    ///   or `false` otherwise.
    static func isStrongPassword(_ password: String) -> Bool
}
