//
//  SwiftUI+PreferenceKey.swift
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

import Combine
import Swift
import SwiftUI

/// A `PreferenceKey` implementation that collects all values of a given type into an array.
///
/// This key can be used in SwiftUI views to aggregate multiple values into a single array,
/// which can then be used for further processing or display.
///
/// ```swift
/// struct ContentView: View {
///     @State private var collectedValues: [String] = []
///
///     var body: some View {
///         VStack {
///             Text("Item 1").preference(key: ArrayReducePreferenceKey<String>.self, value: ["Item 1"])
///             Text("Item 2").preference(key: ArrayReducePreferenceKey<String>.self, value: ["Item 2"])
///         }
///         .onPreferenceChange(ArrayReducePreferenceKey<String>.self) { values in
///             self.collectedValues = values
///         }
///     }
/// }
/// ```
open class ArrayReducePreferenceKey<Element>: PreferenceKey {
    
    /// The type of the value managed by this `PreferenceKey`, which is an array of `Element`.
    public typealias Value = [Element]
    
    /// The default value for this `PreferenceKey`, which is an empty array.
    public static var defaultValue: Value {
        return []
    }
    
    /// Reduces the given value with the next value.
    ///
    /// Appends the elements of the next value to the current value.
    ///
    /// - Parameters:
    ///   - value: The current value, which will be updated.
    ///   - nextValue: A closure that provides the next value to append.
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

/// A `PreferenceKey` implementation that takes the first non-nil value from multiple values.
///
/// This key can be used in SwiftUI views to select the first value from multiple potential values.
/// If multiple values are provided, the first non-nil value will be used.
///
/// ```swift
/// struct ContentView: View {
///     @State private var firstValue: String?
///
///     var body: some View {
///         VStack {
///             Text("First").preference(key: TakeFirstPreferenceKey<String>.self, value: "First")
///             Text("Second").preference(key: TakeFirstPreferenceKey<String>.self, value: "Second")
///         }
///         .onPreferenceChange(TakeFirstPreferenceKey<String>.self) { value in
///             self.firstValue = value
///         }
///     }
/// }
/// ```
open class TakeFirstPreferenceKey<T: Equatable>: PreferenceKey {
    
    /// The type of the value managed by this `PreferenceKey`, which is an optional `T`.
    public typealias Value = T?
    
    /// The default value for this `PreferenceKey`, which is `nil`.
    public static var defaultValue: Value {
        return nil
    }
    
    /// Reduces the given value with the next value.
    ///
    /// Takes the first non-nil value and updates the current value if it's different.
    ///
    /// - Parameters:
    ///   - value: The current value, which will be updated.
    ///   - nextValue: A closure that provides the next value to compare.
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        let newValue = value ?? nextValue()
        
        if value != newValue {
            value = newValue
        }
    }
}

/// A `PreferenceKey` implementation that takes the last non-nil value from multiple values.
///
/// This key can be used in SwiftUI views to select the last value from multiple potential values.
/// If multiple values are provided, the last non-nil value will be used.
///
/// ```swift
/// struct ContentView: View {
///     @State private var lastValue: String?
///
///     var body: some View {
///         VStack {
///             Text("First").preference(
///                 key: TakeLastPreferenceKey<String>.self,
///                 value: "First"
///             )
///             Text("Last").preference(
///                 key: TakeLastPreferenceKey<String>.self,
///                 value: "Last"
///             )
///         }
///         .onPreferenceChange(TakeLastPreferenceKey<String>.self) { value in
///             self.lastValue = value
///         }
///     }
/// }
/// ```
open class TakeLastPreferenceKey<T: Equatable>: PreferenceKey {
    
    /// The type of the value managed by this `PreferenceKey`, which is an optional `T`.
    public typealias Value = T?
    
    /// The default value for this `PreferenceKey`, which is `nil`.
    public static var defaultValue: Value {
        return nil
    }
    
    /// Reduces the given value with the next value.
    ///
    /// Takes the last non-nil value and updates the current value if it's different.
    ///
    /// - Parameters:
    ///   - value: The current value, which will be updated.
    ///   - nextValue: A closure that provides the next value to compare.
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        let newValue = nextValue() ?? value
        
        if value != newValue {
            value = newValue
        }
    }
}
