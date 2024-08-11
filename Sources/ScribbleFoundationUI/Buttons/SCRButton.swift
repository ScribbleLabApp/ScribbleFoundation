//
//  SCRButton.swift
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

/// A customizable button view with support for text, optional images, and various styling properties.
struct SCRButton: View {
    var text:               String
    var font:               Font?
    var fontWeight:         Font.Weight?
    var textColor:          Color?
    var backgroundColor:    Color?
    var cornerRadius:       CGFloat
    
    var image:              Image?
    var systemImage:        String?
    
    var imageWidth:         CGFloat
    var imageHeight:        CGFloat
    
    var action:             () -> Void
    
    /// Initializes an `SCRButton` instance.
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
    public init(
        text:               String,
        font:               Font?        = nil,
        fontWeight:         Font.Weight? = .semibold,
        textColor:          Color?       = .white,
        backgroundColor:    Color?       = .blue,
        cornerRadius:       CGFloat      = 10,
        
        image:              Image?       = nil,
        systemImage:        String?      = nil,
        
        action:             @escaping () -> Void
    ) {
        self.text                        = text
        self.font                        = font
        self.fontWeight                  = fontWeight
        self.textColor                   = textColor
        self.backgroundColor             = backgroundColor
        self.cornerRadius                = cornerRadius
        
        self.image                       = image
        self.systemImage                 = systemImage
        
        self.action                      = action
        
        self.imageWidth                  = 35
        self.imageHeight                 = 35
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth, height: imageHeight)
                        .padding(.leading, 8)
                } else if let image = image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth, height: imageHeight)
                        .padding(.leading, 8)
                }
                
                Text(text)
                    .font(font ?? .subheadline)
                    .fontWeight(fontWeight ?? .semibold)
                    .foregroundColor(textColor ?? .white)
                    .frame(width: 360, height: 44)
                    .background(backgroundColor ?? .blue)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color(red: 248/255, green: 248/255, blue: 248/255))
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .strokeBorder(Color(red: 194/255, green: 194/255, blue: 194/255), lineWidth: 0.5)
                            )
                    )
            }
        }
    }
}

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
        font: Font?,
        fontWeight: Font.Weight?,
        textColor: Color,
        backgroundColor: Color,
        cornerRadius: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        return SCRButton(
            text: text,
            font: font,
            fontWeight: fontWeight,
            textColor: textColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            action: action
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
        font: Font?,
        fontWeight: Font.Weight?,
        textColor: Color,
        backgroundColor: Color,
        cornerRadius: CGFloat,
        image: Image?,
        systemImage: String?,
        action: @escaping () -> Void
    ) -> some View {
        return SCRButton(
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
    }
}
