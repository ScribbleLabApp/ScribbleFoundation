//
//  ColorScheme.swift
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

import Foundation

/// An enumeration that represents different color schemes for a user interface.
///
/// The `ColorScheme` enum allows you to specify and manage different color themes for your application or component.
/// It supports three primary color schemes:
///
/// - `.light`: Represents a light color scheme, typically with a white or light background.
/// - `.dark`: Represents a dark color scheme, typically with a dark background and lighter text.
/// - `.system`: Represents the system's default color scheme, which adjusts based on the user's system-wide appearance settings.
///
///
/// You can use the `ColorScheme` enum to configure the appearance of your UI components or entire applications based
/// on user preferences or system settings. For example, you might use this enum to:
///
/// - Apply a specific color scheme to a view or component.
/// - Implement a toggle that switches between light and dark modes.
/// - Follow the system's appearance settings to provide a consistent user experience.
///
/// ## See Also
///
/// - `ColorSchemeCustomizable`
/// - `Customizable`
/// - `applyColorScheme(_:)`
/// - `toggleColorScheme()`
@available(iOS 18.0, macOS 15.0, *)
public enum ColorScheme {
    
    /// A light color scheme, typically with a white or light background.
    case light
    
    /// A dark color scheme, typically with a dark background and lighter text.
    case dark
    
    /// The system's default color scheme, which follows the user's system-wide appearance settings.
    case system
}
