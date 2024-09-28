//
//  SUUpdateAvailability.swift
//  UpdateService
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

import Foundation

/// A protocol to check if updates are available for a user.
///
/// The `SUUpdateAvailability` protocol defines methods and properties to check
/// whether an update is available for a specific user. It includes both a
/// property to quickly verify update availability and an asynchronous method
/// to perform the update check.
@available(iOS 18.0, macOS 15.0, *)
public protocol SUUpdateAvailability: AnyObject {
    
    /// The type representing a user.
    ///
    /// `User` represents the current user who has a valid app session,
    /// and for whom the update check will be performed. This type typically
    /// includes information such as the user's account ID, authentication token,
    /// or any other relevant data required to identify the session.
    associatedtype User
    
    /// A Boolean value indicating whether an update is available.
    ///
    /// This property provides a quick way to check if an update is available
    /// for the current user. It may represent a cached or previously checked state.
    var isAvailableForUser: Bool { get }
    
    /// Checks the update availability for the given user asynchronously.
    ///
    /// This method checks whether an update is available for the provided `user`.
    /// It uses a completion handler to provide the result of the operation.
    ///
    /// - Parameters:
    ///   - user: The `User` object for which the update availability should be checked.
    ///           This represents the current user with an active session in the app.
    ///   - completion: A completion handler that returns a `Result<Bool, Error>`.
    ///                 The result contains `true` if an update is available,
    ///                 and `false` otherwise. If an error occurs during the
    ///                 check, an appropriate `Error` is returned.
    ///
    /// - Throws: An error if the update check fails, such as network errors or
    ///           invalid responses.
    func checkUserUpdateAvailability(
        user: User,
        completion: @Sendable @escaping (Result<Bool, SUError>) -> Void
    ) async throws
}
