//
//  Shape++.swift
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

extension Shape {
    /// Fills the shape with a specified content and applies a stroke around it.
    ///
    /// This method first fills the shape with the provided `fillContent` and then
    /// applies a stroke around the shape with the given `strokeStyle`. It uses a
    /// `ZStack` to layer the fill and stroke effects, ensuring that the fill appears
    /// underneath the stroke.
    ///
    /// - Parameters:
    ///   - fillContent: The content used to fill the shape. It must conform to the
    ///     `ShapeStyle` protocol, such as `Color`, `LinearGradient`, or `RadialGradient`.
    ///   - strokeStyle: The style of the stroke to be applied around the shape.
    ///     It defines the line width, line cap, and line join.
    ///
    /// - Returns: A view that displays the shape filled with `fillContent` and stroked
    ///   with the specified `strokeStyle`.
    ///
    /// ```swift
    /// Rectangle()
    ///     .fill(Color.blue, stroke: StrokeStyle(lineWidth: 2, lineCap: .round))
    /// ```
    /// In this example, a `Rectangle` is filled with a blue color and has a rounded stroke
    /// with a line width of 2 points.
    ///
    /// - Note: The fill is rendered first, and the stroke is applied on top of the fill.
    public func fill<S: ShapeStyle>(
        _ fillContent: S,
        stroke strokeStyle: StrokeStyle
    ) -> some View {
        ZStack {
            fill(fillContent)
            stroke(style: strokeStyle)
        }
    }
    
    /// Fills the shape and adds a border with specified color and width.
    ///
    /// This method first fills the shape with the provided `fillContent` and then
    /// applies a border with the specified color and width. It uses the `inset(by:)`
    /// method to create an inset version of the shape for the fill, ensuring the border
    /// is drawn outside the filled area.
    ///
    /// - Parameters:
    ///   - fillContent: The content used to fill the shape. It must conform to the
    ///     `ShapeStyle` protocol.
    ///   - borderColor: The color of the border applied around the shape.
    ///   - borderWidth: The width of the border around the shape.
    ///   - antialiased: A Boolean value that indicates whether the border should be
    ///     antialiased. Default is `true`.
    ///
    /// - Returns: A view that displays the shape filled with `fillContent` and bordered
    ///   with `borderColor` and `borderWidth`.
    ///
    /// ```swift
    /// Circle()
    ///     .fillAndStrokeBorder(Color.yellow, borderColor: .black, borderWidth: 4)
    /// ```
    /// In this example, a `Circle` is filled with yellow color and has a black border
    /// with a width of 4 points.
    ///
    /// - Note: The border is drawn after the shape is filled. The `inset(by:)` method
    ///   ensures the fill area does not overlap the border.
    public func fillAndStrokeBorder<S: ShapeStyle>(
        _ fillContent: S,
        borderColor: Color,
        borderWidth: CGFloat,
        antialiased: Bool = true
    ) -> some View where Self: InsettableShape {
        ZStack {
            inset(by: borderWidth / 2).fill(fillContent)
            
            self.strokeBorder(
                borderColor,
                lineWidth: borderWidth,
                antialiased: antialiased
            )
        }
        .compositingGroup()
    }
}
