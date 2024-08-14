//
//  ColorSchemeCustomizable.swift
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
import Combine
import ScribbleFoundation

/// A protocol for components that can be customized with a color scheme.
@available(iOS 18.0, macOS 15.0, *)
public protocol ColorSchemeCustomizable: Customizable {
    
    /// The current color scheme applied to the component.
    var currentColorScheme: ColorScheme { get set }
    
    /// Applies a specific color scheme to the component.
    ///
    /// - Parameter scheme: The `ColorScheme` to apply. This can be `.light`, `.dark`, or `.system`.
    func applyColorScheme(_ scheme: ColorScheme)
    
    /// Toggles between light and dark mode.
    ///
    /// This method switches the color scheme between light and dark modes based on the current state.
    func toggleColorScheme()
    
    /// Retrieves the current color scheme as a string representation.
    ///
    /// - Returns: A string representing the current color scheme. Possible values are `"light"`, `"dark"`, and `"system"`.
    func getColorSchemeState() -> String
    
    /// Applies a color scheme from a string representation.
    ///
    /// - Parameter state: A string representing the color scheme. Expected values are `"light"`, `"dark"`, and `"system"`.
    func applyColorScheme(from state: String)
    
    /// A publisher that emits events when the color scheme changes.
    ///
    /// - Returns: A publisher that emits the new `ColorScheme` value whenever the color scheme changes.
    var colorSchemeChanged: AnyPublisher<ColorScheme, Never> { get }
    
    /// Sets the color scheme for the component.
    ///
    /// - Parameter theme: The `ColorScheme` to apply to the component. This method allows you to set the color scheme based
    ///   on the provided theme, such as light, dark, or system-based.
    @available(*, deprecated, message: "Use `applyColorScheme(_:)` with the desired color scheme instead.")
    func setColorScheme(_ scheme: ColorScheme)
    
    /// Sets the color scheme to light mode.
    ///
    /// - Deprecated: Use `applyColorScheme(_:)` with `.light` instead.
    @available(*, deprecated, message: "Use `applyColorScheme(_:)` with `.light` instead.")
    func setLightMode()
    
    /// Sets the color scheme to dark mode.
    ///
    /// - Deprecated: Use `applyColorScheme(_:)` with `.dark` instead.
    @available(*, deprecated, message: "Use `applyColorScheme(_:)` with `.dark` instead.")
    func setDarkMode()
    
    /// Sets the color scheme to follow the system's default.
    ///
    /// - Deprecated: Use `applyColorScheme(_:)` with `.system` instead.
    @available(*, deprecated, message: "Use `applyColorScheme(_:)` with `.system` instead.")
    func setSystemMode()
}
