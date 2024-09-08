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

@available(iOS 18.0, macOS 18.0, tvOS 18.0, *)
public typealias BadgeLabel = RawRepresentable & CustomStringConvertible

@available(iOS 18.0, macOS 18.0, tvOS 18.0, *)
public struct Badge<T: BadgeLabel>: View where T.RawValue == String {
    public var name: String
    public var foregroundColor: Color

    public init(type: T, foregroundColor: Color = .black) {
        self.name = type.rawValue
        self.foregroundColor = foregroundColor
    }

    public init(name: String, foregroundColor: Color = .black) {
        self.name = name
        self.foregroundColor = foregroundColor
    }

    public var body: some View {
        Text(name.uppercased())
            .fontWeight(.semibold)
            .foregroundStyle(foregroundColor)
            .padding()
            .roundedCornerWithBorder(
                lineWidth: 2, 
                borderColor: foregroundColor,
                radius: 20,
                corners: [.allCorners]
            )
    }
}

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