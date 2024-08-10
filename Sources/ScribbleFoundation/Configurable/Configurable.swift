//
//  Configurable.swift
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

/// A protocol for loading and applying configuration settings.
///
/// This protocol defines methods for loading configuration settings from a source, applying them,
/// validating them, and resetting to default values. It provides a robust way to manage configurations
/// in an application.
@available(iOS 18.0, macOS 15.0, *)
public protocol Configurable {
    /// Loads configuration settings from a source.
    ///
    /// - Parameter source: The source of the configuration data, typically a URL pointing to a configuration file or service.
    /// - Throws: An error if the configuration could not be loaded.
    func loadConfiguration(from source: URL) async throws
    
    /// Applies the loaded configuration settings.
    ///
    /// - Throws: An error if the configuration could not be applied.
    func applyConfiguration() throws
    
    /// Validates the loaded configuration settings.
    ///
    /// This method checks if the loaded configuration meets the necessary criteria for correctness and completeness.
    ///
    /// - Returns: A boolean indicating whether the configuration is valid.
    /// - Throws: An error if the validation process encounters issues.
    func validateConfiguration() throws -> Bool
    
    /// Resets the configuration settings to their default values.
    ///
    /// This method clears any applied configurations and restores the system to its default configuration state.
    func resetToDefaults()
    
    /// Loads configuration settings from a provided data object.
    ///
    /// - Parameter data: The data object containing configuration settings, typically in JSON, XML, or another format.
    /// - Throws: An error if the configuration could not be loaded from the data object.
    func loadConfiguration(from data: Data) async throws
}
