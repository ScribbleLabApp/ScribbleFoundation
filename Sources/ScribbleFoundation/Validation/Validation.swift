//
//  Validation.swift
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

/// A utility class for common data validation tasks.
///
/// This class provides static methods for validating common data types such as email addresses and passwords.
/// It uses regular expressions to perform the validations and ensure the data meets the specified criteria.
///
/// You can use Validation as following:
/// ```swift
/// let isEmailValid = Validation.isValidEmail("example@domain.com")
/// let isPasswordStrong = Validation.isStrongPassword("Password123")
/// ```
@available(iOS 18.0, macOS 15.0, *)
public final class Validation: Validatable {
    
    /// Validates if the given string is a valid email address.
    ///
    /// The method uses a regular expression to check if the email address conforms to a standard format.
    ///
    /// - Parameter email: The email address to validate.
    /// - Returns: A boolean indicating whether the email address is valid.
    ///
    /// The regular expression pattern used is:
    /// ```
    /// [A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Z]{2,}
    /// ```
    /// This pattern matches common email address formats and is case insensitive.
    public static func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Z]{2,}", options: .caseInsensitive)
        let matches = regex.matches(in: email, options: [], range: NSRange(location: 0, length: email.count))
        return matches.count > 0
    }
    
    /// Validates if the given string is a strong password.
    ///
    /// A strong password is defined as having at least 8 characters, including one uppercase letter,
    /// one lowercase letter, and one number.
    ///
    /// - Parameter password: The password to validate.
    /// - Returns: A boolean indicating whether the password is strong.
    ///
    /// The regular expression pattern used is:
    /// ```
    /// (?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}
    /// ```
    /// This pattern ensures that the password includes at least one lowercase letter, one uppercase letter,
    /// and one digit, and is at least 8 characters long.
    public static func isStrongPassword(_ password: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}", options: [])
        let matches = regex.matches(in: password, options: [], range: NSRange(location: 0, length: password.count))
        return matches.count > 0
    }
}
