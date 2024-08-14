//
//  SCRButton+View.swift
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

@available(iOS 18.0, macOS 15.0, *)
extension View {
    
    /// Creates a styled button with customizable appearance and action.
    ///
    /// - Parameters:
    ///   - text: The text to display on the button.
    ///   - font: The font to apply to the button text.
    ///   - fontWeight: The weight of the button text font.
    ///   - textColor: The color of the button's text.
    ///   - backgroundColor: The background color of the button.
    ///   - cornerRadius: The corner radius of the button's shape.
    ///   - action: The action to perform when the button is tapped.
    /// - Returns: A view representing the styled button.
    func SCRButton(
        text: String,
        font: Font? = nil,
        fontWeight: Font.Weight? = nil,
        textColor: Color = .white,
        backgroundColor: Color = .blue,
        cornerRadius: CGFloat = 10,
        action: @escaping () -> Void
    ) -> some View {
        AnyView(
            SCRButton(
                text: text,
                font: font,
                fontWeight: fontWeight,
                textColor: textColor,
                backgroundColor: backgroundColor,
                cornerRadius: cornerRadius,
                image: nil,
                systemImage: nil,
                action: action
            )
        )
    }
    
    /// Creates a styled button with customizable appearance, including image.
    ///
    /// - Parameters:
    ///   - text: The text to display on the button.
    ///   - font: The font to apply to the button text.
    ///   - fontWeight: The weight of the button text font.
    ///   - textColor: The color of the button's text.
    ///   - backgroundColor: The background color of the button.
    ///   - cornerRadius: The corner radius of the button's shape.
    ///   - image: An optional `Image` to display on the button.
    ///   - systemImage: An optional system image name to display on the button.
    ///   - action: The action to perform when the button is tapped.
    /// - Returns: A view representing the styled button with an image.
    func SCRButton(
        text: String,
        font: Font? = nil,
        fontWeight: Font.Weight? = nil,
        textColor: Color? = .white,
        backgroundColor: Color? = .blue,
        cornerRadius: CGFloat = 10,
        image: Image? = nil,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        SCRButtonWrapper(
            text: text,
            font: font,
            fontWeight: fontWeight,
            textColor: textColor ?? .white,
            backgroundColor: backgroundColor ?? .blue,
            cornerRadius: cornerRadius,
            image: image,
            systemImage: systemImage,
            action: action
        )
    }
    
    /// A private helper function that creates an `SCRButton` view and wraps it in `AnyView`.
    ///
    /// This function is used internally to avoid infinite recursion in view extensions by
    /// wrapping the `SCRButton` view into an `AnyView` before returning it.
    ///
    /// - Parameters:
    ///   - text: The text to display on the button.
    ///   - font: The font to apply to the button text. Defaults to `nil`.
    ///   - fontWeight: The weight of the button text font. Defaults to `nil`.
    ///   - textColor: The color of the button's text. Defaults to `.white`.
    ///   - backgroundColor: The background color of the button. Defaults to `.blue`.
    ///   - cornerRadius: The corner radius of the button's shape. Defaults to `10`.
    ///   - image: An optional `Image` to display on the button. Defaults to `nil`.
    ///   - systemImage: An optional system image name to display on the button. Defaults to `nil`.
    ///   - action: The action to perform when the button is tapped.
    ///
    /// - Returns: A view representing the styled button wrapped in `AnyView`.
    ///
    /// - Note: This function is used internally to create a styled button with the specified
    ///   properties and wrap it in `AnyView` to conform to the `some View` return type required
    ///   by the view extension methods.
    ///
    /// - Warning: Use ``SCRButton(text:cornerRadius:action:)`` instead to avoid redundancy
    internal func SCRButtonWrapper(
        text: String,
        font: Font? = nil,
        fontWeight: Font.Weight? = nil,
        textColor: Color = .white,
        backgroundColor: Color = .blue,
        cornerRadius: CGFloat = 10,
        image: Image? = nil,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        AnyView(
            SCRButton(
                text: text,
                font: font,
                fontWeight: fontWeight,
                textColor: textColor,
                backgroundColor: backgroundColor,
                cornerRadius: cornerRadius,
                image: image,
                systemImage: systemImage,
                action: action
            )
        )
    }
}
