//
//  _opaque_View.swift
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

/// A protocol that defines methods and properties for working with views in a type-erased manner.
///
/// This protocol allows you to work with views in a more abstract way, providing
/// methods for applying environment objects, retrieving view names, and type-erasing views.
public protocol _opaque_View {
    
    /// Applies an environment object to the view.
    ///
    /// This method allows you to apply an `ObservableObject` to the view in a type-erased manner,
    /// enabling the view to use the object as part of its environment.
    ///
    /// - Parameter bindable: The `ObservableObject` to be applied to the view.
    ///
    /// - Returns: A type-erased view with the applied environment object.
    @MainActor func _opaque_environmentObject<B: ObservableObject>(_: B) -> _opaque_View
    
    /// Retrieves a name for the view.
    ///
    /// This method provides an optional hashable identifier for the view, which can be useful
    /// for debugging or view identification purposes.
    ///
    /// - Returns: An optional hashable identifier for the view.
    func _opaque_getViewName() -> AnyHashable?
    
    /// Type-erases the view.
    ///
    /// This method converts the view to a type-erased `AnyView`, allowing it to be treated as a
    /// generic view type. This can be useful for working with heterogeneous collections of views
    /// or when returning views from functions that require type erasure.
    ///
    /// - Returns: A type-erased `AnyView` instance.
    func eraseToAnyView() -> AnyView
}

// MARK: - Implementation

extension _opaque_View where Self: View {
    
    /// Applies an environment object to the view and returns a type-erased view.
    ///
    /// This implementation allows you to use the `environmentObject` modifier on a view,
    /// while returning a type-erased `_opaque_View` instance.
    ///
    /// - Parameter bindable: The `ObservableObject` to be applied to the view.
    ///
    /// - Returns: A type-erased view with the applied environment object.
    @MainActor @inlinable
    public func _opaque_environmentObject<B: ObservableObject>(_ bindable: B) -> _opaque_View {
        PassthroughView(content: environmentObject(bindable))
    }

    /// Retrieves the view name, which is not implemented in this extension.
    ///
    /// This default implementation returns `nil`, indicating that the view name is not available
    /// in this context.
    ///
    /// - Returns: `nil`, as the view name is not implemented.
    @inlinable
    public func _opaque_getViewName() -> AnyHashable? {
        nil
    }
    
    /// Type-erases the view.
    ///
    /// This implementation converts the view to an `AnyView`, allowing it to be used in contexts
    /// where a type-erased view is required.
    ///
    /// - Returns: An `AnyView` instance representing the type-erased view.
    @inlinable
    public func eraseToAnyView() -> some View {
        return AnyView(self)
    }
}

extension ModifiedContent: _opaque_View where Content: View, Modifier: ViewModifier {
    
    /// Type-erases the `ModifiedContent` view.
    ///
    /// This implementation converts the `ModifiedContent` view to an `AnyView`, enabling it to be
    /// used in contexts where a type-erased view is required.
    ///
    /// - Returns: An `AnyView` instance representing the type-erased view.
    public func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
