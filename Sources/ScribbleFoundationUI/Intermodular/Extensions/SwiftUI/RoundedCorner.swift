//
//  RoundedCorner.swift
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
import Foundation

// swiftlint:disable line_length

/// A versatile `Shape` that provides rounded corners for a `SwiftUI` view.
///
/// The `RoundedCorner` shape allows you to apply customized corner rounding
/// to any view, letting you specify both the radius of the corners and
/// which specific corners should be rounded. This can be especially useful
/// for creating unique, non-standard shapes for UI elements.
///
/// - Parameters:
///   - radius: A `CGFloat` value determining the radius of the rounded corners.
///     The default value is `.infinity`, creating fully rounded corners.
///   - corners: A `UIRectCorner` option set that specifies which corners should be rounded.
///     The default value is `.allCorners`.
///
/// ### Usage
/// Combine this shape with a custom modifier `roundedCornerWithBorder` to create
/// flexible UI designs by applying both corner rounding and borders to views.
///
/// - SeeAlso: ``View.roundedCornerWithBorder(lineWidth:borderColor:radius:corners:)```
///
/// ### Example 1 - All Corners Rounded with Border
///
/// Use `roundedCornerWithBorder` to round all corners and apply a border.
///
/// ```swift
/// var body: some View {
///     Text("Some Text")
///         .padding()
///         .background(.red)
///         .roundedCornerWithBorder(
///             lineWidth: 2,
///             borderColor: .blue,
///             radius: 4,
///             corners: [.allCorners]
///         )
/// }
/// ```
///
/// ![All Corners Rounded Example](https://github.com/ScribbleLabApp/ScribbleFoundation/blob/main/Sources/ScribbleFoundationUI/Documentation.docc/Resources/roundedcornersall.png)
///
/// ### Example 2 - Top Left & Bottom Left Rounded with Border
///
/// Round only the top-left and bottom-left corners with a border.
///
/// ```swift
/// var body: some View {
///     Text("Some Text")
///         .padding()
///         .background(.red)
///         .roundedCornerWithBorder(
///             lineWidth: 2,
///             borderColor: .blue,
///             radius: 20,
///             corners: [.topLeft, .bottomLeft]
///         )
/// }
/// ```
///
/// ![Top Left & Bottom Left Rounded Example](https://github.com/ScribbleLabApp/ScribbleFoundation/blob/main/Sources/ScribbleFoundationUI/Documentation.docc/Resources/r3wqef3wf.png)
///
/// ### Example 3 - Top Right & Bottom Right Rounded with Border
///
/// Customize rounding to only the top-right and bottom-right corners.
///
/// ```swift
/// var body: some View {
///     Text("Some Text")
///         .padding()
///         .background(.red)
///         .roundedCornerWithBorder(
///             lineWidth: 2,
///             borderColor: .blue,
///             radius: 20,
///             corners: [.topRight, .bottomRight]
///         )
/// }
/// ```
///
/// ![Top Right & Bottom Right Rounded Example](https://github.com/ScribbleLabApp/ScribbleFoundation/blob/main/Sources/ScribbleFoundationUI/Documentation.docc/Resources/r2f34wfr.png)
///
/// ### Example 4 - Top Left & Bottom Right Rounded with Border
///
/// Round diagonal corners (top-left and bottom-right) for a unique effect.
///
/// ```swift
/// var body: some View {
///     Text("Some Text")
///         .padding()
///         .background(.red)
///         .roundedCornerWithBorder(
///             lineWidth: 2,
///             borderColor: .blue,
///             radius: 20,
///             corners: [.topLeft, .bottomRight]
///         )
/// }
/// ```
///
/// ![Diagonal Rounded Corners Example](https://github.com/ScribbleLabApp/ScribbleFoundation/blob/main/Sources/ScribbleFoundationUI/Documentation.docc/Resources/fd3gtrdr.png)
///
public struct RoundedCorner: Shape {
    
    /// The radius for the corner rounding.
    public var radius: CGFloat = .infinity
    
    /// The specific corners to apply the rounding to.
    public var corners: UIRectCorner = .allCorners
    
    /// Generates the path for the rounded corner shape.
    ///
    /// - Parameter rect: The rectangular area in which the shape is drawn.
    /// - Returns: A `Path` object describing the rounded corners within the given rectangle.
    public nonisolated func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect:        rect,
            byRoundingCorners:  corners,
            cornerRadii:        CGSize(width: radius,
                                       height: radius)
        )
        return Path(path.cgPath)
    }
}

/// An extension to `View` to allow applying rounded corners with a border.
extension View {
    
    /// A modifier that applies rounded corners and a border to the view.
    ///
    /// - Parameters:
    ///   - lineWidth: The thickness of the border line.
    ///   - borderColor: The color of the border.
    ///   - radius: The radius of the corner rounding.
    ///   - corners: The corners to be rounded.
    /// - Returns: A view with rounded corners and a border.
    ///
    /// - SeeAlso: ``ScribbleFoundationUI/roundedCornerWithBorder(lineWidth:borderColor:radius:corners:)``
    public func roundedCornerWithBorder(
        lineWidth: CGFloat,
        borderColor: Color,
        radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
            .overlay(RoundedCorner(radius: radius, corners: corners)
            .stroke(borderColor, lineWidth: lineWidth))
    }
}

// swiftlint:enable line_length
