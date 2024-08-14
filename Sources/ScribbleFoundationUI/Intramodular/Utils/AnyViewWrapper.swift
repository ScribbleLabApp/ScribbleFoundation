//
//  AnyViewWrapper.swift
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

import SwiftUI

/// A view wrapper that allows for type-erased views to be used where specific view types are not required.
///
/// This struct is useful for scenarios where you need to wrap a specific `View` type in an `AnyView` to avoid type constraints,
/// particularly when dealing with dynamic view content or complex view compositions.
///
/// - Note: This struct is often used internally in SwiftUI extensions or custom view modifiers where the exact type of view
///         is not known or needs to be abstracted.
///
/// - SeeAlso: ``SwiftUI.AnyView``, ``SwiftUI.View``
@available(iOS 18.0, macOS 15.0, *)
@MainActor
public struct AnyViewWrapper: View {
    
    private let content: AnyView

    /// Initializes an `AnyViewWrapper` with a specific view.
    ///
    /// - Parameter view: The view to wrap in an `AnyView`.
    public init<V: View>(_ view: V) {
        self.content = AnyView(view)
    }

    /// The body of the view that returns the wrapped view content.
    public var body: some View {
        content
    }
}
