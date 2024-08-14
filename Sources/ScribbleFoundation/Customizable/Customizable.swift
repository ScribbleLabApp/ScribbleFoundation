//
//  Customizable.swift
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

import Combine
import Foundation

/// A protocol for components that support customization.
///
/// This protocol defines methods and properties for applying, resetting, and managing customizations on a component.
/// Implementing this protocol allows a component to support dynamic changes and persistence of its customization settings.
@available(iOS 18.0, macOS 15.0, *)
public protocol Customizable {
    
    // swiftlint:disable line_length
    
    /// Applies the current customization to the component.
    ///
    /// This method should be implemented to apply the customization settings to the component. This might include
    /// updating UI elements, modifying behavior, or applying styles based on the current customization state.
    @available(*, deprecated,
        message: "This method will be deprecated in version 1.0.0. Use `applyCustomization(from:)` with a state dictionary instead for more controlled customization."
    )
    func applyCustomization()
    
    // swiftlint:enable line_length
    
    /// Applies customization settings from a provided state dictionary.
    ///
    /// - Parameter state: A dictionary containing the customization settings to apply. The dictionary should have
    ///   keys and values that correspond to the customization settings for the component.
    func applyCustomization(from state: [String: Any])
    
    /// Resets the customization to default settings.
    ///
    /// This method should be implemented to revert the component to its default state, discarding any customizations
    /// that have been applied. It ensures that the component can return to its original appearance or behavior.
    func resetCustomization()
    
    /// Retrieves the current customization state of the component.
    ///
    /// - Returns: A dictionary containing the current customization settings. The keys and values in this dictionary
    ///   depend on the specific implementation of the component and should include all relevant customization data.
    func getCustomizationState() -> [String: Any]
    
    /// A publisher that emits events when customization changes occur.
    ///
    /// - Returns: A publisher that emits `Void` values whenever a customization change is applied. Subscribers can
    ///   use this to respond to changes in customization and update the UI or other components accordingly.
    var customizationChanged: AnyPublisher<Void, Never> { get }
}
