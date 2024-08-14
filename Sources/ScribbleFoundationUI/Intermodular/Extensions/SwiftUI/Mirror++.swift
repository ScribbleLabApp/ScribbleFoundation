//
//  Mirror++.swift
//  ScribbleFoundationUI
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
//     contributors may be used to endorse or promote products derived from this
//     software without specific prior written permission.
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

import SwiftUI

extension Mirror {
    
    /// Retrieves the value from the `Mirror`'s children using a dot-separated key path.
    ///
    /// This subscript allows accessing nested values within a `Mirror` instance
    /// using a dot-separated string key path. It searches for the first matching
    /// child with the label that corresponds to the first component of the key path.
    /// If there are more components, it recursively searches within the found child.
    ///
    /// - Parameter path: A dot-separated string representing the key path to the desired
    ///   value. The key path should be in the format `"childName.subChildName"`, where
    ///   each segment corresponds to a child label in the `Mirror`'s children.
    ///
    /// - Returns: The value at the specified key path if found; otherwise, `nil`. If the
    ///   key path is empty, it triggers an assertion failure and returns `nil`.
    ///
    /// ```swift
    /// struct Example {
    ///     let nested = Nested(value: "Hello")
    /// }
    /// struct Nested {
    ///     let value: String
    /// }
    ///
    /// let example = Example()
    /// let mirror = Mirror(reflecting: example)
    /// let value = mirror[_ScribbleFoundation_keyPath: "nested.value"] as? String
    /// print(value)  // Prints: Optional("Hello")
    /// ```
    ///
    /// - Note: This subscript is intended for internal use and debugging purposes,
    ///   and it assumes that the key path is valid and corresponds to existing children
    ///   within the `Mirror`. An empty path will cause an assertion failure.
    subscript(_ScribbleFoundation_keyPath path: String) -> Any? {
        guard !path.isEmpty else {
            assertionFailure()
            
            return nil
        }
        
        var components = path.components(separatedBy: ".")
        let first = components.removeFirst()
        
        guard let value = children.first(where: { $0.label == first })?.value else {
            return nil
        }
        
        if components.isEmpty {
            return value
        } else {
            return Mirror(reflecting: value)[_ScribbleFoundation_keyPath: components.joined(separator: ".")]
        }
    }
    
    /// Iterates over the children of a `Mirror` instance and applies the provided action.
    ///
    /// This method allows performing an action on each child of a `Mirror` instance.
    /// It is useful for inspecting or processing the children of an object in a
    /// reflective manner.
    ///
    /// - Parameters:
    ///   - object: The object to be inspected. It will be reflected using `Mirror`.
    ///   - action: A closure that takes a `Mirror.Child` as its parameter. This closure
    ///     will be executed for each child of the reflected object.
    ///
    /// ```swift
    /// struct Example {
    ///     let first = 1
    ///     let second = 2
    /// }
    ///
    /// let example = Example()
    /// Mirror.inspect(example) { child in
    ///     print("Label: \(child.label ?? "nil"), Value: \(child.value)")
    /// }
    /// // Prints:
    /// // Label: Optional("first"), Value: 1
    /// // Label: Optional("second"), Value: 2
    /// ```
    ///
    /// - Note: The `inspect` method is intended for debugging and inspection purposes.
    ///   It provides a way to explore the structure of objects at runtime.
    static func inspect(
        _ object: Any,
        with action: (Mirror.Child) -> Void
    ) {
        Mirror(reflecting: object).children.forEach(action)
    }
}
