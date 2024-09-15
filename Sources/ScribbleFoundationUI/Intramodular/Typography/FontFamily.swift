//
//  FontFamily.swift
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

#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if os(macOS)
import AppKit
#endif

import Foundation

//swiftlint:disable cyclomatic_complexity
//swiftlint:disable private_over_fileprivate

/// A protocol that defines a font family and provides utilities for applying custom fonts.
///
/// Conforming types represent different font families. The protocol includes methods for
/// creating fonts with specific sizes and weights.
public protocol FontFamily: CaseIterable, RawRepresentable {
    var rawValue: String { get }
    
    /// The font weight associated with this font family.
    var weight: Font.Weight? { get }
}

// MARK: - API

extension FontFamily {
    
    /// Creates a `Font` instance with a custom font from the font family.
    ///
    /// - Parameter size: The size of the font.
    /// - Returns: A `Font` instance with the specified size.
    public func callAsFunction(size: CGFloat) -> Font {
        Font.custom(rawValue, size: size)
    }
}

extension Font {
    
    /// Creates a custom font with a specified weight from a given font family.
    ///
    /// - Parameters:
    ///   - family: The font family type.
    ///   - size: The size of the font.
    ///   - weight: The weight of the font.
    /// - Returns: A `Font` instance with the specified family, size, and weight.
    public static func custom<F: FontFamily>(_ family: F.Type, size: CGFloat, weight: Weight) -> Font {
        guard let font = family.allCases.first(where: { $0.weight == weight }) else {
            assertionFailure("The font family \(family) does not support \(weight) as a valid weight")
            return Font.system(size: size, weight: weight)
        }
        return custom(font.rawValue, size: size)
    }
    
    #if canImport(UIKit)
    /// Creates a custom font with a specified text style from a given font family.
    ///
    /// - Parameters:
    ///   - family: The font family type.
    ///   - style: The text style for the font.
    /// - Returns: A `Font` instance with the specified family and text style.
    public static func custom<F: FontFamily>(_ family: F.Type, style: Font.TextStyle) -> Font {
        // Get the default size from the style using UIFontDescriptor
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle(style))
        let size = descriptor.pointSize
        
        let weight: Font.Weight
        switch style {
        case .largeTitle, .title, .title2, .title3:
            weight = .bold
        case .headline:
            weight = .semibold
        case .subheadline:
            weight = .regular
        case .body:
            weight = .regular
        case .callout, .caption, .caption2, .footnote:
            weight = .light
        @unknown default:
            weight = .regular
        }
        
        return .custom(family, size: size, weight: weight)
    }
    #endif
}

extension Text {
    
    /// Applies a custom font to a `Text` view.
    ///
    /// - Parameters:
    ///   - font: The font family.
    ///   - size: The size of the font.
    /// - Returns: A `Text` view with the specified font applied.
    public func font<F: FontFamily>(_ font: F, size: CGFloat) -> Text {
        self.font(.custom(font.rawValue, size: size))
    }
}

extension View {
    
    /// Applies a custom font to a `View`.
    ///
    /// - Parameters:
    ///   - font: The font family.
    ///   - size: The size of the font.
    /// - Returns: A `View` with the specified font applied.
    public func font<F: FontFamily>(_ font: F, size: CGFloat) -> some View {
        self.font(.custom(font.rawValue, size: size))
    }
    
    #if os(iOS)
    /// Applies a custom font with line height to a `View`.
    ///
    /// - Parameters:
    ///   - font: The font family.
    ///   - size: The size of the font.
    ///   - lineHeight: The line height to apply.
    /// - Returns: A `View` with the specified font and line height applied.
    public func font<F: FontFamily>(
        _ font: F,
        size: CGFloat,
        lineHeight: CGFloat
    ) -> some View {
        modifier(SetFontWithLineHeight(font: font, fontSize: size, lineHeight: lineHeight))
    }
    #endif
}

#if os(iOS) && canImport(CoreTelephony)
import UIKit

extension UITextField {
    
    /// Applies a custom font to a `UITextField`.
    ///
    /// - Parameters:
    ///   - font: The font family.
    ///   - size: The size of the font.
    /// - Returns: A `UITextField` with the specified font applied.
    public func font<F: FontFamily>(_ font: F, size: CGFloat) -> Self {
        self.font = UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        return self
    }
}

extension UITextView {
    
    /// Applies a custom font to a `UITextView`.
    ///
    /// - Parameters:
    ///   - font: The font family.
    ///   - size: The size of the font.
    /// - Returns: A `UITextView` with the specified font applied.
    public func font<F: FontFamily>(_ font: F, size: CGFloat) -> Self {
        self.font = UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        return self
    }
}
#endif

#if os(macOS) && canImport(AppKit)
import AppKit

extension NSTextField {
    
    /// Applies a custom font to an `NSTextField`.
    ///
    /// - Parameters:
    ///   - font: The font family.
    ///   - size: The size of the font.
    /// - Returns: An `NSTextField` with the specified font applied.
    public func font<F: FontFamily>(_ font: F, size: CGFloat) -> Self {
        self.font = NSFont(name: font.rawValue, size: size) ?? NSFont.systemFont(ofSize: size)
        return self
    }
}

extension NSTextView {
    
    /// Applies a custom font to an `NSTextView`.
    ///
    /// - Parameters:
    ///   - font: The font family.
    ///   - size: The size of the font.
    /// - Returns: An `NSTextView` with the specified font applied.
    public func font<F: FontFamily>(_ font: F, size: CGFloat) -> Self {
        self.font = NSFont(name: font.rawValue, size: size) ?? NSFont.systemFont(ofSize: size)
        return self
    }
}
#endif

// MARK: - Auxiliary

#if os(iOS)
fileprivate struct SetFontWithLineHeight<F: FontFamily>: ViewModifier {
    let font: F
    let fontSize: CGFloat
    let lineHeight: CGFloat
    
    @State private var cachedUIFont: UIFont?
    @State private var cachedLineSpacing: CGFloat?
    
    private var uiFont: UIFont? {
        cachedUIFont ?? UIFont(name: font.rawValue, size: fontSize)
    }
    
    private var lineSpacing: CGFloat? {
        guard let uiFont = uiFont else {
            return nil
        }
        return cachedLineSpacing ?? (lineHeight - uiFont.lineHeight)
    }
    
    func body(content: Content) -> some View {
        if let uiFont = uiFont, let lineSpacing = lineSpacing {
            content
                .font(font, size: fontSize)
                .lineSpacing(lineSpacing)
                .padding(.vertical, lineSpacing / 2)
                .onAppear {
                    withAnimation {
                        cachedUIFont = uiFont
                        cachedLineSpacing = lineSpacing
                    }
                }
        } else {
            content
                .font(font, size: fontSize)
        }
    }
}
#endif

#if os(macOS)
extension NSFont {
    
    /// Creates a custom `NSFont` instance with a specified font family and size.
    ///
    /// - Parameters:
    ///   - family: The font family.
    ///   - size: The size of the font.
    public convenience init?<F: FontFamily>(_ family: F, size: CGFloat) {
        self.init(name: family.rawValue, size: size)
    }
}
#endif

private extension UIFont.TextStyle {
    init(_ style: Font.TextStyle) {
        switch style {
        case .largeTitle: self = .largeTitle
        case .title: self = .title1
        case .title2: self = .title2
        case .title3: self = .title3
        case .headline: self = .headline
        case .subheadline: self = .subheadline
        case .body: self = .body
        case .callout: self = .callout
        case .caption: self = .caption1
        case .caption2: self = .caption2
        case .footnote: self = .footnote
        @unknown default: self = .body
        }
    }
}

//swiftlint:enable cyclomatic_complexity
//swiftlint:enable private_over_fileprivate
