//
//  Comparable.swift
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

/// A protocol for comparing instances to determine their relative order.
///
/// The `Comparable` protocol provides a way to define and implement comparison operations for
/// types, allowing instances of conforming types to be ordered and compared. Types that conform
/// to this protocol can be sorted, checked for equality, and assessed for greater-than or less-than
/// relationships based on their defined comparison logic.
///
/// This protocol defines methods to:
/// - Compare two instances to determine their relative order.
/// - Check if one instance is equal to, greater than, or less than another instance.
///
/// Types conforming to `Comparable` can be used in sorting algorithms and other operations that require
/// order or equality comparisons.
///
/// - Note: The `Comparable` protocol is intended to be implemented by types where a meaningful
///   notion of order or equality exists. It can be adopted by custom types that need to support
///   ordering or comparison operations.
@available(iOS 18.0, macOS 15.0, *)
public protocol Comparable {
    
    /// Compares the object with another object to determine the order.
    ///
    /// This method provides a way to compare the current instance (`self`) with another instance
    /// of the same type to determine their relative order. The comparison result helps in sorting
    /// or ordering operations.
    ///
    /// - Parameter other: The object to compare against.
    /// - Returns: A `ComparisonResult` indicating the order:
    ///   - `.orderedAscending` if the current instance is less than `other`.
    ///   - `.orderedSame` if the current instance is equal to `other`.
    ///   - `.orderedDescending` if the current instance is greater than `other`.
    func compare(with other: Self) -> ComparisonResult
    
    /// Checks if the object is equal to another object.
    ///
    /// This method uses the `compare(with:)` function to determine if the current instance (`self`)
    /// is equal to another instance of the same type.
    ///
    /// - Parameter other: The object to compare against.
    /// - Returns: A boolean indicating whether the current instance is equal to `other`.
    func isEqual(to other: Self) -> Bool
    
    /// Determines if the object is greater than another object.
    ///
    /// This method uses the `compare(with:)` function to determine if the current instance (`self`)
    /// is greater than another instance of the same type.
    ///
    /// - Parameter other: The object to compare against.
    /// - Returns: A boolean indicating whether the current instance is greater than `other`.
    func isGreaterThan(_ other: Self) -> Bool
    
    /// Determines if the object is less than another object.
    ///
    /// This method uses the `compare(with:)` function to determine if the current instance (`self`)
    /// is less than another instance of the same type.
    ///
    /// - Parameter other: The object to compare against.
    /// - Returns: A boolean indicating whether the current instance is less than `other`.
    func isLessThan(_ other: Self) -> Bool
}

@available(iOS 18.0, macOS 15.0, *)
public extension Comparable {
    
    /// Checks if the object is equal to another object.
    ///
    /// This method provides a default implementation for checking equality by comparing the current
    /// instance (`self`) with another instance of the same type using the `compare(with:)` method.
    ///
    /// - Parameter other: The object to compare against.
    /// - Returns: A boolean indicating whether the current instance is equal to `other`. Returns `true`
    ///   if `compare(with:)` returns `.orderedSame`, otherwise `false`.
    func isEqual(to other: Self) -> Bool {
        return compare(with: other) == .orderedSame
    }
    
    /// Determines if the object is greater than another object.
    ///
    /// This method provides a default implementation for determining if the current instance (`self`)
    /// is greater than another instance of the same type using the `compare(with:)` method.
    ///
    /// - Parameter other: The object to compare against.
    /// - Returns: A boolean indicating whether the current instance is greater than `other`. Returns `true`
    ///   if `compare(with:)` returns `.orderedDescending`, otherwise `false`.
    func isGreaterThan(_ other: Self) -> Bool {
        return compare(with: other) == .orderedDescending
    }
    
    /// Determines if the object is less than another object.
    ///
    /// This method provides a default implementation for determining if the current instance (`self`)
    /// is less than another instance of the same type using the `compare(with:)` method.
    ///
    /// - Parameter other: The object to compare against.
    /// - Returns: A boolean indicating whether the current instance is less than `other`. Returns `true`
    ///   if `compare(with:)` returns `.orderedAscending`, otherwise `false`.
    func isLessThan(_ other: Self) -> Bool {
        return compare(with: other) == .orderedAscending
    }
}
