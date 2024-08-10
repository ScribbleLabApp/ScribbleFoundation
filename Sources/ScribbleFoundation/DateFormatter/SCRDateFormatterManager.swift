//
//  SCRDateFormatter.swift
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

import Foundation

/// A singleton for managing date formatting.
///
/// The `DateFormatterManager` class provides a centralized way to access various `DateFormatter` instances
/// with pre-configured date formats. This ensures consistency in date formatting across the application
/// and reduces the need for repetitive `DateFormatter` setup.
@available(iOS 18.0, macOS 15.0, *)
public final class DateFormatterManager {
    
    /// The shared instance of `DateFormatterManager`.
    ///
    /// This property provides a singleton instance of `DateFormatterManager` to ensure that there is
    /// only one instance of the class managing date formatters throughout the application.
    @MainActor public static let shared = DateFormatterManager()
    
    /// Initializes a new instance of `DateFormatterManager`.
    ///
    /// The initializer is private to enforce the singleton pattern and prevent the creation of additional instances.
    private init() {}
    
    /// A `DateFormatter` configured for ISO 8601 date format.
    ///
    /// This formatter uses the format `"yyyy-MM-dd'T'HH:mm:ssZ"` which is commonly used for standardized date
    /// and time representations, including in APIs and data interchange formats.
    public let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    /// A `DateFormatter` configured for short date style.
    ///
    /// This formatter uses a short date style, which is typically used for displaying dates in a concise format.
    /// The exact format may vary based on the user's locale settings.
    public let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    /// A `DateFormatter` configured for long date style.
    ///
    /// This formatter uses a long date style, which provides a more verbose date format that includes
    /// the full name of the month and day of the week. The exact format may vary based on the user's locale settings.
    public let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
