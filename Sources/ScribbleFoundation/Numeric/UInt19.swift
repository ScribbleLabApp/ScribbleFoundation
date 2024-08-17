//
//  UInt19.swift
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

/// A type that represents a 19-bit unsigned integer.
///
/// `UInt19` is a custom type that supports values from 0 to 524287 (inclusive). It provides basic arithmetic
/// operations, ensures values stay within the 19-bit range, and offers convenient initializers and properties.
///
/// - Note: Internally, `UInt19` uses a `UInt32` to store the value. This choice is made to accommodate the 19-bit
/// range and fit within a standard memory alignment. Most systems handle memory in units of 8, 16, 32, or 64 bits.
/// By using a `UInt32`, we ensure that the value can be easily manipulated using common arithmetic operations while
/// still restricting the value to the 19-bit range.
///
/// ```swift
/// let a: uint19_t = 5
/// let b: UInt19 = 5
/// let c = UInt19(5)
/// print(a) // Output: 5
/// print(b) // Output: 5
/// print(c) // Output: 5
/// ```
public struct UInt19 {
    
    /// The underlying storage for the 19-bit value.
    /// Stored as a `UInt32` to accommodate the 19-bit range.
    private var value: UInt32

    /// The maximum value for a 19-bit unsigned integer (524287).
    private static let maxValue: UInt32 = 0x7FFFF

    /// A bit mask to ensure values fit within 19 bits.
    private static let bitMask: UInt32 = 0x7FFFF

    /// Initializes a new `UInt19` with a `UInt32` value.
    ///
    /// - Parameter value: A `UInt32` value to initialize the `UInt19`.
    /// Values exceeding the 19-bit range will be truncated.
    ///
    /// ```swift
    /// let a = UInt19(530000)
    /// print(a) // Output: 5896 (530000 is truncated to fit within 19 bits)
    /// ```
    public init(_ value: UInt32) {
        self.value = value & UInt19.bitMask
    }

    /// Initializes a new `UInt19` with an `Int` value.
    ///
    /// - Parameter value: An `Int` value to initialize the `UInt19`.
    /// Values exceeding the 19-bit range will be truncated.
    ///
    /// ```swift
    /// let b = UInt19(300)
    /// print(b) // Output: 300
    /// ```
    public init(_ value: Int) {
        self.value = UInt32(value) & UInt19.bitMask
    }

    /// Initializes a new `UInt19` with an integer literal.
    ///
    /// - Parameter value: An integer literal to initialize the `UInt19`.
    ///
    /// ```swift
    /// let a: uint19_t = 5
    /// let b: UInt19 = 300
    /// print(a + b) // Output: 305
    /// ```
    public init(integerLiteral value: Int) {
        self.value = UInt32(value) & UInt19.bitMask
    }

    /// Returns the integer value of the `UInt19` as an `Int`.
    ///
    /// ```swift
    /// let a = UInt19(5)
    /// print(a.intValue) // Output: 5
    /// ```
    public var intValue: Int {
        return Int(value)
    }
}

/// Define a type alias `uint19_t` for `UInt19`.
public typealias uint19_t = UInt19

// MARK: - Arithmetic Operations
public extension UInt19 {
    
    /// Adds two `UInt19` values.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt19` value.
    ///   - rhs: Another `UInt19` value.
    /// - Returns: The sum of the two values, truncated to fit within 19 bits.
    ///
    /// ```swift
    /// let a: uint19_t = 5
    /// let b: UInt19 = 300
    /// let c = a + b
    /// print(c) // Output: 305
    /// ```
    static func +(lhs: UInt19, rhs: UInt19) -> UInt19 {
        return UInt19(lhs.value + rhs.value)
    }

    /// Subtracts one `UInt19` value from another.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt19` value.
    ///   - rhs: Another `UInt19` value.
    /// - Returns: The difference of the two values, truncated to fit within 19 bits.
    ///
    /// ```swift
    /// let a: uint19_t = 305
    /// let b: UInt19 = 5
    /// let c = a - b
    /// print(c) // Output: 300
    /// ```
    static func -(lhs: UInt19, rhs: UInt19) -> UInt19 {
        return UInt19(lhs.value - rhs.value)
    }

    /// Multiplies two `UInt19` values.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt19` value.
    ///   - rhs: Another `UInt19` value.
    /// - Returns: The product of the two values, truncated to fit within 19 bits.
    ///
    /// ```swift
    /// let a: uint19_t = 5
    /// let b: UInt19 = 6
    /// let c = a * b
    /// print(c) // Output: 30
    /// ```
    static func *(lhs: UInt19, rhs: UInt19) -> UInt19 {
        return UInt19(lhs.value * rhs.value)
    }

    /// Divides one `UInt19` value by another.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt19` value.
    ///   - rhs: Another `UInt19` value.
    /// - Returns: The quotient of the two values, truncated to fit within 19 bits.
    ///
    /// ```swift
    /// let a: uint19_t = 300
    /// let b: UInt19 = 5
    /// let c = a / b
    /// print(c) // Output: 60
    /// ```
    static func /(lhs: UInt19, rhs: UInt19) -> UInt19 {
        return UInt19(lhs.value / rhs.value)
    }

    /// Returns the remainder of dividing one `UInt19` value by another.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt19` value.
    ///   - rhs: Another `UInt19` value.
    /// - Returns: The remainder of the division, truncated to fit within 19 bits.
    ///
    /// ```swift
    /// let a: uint19_t = 305
    /// let b: UInt19 = 300
    /// let c = a % b
    /// print(c) // Output: 5
    /// ```
    static func %(lhs: UInt19, rhs: UInt19) -> UInt19 {
        return UInt19(lhs.value % rhs.value)
    }
}

// MARK: - CustomStringConvertible
extension UInt19: CustomStringConvertible {
    
    /// A textual representation of the `UInt19` value.
    ///
    /// ```swift
    /// let a: uint19_t = 5
    /// print(a) // Output: 5
    /// ```
    public var description: String {
        return "\(intValue)"
    }
}

// MARK: - Equatable
extension UInt19: Equatable {
    
    /// Compares two `UInt19` values for equality.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt19` value.
    ///   - rhs: Another `UInt19` value.
    /// - Returns: `true` if the values are equal, otherwise `false`.
    ///
    /// ```swift
    /// let a: uint19_t = 5
    /// let b: UInt19 = 5
    /// print(a == b) // Output: true
    /// ```
    public static func ==(lhs: UInt19, rhs: UInt19) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - Comparable
extension UInt19: Comparable {
    
    public func compare(with other: UInt19) -> ComparisonResult {
        if self.value < other.value {
            return .orderedAscending
        } else if self.value > other.value {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
    
    
    /// Compares two `UInt19` values to determine if the first is less than the second.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt19` value.
    ///   - rhs: Another `UInt19` value.
    /// - Returns: `true` if the first value is less than the second, otherwise `false`.
    ///
    /// ```swift
    /// let a: uint19_t = 5
    /// let b: UInt19 = 10
    /// print(a < b) // Output: true
    /// ```
    public static func <(lhs: UInt19, rhs: UInt19) -> Bool {
        return lhs.value < rhs.value
    }
    
    /// Compares two `UInt19` values to determine if the first is greater than the second.
    ///
    /// - Parameters:
    ///   - lhs: A `UInt19` value.
    ///   - rhs: Another `UInt19` value.
    /// - Returns: `true` if the first value is greater than the second, otherwise `false`.
    ///
    /// ```swift
    /// let a: uint19_t = 5
    /// let b: UInt19 = 10
    /// print(a > b) // Output: false
    /// ```
    public static func >(lhs: UInt19, rhs: UInt19) -> Bool {
        return lhs.value > rhs.value
    }
}
