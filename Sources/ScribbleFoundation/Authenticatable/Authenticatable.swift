//
//  Authenticatable.swift
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

/// A protocol for user authentication and management.
///
/// This protocol defines methods for logging in, creating users, loading user data, signing out, and resetting passwords.
/// It is intended to be used in environments that support asynchronous tasks and main actor operations.
@available(iOS 18.0, macOS 15.0, *)
public protocol Authenticatable {

    /// The associated type for user roles.
    associatedtype UserRole
    
    /// Logs in a user with the specified email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password associated with the user's account.
    /// - Throws: An error if the login process fails.
    /// - Main Actor: This method should be called on the main thread.
    @MainActor
    func logIn(withEmail email: String, password: String) async throws
    
    /// Creates a new user with the specified email, password, and username.
    ///
    /// - Parameters:
    ///   - email: The email address for the new user.
    ///   - password: The password for the new user.
    ///   - username: The username for the new user.
    /// - Throws: An error if the user creation process fails.
    /// - Main Actor: This method should be called on the main thread.
    @MainActor
    func createUser(email: String, password: String, username: String) async throws
    
    /// Loads the current user's data.
    ///
    /// - Throws: An error if loading the user data fails.
    /// - Main Actor: This method should be called on the main thread.
    @MainActor
    func loadUserData() async throws
    
    /// Signs out the currently authenticated user.
    ///
    /// This method does not throw errors. It performs the sign-out operation and updates the state accordingly.
    func signOut()
    
    /// Resets the password for the user with the specified email address.
    ///
    /// - Parameters:
    ///   - email: The email address associated with the user account for which the password should be reset.
    ///   - resetCompletion: A closure that is called with the result of the reset operation. It returns a `Result`
    ///                      containing a boolean indicating success or failure and an optional error.
    /// - Main Actor: This method should be called on the main thread.
    @MainActor
    static func resetPassword(email: String, resetCompletion:@escaping (Result<Bool, Error>) -> Void)

    /// Uploads user data to Firestore.
    ///
    /// This private function creates a user object using the provided details, sets it as the current user,
    /// encodes it, and then uploads it to Firestore.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier for the user.
    ///   - username: The username associated with the user.
    ///   - email: The email address associated with the user.
    ///   - usrRole: The role of the user (intern, developer, etc.).
    ///   - hasPremium: A Boolean indicating whether the user has a premium account.
    ///
    /// - Note: This function sets the current user with the provided details and uploads it to Firestore.
    ///         It is a private function and should be called from within the `SLAuthService`.
    ///
    /// > WARNING
    /// > This function is called internally by the `SLAuthService` and should not typically be accessed directly.
    func uploadUserData(
        uid: String,
        username: String,
        email: String,
        usrRole: UserRole,
        hasPremium: Bool
    ) async
}
