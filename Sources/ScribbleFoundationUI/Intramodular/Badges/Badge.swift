//
//  Badge.swift
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

/// A protocol that represents types suitable for use in badges.
/// It requires conformance to `RawRepresentable` and `CustomStringConvertible`.
///
/// Types that conform to `BadgeLabel` can be used to create badges with predefined text values.
/// For example, you can use enum cases to generate badges with specific labels.
@available(iOS 18.0, macOS 18.0, tvOS 18.0, *)
public typealias BadgeLabel = RawRepresentable & CustomStringConvertible

/// A customizable badge view that displays a text label with optional foreground color, font weight, and corner radius.
///
/// The `Badge` struct allows you to create badges using either predefined enum cases or custom strings.
/// It provides customization options for text color, border color, font weight, and corner radius. The badge text is
/// displayed in uppercase by default.
///
/// - Parameters:
///   - T: A type that conforms to `BadgeLabel`. This type provides the text for the badge through its `rawValue`.
///   - name: The text to display in the badge. This parameter is used when creating a badge with a custom string.
///   - foregroundColor: The color of the badge's text and border. By default, this is set to `.black`.
///   - fontWeight: The weight of the badge text. The default value is `.semibold`. Other values can be provided to adjust the text appearance.
///   - cornerRadius: The radius of the badge's rounded corners. By default, this is set to `20`. Adjust this to control how rounded the corners appear.
@available(iOS 18.0, macOS 18.0, tvOS 18.0, *)
public struct Badge<T: BadgeLabel>: View where T.RawValue == String {
    public  var name:            String
    public  var foregroundColor: Color
    public  var fontWeight:      Font.Weight = .semibold
    public  var cornerRadius:    CGFloat     = 20
    private var uppercase:       Bool        = true

    /// Initializes a `Badge` using a predefined enum case that conforms to `BadgeLabel`.
    ///
    /// This initializer sets the badge text based on the `rawValue` of the enum case.
    ///
    /// - Parameters:
    ///   - type: The enum case providing the text for the badge.
    ///   - foregroundColor: The color of the badge's text and border. Defaults to `.black`.
    public init(type: T, foregroundColor: Color = .black) {
        self.name = type.rawValue
        self.foregroundColor = foregroundColor
    }

    /// Initializes a `Badge` using a custom string.
    ///
    /// This initializer allows you to specify any text for the badge.
    ///
    /// - Parameters:
    ///   - name: The text to display in the badge.
    ///   - foregroundColor: The color of the badge's text and border. Defaults to `.black`.
    public init(name: String, foregroundColor: Color = .black) {
        self.name = name
        self.foregroundColor = foregroundColor
    }

    public var body: some View {
        Text(uppercase ? name.uppercased() : name)
            .fontWeight(fontWeight)
            .foregroundStyle(foregroundColor)
            .padding()
            .roundedCornerWithBorder(
                lineWidth: 2, 
                borderColor: foregroundColor,
                radius: cornerRadius,
                corners: [.allCorners]
            )
    }
    
    /// Updates the color of the badge's text and border.
    ///
    /// This method allows you to change the foreground color of the badge.
    ///
    /// - Parameters:
    ///   - color: The new color for the badge's text and border.
    /// - Returns: A view with the updated foreground and background colors.
    public func badgeColor(_ color: Color) -> some View {
        var newBadge = self
        newBadge.foregroundColor = color
        return newBadge
    }
    
    /// Customizes the badge's text weight and/or corner radius.
    ///
    /// This method allows you to adjust the font weight and corner radius of the badge. You can specify one or both parameters.
    ///
    /// - Parameters:
    ///   - fontWeight: The new weight for the badge's text. If `nil`, the default weight (`.semibold`) is used.
    ///   - cornerRadius: The new radius for the badge's corners. If `nil`, the default radius (`20`) is used.
    /// - Returns: A view with the updated text weight and/or corner radius.
    public func badgeStyle(
        fontWeight: Font.Weight? = nil,
        cornerRadius: CGFloat? = nil
    ) -> some View {
        var newBadge = self
        
        if let fontWeight = fontWeight {
            newBadge.fontWeight = fontWeight
        }
        
        if let cornerRadius = cornerRadius {
            newBadge.cornerRadius = cornerRadius
        }
        
        return newBadge
    }
    
    /// Disables the default uppercase transformation of the badge's text.
    ///
    /// By default, the badge text is displayed in uppercase. This method allows you to keep the text as is, without converting it to uppercase.
    ///
    /// - Returns: A view with the text displayed in its original case.
    public func disableUppercase() -> some View {
        var newBadge = self
        newBadge.uppercase = false
        return newBadge
    }
    
    // swiftlint:disable:next identifier_name
    public func _unchangedCaseName() -> some View {
        var newBadge = self
        newBadge.uppercase = false
        return newBadge
    }
}

/// An enum representing predefined badge types used in the ScribbleLab app.
///
/// Conforms to `BadgeLabel` to provide a set of predefined badge labels.
/// You can use these enum cases to initialize badges with standard text values.
@available(iOS 18.0, macOS 18.0, tvOS 18.0, *)
public enum ScribbleBadgeType: String, BadgeLabel {
    case staff      = "STAFF"
    case mod        = "MOD"
    case support    = "SUPPORT"
    case developer  = "DEVELOPER"
    
    public var description: String {
        return self.rawValue
    }
}

/// An enum representing various user badge types.
///
/// Conforms to `BadgeLabel` to provide a set of predefined user badge labels.
/// You can use these enum cases to initialize badges that represent different user statuses or tiers.
@available(iOS 18.0, macOS 18.0, tvOS 18.0, *)
public enum UserBadgeType: String, BadgeLabel {
    case verified   = "VERIFIED"
    case premium    = "PREMIUM"
    case enterprise = "ENTERPRISE"
    case pro        = "PRO"
    case free       = "FREE"
    case beta       = "BETA"
    
    public var description: String {
        return self.rawValue
    }
}
