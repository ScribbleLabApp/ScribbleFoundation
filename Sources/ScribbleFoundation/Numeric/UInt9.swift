//
//  UInt9.swift
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

/// A type that represents a 9-bit unsigned integer.
///
/// `UInt9` is a custom type that supports values from 0 to 511 (inclusive). It provides basic arithmetic
/// operations, ensures values stay within the 9-bit range, and offers convenient initializers and properties.
///
/// - Note: Internally, `UInt9` uses a `UInt16` to store the value. This choice is made to accommodate the 9-bit
/// range and fit within a standard memory alignment. Most systems handle memory in units of 8, 16, 32, or 64 bits.
/// By using a `UInt16`, we ensure that the value can be easily manipulated using common arithmetic operations while
/// still restricting the value to the 9-bit range.
///
/// ```swift
/// let a: uint9_t = 5
/// let b: UInt9 = 5
/// let c = UInt9(5)
/// print(a) // Output: 5
/// print(b) // Output: 5
/// print(c) // Output: 5
/// ```
public struct UInt9 {
    
    /// The underlying storage for the 9-bit value.
    /// Stored as a `UInt16` to accommodate the 9-bit range.
    private var value: UInt16

    /// The maximum value for a 9-bit unsigned integer (511).
    private static let maxValue: UInt16 = 0x1FF

    /// A bit mask to ensure values fit within 9 bits.
    private static let bitMask: UInt16 = 0x1FF

    /// Initializes a new `UInt9` with a `UInt16` value.
    ///
    /// - Parameter value: A `UInt16` value to initialize the `UInt9`.
    /// Values exceeding the 9-bit range will be truncated.
    ///
    /// Example:
    /// ```swift
    /// let a = UInt9(520)
    /// print(a) // Output: 8 (520 is truncated to fit within 9 bits)
    /// ```
    public init(_ value: UInt16) {
        self.value = value & UInt9.bitMask
    }

    /// Initializes a new `UInt9` with an `Int` value.
    ///
    /// - Parameter value: An `Int` value to initialize the `UInt9`.
    /// Values exceeding the 9-bit range will be truncated.
    ///
    /// Example:
    /// ```swift
    /// let b = UInt9(300)
    /// print(b) // Output: 300
    /// ```
    public init(_ value: Int) {
        self.value = UInt16(value) & UInt9.bitMask
    }

    /// Initializes a new `UInt9` with an integer literal.
    ///
    /// - Parameter value: An integer literal to initialize the `UInt9`.
    ///
    /// Example:
    /// ```swift
    /// let a: uint9_t = 5
    /// let b: UInt9 = 300
    /// print(a + b) // Output: 305
    /// ```
    public init(integerLiteral value: Int) {
        self.value = UInt16(value) & UInt9.bitMask
    }

    /// Returns the integer value of the `UInt9` as an `Int`.
    ///
    /// Example:
    /// ```swift
    /// let a = UInt9(5)
    /// print(a.intValue) // Output: 5
    /// ```
    public var intValue: Int {
        return Int(value)
    }
}

/// Define a type alias `uint9_t` for `UInt9`.
public typealias uint9_t = UInt9

// MARK: - Arithmetic Operations
public extension UInt9 {
    
    /// Adds two `UInt9` values.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt9` value.
    ///   - rhs: Another `UInt9` value.
    /// - Returns: The sum of the two values, truncated to fit within 9 bits.
    ///
    /// Example:
    /// ```swift
    /// let a: uint9_t = 5
    /// let b: UInt9 = 300
    /// let c = a + b
    /// print(c) // Output: 305
    /// ```
    static func +(lhs: UInt9, rhs: UInt9) -> UInt9 {
        return UInt9(lhs.value + rhs.value)
    }

    /// Subtracts one `UInt9` value from another.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt9` value.
    ///   - rhs: Another `UInt9` value.
    /// - Returns: The difference of the two values, truncated to fit within 9 bits.
    ///
    /// Example:
    /// ```swift
    /// let a: uint9_t = 305
    /// let b: UInt9 = 5
    /// let c = a - b
    /// print(c) // Output: 300
    /// ```
    static func -(lhs: UInt9, rhs: UInt9) -> UInt9 {
        return UInt9(lhs.value - rhs.value)
    }

    /// Multiplies two `UInt9` values.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt9` value.
    ///   - rhs: Another `UInt9` value.
    /// - Returns: The product of the two values, truncated to fit within 9 bits.
    ///
    /// Example:
    /// ```swift
    /// let a: uint9_t = 5
    /// let b: UInt9 = 6
    /// let c = a * b
    /// print(c) // Output: 30
    /// ```
    static func *(lhs: UInt9, rhs: UInt9) -> UInt9 {
        return UInt9(lhs.value * rhs.value)
    }

    /// Divides one `UInt9` value by another.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt9` value.
    ///   - rhs: Another `UInt9` value.
    /// - Returns: The quotient of the two values, truncated to fit within 9 bits.
    ///
    /// Example:
    /// ```swift
    /// let a: uint9_t = 300
    /// let b: UInt9 = 5
    /// let c = a / b
    /// print(c) // Output: 60
    /// ```
    static func /(lhs: UInt9, rhs: UInt9) -> UInt9 {
        return UInt9(lhs.value / rhs.value)
    }

    /// Returns the remainder of dividing one `UInt9` value by another.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt9` value.
    ///   - rhs: Another `UInt9` value.
    /// - Returns: The remainder of the division, truncated to fit within 9 bits.
    ///
    /// Example:
    /// ```swift
    /// let a: uint9_t = 305
    /// let b: UInt9 = 300
    /// let c = a % b
    /// print(c) // Output: 5
    /// ```
    static func %(lhs: UInt9, rhs: UInt9) -> UInt9 {
        return UInt9(lhs.value % rhs.value)
    }
}

// MARK: - CustomStringConvertible
extension UInt9: CustomStringConvertible {
    
    /// A textual representation of the `UInt9` value.
    ///
    /// Example:
    /// ```swift
    /// let a: uint9_t = 5
    /// print(a) // Output: 5
    /// ```
    public var description: String {
        return "\(intValue)"
    }
}

// MARK: - Equatable
extension UInt9: Equatable {
    
    /// Compares two `UInt9` values for equality.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt9` value.
    ///   - rhs: Another `UInt9` value.
    /// - Returns: `true` if the values are equal, otherwise `false`.
    ///
    /// Example:
    /// ```swift
    /// let a: uint9_t = 5
    /// let b: UInt9 = 5
    /// print(a == b) // Output: true
    /// ```
    public static func ==(lhs: UInt9, rhs: UInt9) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - Comparable
extension UInt9: Comparable {
    
    /// Compares two `UInt9` values to determine if the first is less than the second.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt9` value.
    ///   - rhs: Another `UInt9` value.
    /// - Returns: `true` if the first value is less than the second, otherwise `false`.
    ///
    /// ```swift
    /// let a: uint9_t = 5
    /// let b: UInt9 = 10
    /// print(a < b) // Output: true
    /// ```
    static func <(lhs: UInt9, rhs: UInt9) -> Bool {
        return lhs.value < rhs.value
    }
    
    /// Compares two `UInt9` values to determine if the second is less than the first.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt9` value.
    ///   - rhs: Another `UInt9` value.
    /// - Returns: `true` if the second value is less than the first, otherwise `false`.
    ///
    /// ```swift
    /// let a: uint9_t = 5
    /// let b: UInt9 = 10
    /// print(a > b) // Output: false
    /// ```
    static func >(lhs: UInt9, rhs: UInt9) -> Bool {
        return lhs.value > rhs.value
    }
    
    public func compare(with other: UInt9) -> ComparisonResult {
        if self.value < other.value {
            return .orderedAscending
        } else if self.value > other.value {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
}
