//
//  Binding+View.swift
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

import SwiftUI
import Foundation

@available(iOS 18.0, macOS 15.0, *)
extension SwiftUI.Binding {
    
    /// Creates a binding with the specified value.
    ///
    /// - Parameter value: The initial value for the binding.
    /// - Returns: A new `Binding` instance.
    public static func createBinding<T: Sendable>(with value: T) -> SwiftUI.Binding<T> {
        let immutableValue = value
        return .init(get: { immutableValue }, set: { _ in })
    }
    
    /// Creates a binding that uses the provided getter and setter closures.
    ///
    /// - Parameters:
    ///   - get: A closure that returns the current value.
    ///   - set: A closure that updates the value.
    /// - Returns: A new `Binding` instance.
    public static func createBinding(
        variable get: @escaping @Sendable () -> Value,
        set: @escaping @Sendable (Value) -> Void
    ) -> Self {
        return .init(get: get, set: set)
    }
}
