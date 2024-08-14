//
//  PasstroughView.swift
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

import Combine
import SwiftUI

/// A generic `View` wrapper that passes through its content without modifying it.
///
/// `PassthroughView` is a simple wrapper for a `View` that allows you to pass a `View` through as-is.
/// It is useful when you need to provide a `View` as a type-erased `AnyView`, or when you want
/// to ensure that a view is preserved without additional modifications.
///
/// You can initialize it with a `View` directly or use a `@ViewBuilder` closure to provide the content.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         PassthroughView {
///             Text("Hello, World!")
///                 .font(.largeTitle)
///         }
///         .background(Color.yellow)
///     }
/// }
/// ```
@frozen
public struct PassthroughView<Content: View>: @preconcurrency _opaque_View, View {
    
    /// Converts the `PassthroughView` to an `AnyView`.
    ///
    /// - Returns: An `AnyView` that wraps the content of this view.
    ///
    /// This method allows the view to be used in contexts where a type-erased `View` is required.
    @MainActor public func eraseToAnyView() -> AnyView {
        return AnyView(content)
    }
    
    /// The content view that is passed through without modification.
    public let content: Content
    
    /// Initializes a `PassthroughView` with a given `View`.
    ///
    /// - Parameter content: The view to be passed through.
    ///
    /// This initializer creates a `PassthroughView` with the specified content.
    ///
    /// - Note: This initializer is optimized for speed.
    @_optimize(speed)
    @inlinable
    public init(content: Content) {
        self.content = content
    }
    
    /// Initializes a `PassthroughView` using a `@ViewBuilder` closure.
    ///
    /// - Parameter content: A closure that returns the view to be passed through.
    ///
    /// This initializer creates a `PassthroughView` with the view produced by the closure.
    ///
    /// - Note: This initializer is optimized for speed.
    @_optimize(speed)
    @inlinable
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
        
    /// The body of the `PassthroughView`, which is simply the content view.
    ///
    /// - Returns: The content view.
    ///
    /// This property provides the body of the view, which is the content passed through unchanged.
    @_optimize(speed)
    @inlinable
    public var body: some View {
        content
    }
}
