//
//  Serialization.swift
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

/// A class for serializing and deserializing objects that conform to `Codable`.
///
/// The `Serialization` class provides functionality to convert objects to and from JSON strings and data. It is generic over
/// a type that conforms to `Codable`, allowing for flexible and reusable serialization and deserialization operations.
///
/// This class implements the `Serializable` protocol, which includes methods for converting objects to JSON strings and data,
/// and initializing objects from JSON strings.
///
/// - Note: Ensure that the type `T` conforms to `Codable` for proper functionality.
///
/// - Parameter T: A type that conforms to `Codable`.
///
/// You can use Serialization as following:
/// ```swift
/// struct User: Codable {
///     let name: String
///     let age: Int
/// }
///
/// let user = User(name: "John Doe", age: 30)
/// let serialization = Serialization<User>(instance: user)
///
/// do {
///     let jsonString = try serialization.toJSON()
///     print(jsonString)
///
///     let jsonData = try serialization.encode()
///     let decodedUser = try Serialization<User>.decode(from: jsonData)
/// } catch {
///     print("Serialization error: \(error)")
/// }
/// ```
@available(iOS 18.0, macOS 15.0, *)
public class Serialization<T: Codable>: Serializable {
    
    private var instance: T
    
    /// Initializes a `Serialization` instance with a codable object.
    ///
    /// - Parameter instance: The object to be serialized or deserialized. This object must conform to `Codable`.
    /// - Note: The instance is cast to type `T`, which must also conform to `Codable`.
    public init(instance: Codable) {
        self.instance = instance as! T
    }
    
    /// Converts the object to a JSON string.
    ///
    /// - Returns: A JSON string representation of the object.
    /// - Throws: `SerializableError.encodingFailed` if encoding to JSON fails.
    public func toJSON() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder.encode(instance)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw SerializableError.encodingFailed
        }
        
        return jsonString
    }
    
    /// Initializes an object from a JSON string.
    ///
    /// - Parameter json: A JSON string representation of the object.
    /// - Returns: An instance of the object initialized with the JSON data.
    /// - Throws: `SerializableError.decodingFailed` if decoding from JSON fails.
    public static func fromJSON(_ json: String) throws -> T {
        let data = json.data(using: .utf8) ?? Data()
        return try decode(from: data)
    }
    
    /// Encodes the object to a JSON `Data` object.
    ///
    /// - Returns: A `Data` object representing the JSON encoding of the object.
    /// - Throws: `SerializableError.encodingFailed` if encoding to JSON fails.
    public func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(instance)
    }
    
    /// Decodes an object from a JSON `Data` object.
    ///
    /// - Parameter data: A `Data` object representing the JSON data.
    /// - Returns: An instance of the object decoded from the JSON data.
    /// - Throws: `SerializableError.decodingFailed` if decoding from JSON fails.
    public static func decode(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
