//
//  SCRUserDefaultsManager.swift
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

/// A utility class for managing user defaults in a type-safe manner.
///
/// This class provides methods to save and retrieve `Codable` values to and from `UserDefaults`.
/// It ensures that the values are encoded and decoded in a type-safe manner using `JSONEncoder` and `JSONDecoder`.
///
/// To store data in UserDefaults using UserDefaultsManager try this:
/// ```swift
/// let manager = UserDefaultsManager()
/// manager.set("Hello, World!", forKey: "greeting")
/// let greeting: String? = manager.get("greeting")
/// ```
///
@available(iOS 18.0, macOS 15.0, *)
public final class UserDefaultsManager {
    private let defaults = UserDefaults.standard
    
    /// Saves a value to user defaults.
    ///
    /// - Parameters:
    ///   - value: The value to save. Must conform to `Codable`.
    ///   - key: The key to associate with the value.
    ///
    /// This method encodes the value using `JSONEncoder` and stores it in `UserDefaults` under the specified key.
    /// If encoding fails, an error message is printed.
    public func set<T>(_ value: T, forKey key: String) where T: Codable {
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: key)
        } catch {
            print("Failed to save value: \(error)")
        }
    }
    
    /// Retrieves a value from user defaults.
    ///
    /// - Parameter key: The key associated with the value.
    /// - Returns: The value if it exists and can be decoded, otherwise `nil`.
    ///
    /// This method retrieves data from `UserDefaults` for the specified key and decodes it using `JSONDecoder`.
    /// If decoding fails, an error message is printed and `nil` is returned.
    public func get<T>(_ key: String) -> T? where T: Codable {
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to retrieve value: \(error)")
            return nil
        }
    }
}
