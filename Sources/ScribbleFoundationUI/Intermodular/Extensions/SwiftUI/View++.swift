//
//  View++.swift
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

import Swift
import SwiftUI

// MARK: - View.then

extension View {
    
    /// Applies a transformation to the view and returns the modified view.
    ///
    /// This method allows you to perform additional modifications on the view within a closure,
    /// and then return the modified view.
    ///
    /// - Parameter body: A closure that takes an `inout` parameter of the view type,
    ///   allowing you to modify the view in place.
    ///
    /// - Returns: The modified view after applying the transformation specified in the closure.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .then { view in
    ///         view.font(.largeTitle)
    ///         view.foregroundColor(.red)
    ///     }
    /// ```
    @inlinable
    public func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        
        body(&result)
        
        return result
    }
}

// MARK: - View.background

extension View {
    
    /// Sets the background view for this view with the specified alignment.
    ///
    /// This method allows you to set a background view with a specified alignment.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the background view relative to the view. Default is `.center`.
    ///   - background: A closure that returns the background view to be applied.
    ///
    /// - Returns: A view that applies the specified background with the given alignment.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .background(Color.yellow)
    ///     .background(alignment: .topTrailing) { Text("Background") }
    /// ```
    @_disfavoredOverload
    @inlinable
    public func background<Background: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ background: () -> Background
    ) -> some View {
        self.background(background(), alignment: alignment)
    }
    
    /// Sets the background color for this view.
    ///
    /// This method allows you to set a solid color as the background for this view.
    ///
    /// - Parameter color: The color to be used as the background.
    ///
    /// - Returns: A view with the specified background color.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .background(Color.yellow)
    /// ```
    @_disfavoredOverload
    @inlinable
    public func background(_ color: Color) -> some View {
        background(PassthroughView(content: { color }))
    }
    
    /// Sets the background color for this view.
    ///
    /// This method is deprecated. Please use `backgroundFill(_:)` instead.
    ///
    /// - Parameter color: The color to be used as the background.
    ///
    /// - Returns: A view with the specified background color.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .backgroundColor(Color.yellow)
    /// ```
    @inlinable
    @available(*, deprecated, message: "Please use View.backgroundFill(_:) instead.")
    public func backgroundColor(_ color: Color) -> some View {
        background(color.edgesIgnoringSafeArea(.all))
    }
    
    /// Sets the background fill color for this view.
    ///
    /// This method sets a solid color as the background fill for this view, extending
    /// to the safe area edges.
    ///
    /// - Parameter color: The color to be used as the background fill.
    ///
    /// - Returns: A view with the specified background fill color.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .backgroundFill(Color.yellow)
    /// ```
    @inlinable
    public func backgroundFill(_ color: Color) -> some View {
        background(color.edgesIgnoringSafeArea(.all))
    }
    
    /// Sets the background fill view for this view with the specified alignment.
    ///
    /// This method allows you to set a background view that fills the safe area edges,
    /// with a specified alignment.
    ///
    /// - Parameters:
    ///   - fill: A view to be used as the background fill.
    ///   - alignment: The alignment of the background view relative to the view. Default is `.center`.
    ///
    /// - Returns: A view with the specified background fill view and alignment.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .backgroundFill(Color.yellow, alignment: .topLeading)
    /// ```
    @inlinable
    public func backgroundFill<BackgroundFill: View>(
        _ fill: BackgroundFill,
        alignment: Alignment = .center
    ) -> some View {
        background(fill.edgesIgnoringSafeArea(.all), alignment: alignment)
    }
    
    /// Sets the background fill view for this view with the specified alignment,
    /// using a closure to provide the background view.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the background view relative to the view. Default is `.center`.
    ///   - fill: A closure that returns the background fill view.
    ///
    /// - Returns: A view with the specified background fill view and alignment.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .backgroundFill(alignment: .topLeading) { Color.yellow }
    /// ```
    @inlinable
    public func backgroundFill<BackgroundFill: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ fill: () -> BackgroundFill
    ) -> some View {
        backgroundFill(fill())
    }
}

// MARK: - View.listRowBackground

extension View {
    
    /// Sets the background view for a list row.
    ///
    /// This method allows you to set a background view for a list row.
    ///
    /// - Parameter background: A closure that returns the background view to be applied.
    ///
    /// - Returns: A view with the specified list row background.
    ///
    /// ```swift
    /// List {
    ///     Text("Row 1")
    ///     Text("Row 2")
    /// }
    /// .listRowBackground { Color.yellow }
    /// ```
    public func listRowBackground<Content: View>(
        @ViewBuilder _ background: () -> Content
    ) -> some View {
        listRowBackground(background())
    }
}

// MARK: - View.overlay

extension View {
    
    /// Overlays the view with another view, applying the specified alignment.
    ///
    /// This method allows you to overlay another view on top of the current view,
    /// with a specified alignment.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the overlay view relative to the view. Default is `.center`.
    ///   - overlay: A closure that returns the overlay view to be applied.
    ///
    /// - Returns: A view with the specified overlay view and alignment.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .overlay { Text("Overlay") }
    ///     .overlay(alignment: .topTrailing) { Text("Overlay") }
    /// ```
    @_disfavoredOverload
    @inlinable
    public func overlay<Overlay: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ overlay: () -> Overlay
    ) -> some View {
        self.overlay(overlay(), alignment: alignment)
    }
}

// MARK: - View.hidden

extension View {
    
    /// Conditionally hides this view based on a boolean flag.
    ///
    /// This method allows you to conditionally hide the view based on the specified
    /// boolean flag.
    ///
    /// - Parameter isHidden: A boolean flag indicating whether the view should be hidden.
    ///
    /// - Returns: A view that is conditionally hidden based on the `isHidden` flag.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .hidden(true)  // The view will be hidden
    ///     .hidden(false) // The view will be visible
    /// ```
    @_disfavoredOverload
    @inlinable
    public func hidden(_ isHidden: Bool) -> some View {
        PassthroughView {
            if isHidden {
                hidden()
            } else {
                self
            }
        }
    }
}

// MARK: View.id

extension View {
    
    /// Sets an opaque ID for the view using a hashable identifier.
    ///
    /// This method allows you to set an ID for the view using a hashable identifier,
    /// which can be useful for differentiating views in a list or when performing
    /// view updates.
    ///
    /// - Parameter hashable: A hashable identifier to be used as the view's ID.
    ///
    /// - Returns: A view with the specified opaque ID.
    ///
    /// ```swift
    /// Text("Hello")
    ///     ._opaque_id("uniqueID")
    /// ```
    @_spi(Internal)
    public func _opaque_id(_ hashable: AnyHashable) -> some View {
        func _makeView<ID: Hashable>(_ id: ID) -> some View {
            self.id(id)
        }
        
        return _openExistential(hashable.base as! (any Hashable), do: _makeView)
    }
}

// MARK: View.offset

extension View {
    
    /// Applies an inset offset to the view.
    ///
    /// This method allows you to apply an inset offset to the view, moving it in the
    /// opposite direction of the given point or length.
    ///
    /// - Parameter point: The `CGPoint` value representing the amount to offset the view.
    ///
    /// - Returns: A view with the specified inset offset applied.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .inset(CGPoint(x: 10, y: 10))
    /// ```
    @inlinable
    public func inset(_ point: CGPoint) -> some View {
        offset(x: -point.x, y: -point.y)
    }
    
    /// Applies an inset offset to the view using a length.
    ///
    /// This method allows you to apply an inset offset to the view, moving it by the
    /// specified length in both the x and y directions.
    ///
    /// - Parameter length: The CGFloat value representing the amount to offset the view.
    ///
    /// - Returns: A view with the specified inset offset applied.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .inset(10)
    /// ```
    @inlinable
    public func inset(_ length: CGFloat) -> some View {
        offset(x: -length, y: -length)
    }
    
    /// Applies an offset to the view.
    ///
    /// This method allows you to apply an offset to the view, moving it in the direction
    /// specified by the given point.
    ///
    /// - Parameter point: The `CGPoint` value representing the amount to offset the view.
    ///
    /// - Returns: A view with the specified offset applied.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .offset(CGPoint(x: 10, y: 10))
    /// ```
    @inlinable
    public func offset(_ point: CGPoint) -> some View {
        offset(x: point.x, y: point.y)
    }
    
    /// Applies an offset to the view using a length.
    ///
    /// This method allows you to apply an offset to the view, moving it by the
    /// specified length in both the x and y directions.
    ///
    /// - Parameter length: The CGFloat value representing the amount to offset the view.
    ///
    /// - Returns: A view with the specified offset applied.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .offset(10)
    /// ```
    @inlinable
    public func offset(_ length: CGFloat) -> some View {
        offset(x: length, y: length)
    }
}

// MARK: - View.onAppear

@MainActor
extension View {
    
    /// Executes a closure once when the view appears.
    ///
    /// This method ensures that the provided action is executed only once when the
    /// view appears. It is useful for performing actions that should only occur once
    /// during the view's lifecycle.
    ///
    /// - Parameter action: A closure to be executed when the view appears.
    ///
    /// - Returns: A view that executes the specified action once on appearance.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .onAppearOnce {
    ///         print("View appeared once")
    ///     }
    /// ```
    public func onAppearOnce(perform action: @escaping () -> Void) -> some View {
        withInlineState(initialValue: false) { $didAppear in
            self.onAppear {
                guard !didAppear else {
                    return
                }
                
                action()
                
                didAppear = true
            }
        }
    }
}

// MARK: - View.transition

extension View {
    
    /// Associates a transition with the view.
    ///
    /// This method allows you to specify a transition effect for the view, which will
    /// be applied when the view appears or disappears.
    ///
    /// - Parameter makeTransition: A closure that returns the transition effect to be applied.
    ///
    /// - Returns: A view with the specified transition applied.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .transition { AnyTransition.opacity }
    /// ```
    public func transition(_ makeTransition: () -> AnyTransition) -> some View {
        self.transition(makeTransition())
    }
    
    /// Associates an insertion transition with the view.
    ///
    /// This method allows you to specify an insertion transition effect for the view,
    /// with a default identity transition for removal.
    ///
    /// - Parameter insertion: The transition effect to be applied when the view is inserted.
    ///
    /// - Returns: A view with the specified insertion transition.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .asymmetricTransition(insertion: .slide)
    /// ```
    public func asymmetricTransition(
        insertion: AnyTransition
    ) -> some View {
        transition(.asymmetric(insertion: insertion, removal: .identity))
    }
    
    /// Associates a removal transition with the view.
    ///
    /// This method allows you to specify a removal transition effect for the view,
    /// with a default identity transition for insertion.
    ///
    /// - Parameter removal: The transition effect to be applied when the view is removed.
    ///
    /// - Returns: A view with the specified removal transition.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .asymmetricTransition(removal: .opacity)
    /// ```
    public func asymmetricTransition(
        removal: AnyTransition
    ) -> some View {
        transition(.asymmetric(insertion: .identity, removal: removal))
    }
    
    /// Associates an insertion and removal transition with the view.
    ///
    /// This method allows you to specify different transition effects for when the view
    /// is inserted and removed.
    ///
    /// - Parameters:
    ///   - insertion: The transition effect to be applied when the view is inserted.
    ///   - removal: The transition effect to be applied when the view is removed.
    ///
    /// - Returns: A view with the specified insertion and removal transitions.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .asymmetricTransition(insertion: .slide, removal: .opacity)
    /// ```
    public func asymmetricTransition(
        insertion: AnyTransition,
        removal: AnyTransition
    ) -> some View {
        transition(.asymmetric(insertion: insertion, removal: removal))
    }
}

// MARK: - Debugging

extension View {
    
    /// Prints changes to the view during debugging.
    ///
    /// This method prints changes to the view when debugging, but is only available
    /// on platforms where it is supported.
    ///
    /// - Returns: The view itself.
    ///
    /// ```swift
    /// Text("Hello")
    ///     ._printChanges_printingChanges()
    /// ```
    public func _printChanges_printingChanges() -> Self {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            Self._printChanges()
            
            return self
        } else {
            return self
        }
    }
}

#if swift(>=6.0)
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
extension View {
    
    /// Sets a default scroll anchor for the view.
    ///
    /// This method sets a default scroll anchor for the view based on the specified
    /// `UnitPoint`. This is available only on newer platform versions.
    ///
    /// - Parameter unitPoint: The scroll anchor to be set.
    ///
    /// - Returns: The view with the specified default scroll anchor.
    ///
    /// ```swift
    /// Text("Hello")
    ///     ._ScribbleFoundation_defaultScrollAnchor(.bottom)
    /// ```
    @ViewBuilder
    public func _ScribbleFoundation_defaultScrollAnchor(
        _ unitPoint: UnitPoint?
    ) -> some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *) {
            defaultScrollAnchor(.bottom)
        } else {
            self
        }
    }
}
#endif
#endif
