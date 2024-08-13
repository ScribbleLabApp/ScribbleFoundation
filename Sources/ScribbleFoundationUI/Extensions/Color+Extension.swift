//
//  Color+Extension.swift
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

public extension Color {
    
    /// Initializes a `Color` instance with a hexadecimal string representing the color.
    ///
    /// - Parameter hex: The hexadecimal string representing the color, with or without the '#' prefix.
    /// - Returns: A `Color` instance initialized with the specified hexadecimal value.
    /// - Note: The hex string can be in the format `"#RRGGBB"` or `"RRGGBB"`.
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16)
        let green = Double((rgb & 0x00FF00) >> 8)
        let blue = Double(rgb & 0x0000FF)

        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
    }
    
    /// Initializes a `Color` instance with a hexadecimal integer representing the color.
    ///
    /// - Parameter hex: The hexadecimal value representing the color.
    /// - Returns: A `Color` instance initialized with the specified hexadecimal value.
    /// - Note: The hex value should be in the format `0xRRGGBB`.
    init(hex: Int) {
        let hexString = String(format: "#%06X", hex)
        self.init(hex: hexString)
    }
}

public extension Color {
    static let sBlue = Color(hex: "#42A5F5")
    static let sYellow = Color(hex: "#FFBF45")
    static let sOrange = Color(hex: "#ED8335")
}
