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

/// A custom `Shape` that creates rounded corners for a given view,
/// allowing selective rounding of specific corners and applying a border.
///
/// The `RoundedCorner` structure enables you to define a shape with rounded corners
/// on a `SwiftUI` view. It takes two parameters:
/// - `radius`: Determines the radius of the rounding. Default value is set to `.infinity`.
/// - `corners`: Specifies which corners to round. Default is `.allCorners`.
///
/// This structure works alongside an extension to the `View` which provides
/// the `roundedCornerWithBorder` modifier. This modifier allows for both
/// clipping the shape to the desired corner radius and overlaying a border.
///
/// You can use the `roundedCornerWithBorder` modifier to apply rounded corners
/// to specific corners of your view, as well as define a border.
///
/// ### Using All Side Corner Radius with Border
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
/// ![An image demonstrating all Sides Rounded with Border](roundedcornersall)
///
/// ### For Top Left & Bottom Left Side Corner Radius with Border
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
/// ![An image demonstrating all Top Left & Bottom Left Side Corner Radius with Border](r3wqef3wfr)
///
/// ### Top Right & Bottom Right Rounded with Border
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
/// ![An image demonstrating Top Right & Bottom Right Rounded with Border](r2f34wfr)
///
/// ### Top Left & Bottom Right Rounded with Border
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
/// ![An image demonstrating Top Right & Bottom Right Rounded with Border](fd3gtrdr)
public struct RoundedCorner: Shape {
    
    /// The radius of the corner rounding. Default is `.infinity`.
    public var radius: CGFloat = .infinity
    
    /// The corners to be rounded. Default is `.allCorners`.
    public var corners: UIRectCorner = .allCorners
    
    /// Generates the path for the rounded corner shape.
    ///
    /// - Parameter rect: The rectangular area in which the rounded corners will be applied.
    /// - Returns: A `Path` object describing the shape.
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
