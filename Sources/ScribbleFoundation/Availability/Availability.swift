//
//  Availability.swift
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

#if canImport(UIKit)
import UIKit
#endif
import SwiftUI
import Foundation

/// A protocol that determines if a specific feature is available based on various criteria,
/// including operating system version, device type, device orientation, size class, and custom conditions.
///
/// This protocol provides methods to check if a feature is available by assessing the system's current
/// state against specified requirements. It is designed to be used in environments where feature availability
/// may vary based on system conditions, making it a flexible tool for conditional feature management.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public protocol Availability {
    
    /// Checks if the feature is available based on the current system and device conditions.
    ///
    /// This method evaluates the availability of a feature based on a custom condition provided through a closure.
    /// It allows for a more flexible and dynamic check by combining multiple conditions.
    ///
    /// - Parameter conditions: A closure that returns a boolean indicating whether the feature is available.
    /// - Returns: A boolean indicating whether the feature is available based on the conditions provided.
    /// - Note: This method can be used to encapsulate complex conditions that involve multiple checks.
    func isFeatureAvailable(using conditions: () -> Bool) -> Bool
    
    /// Checks if the feature is available based on the specified operating system version.
    ///
    /// This method compares the current operating system version against a required version to determine
    /// if the feature is supported. It is useful for ensuring compatibility with specific OS versions.
    ///
    /// - Parameters:
    ///   - version: The required operating system version. This represents the minimum version required for the feature.
    ///   - currentVersion: The current operating system version. This represents the version installed on the device.
    /// - Returns: A boolean indicating whether the feature is available for the specified operating system version.
    /// - Note: Ensure that `currentVersion` accurately reflects the device's OS version to make this check effective.
    func isAvailable(forOS version: OperatingSystemVersion, currentVersion: OperatingSystemVersion) -> Bool
    
    /// Checks if the feature is available based on the current device type.
    ///
    /// This method compares the current device type with a required device type to determine if the feature is supported.
    /// It helps in tailoring features that are specific to certain device types.
    ///
    /// - Parameters:
    ///   - deviceType: The required device type. This specifies the type of device needed for the feature.
    ///   - currentDeviceType: The current device type. This represents the device on which the check is performed.
    /// - Returns: A boolean indicating whether the feature is available on the specified device type.
    /// - Note: Use `SCRDeviceType` values to represent device types (e.g., `.iPhone`, `.iPad`, `.mac`).
    func isAvailable(forDeviceType deviceType: SCRDeviceType, currentDeviceType: SCRDeviceType) -> Bool
    
    #if !os(macOS)
    /// Checks if the feature is available based on the current device orientation.
    ///
    /// This method checks if the feature is available in a specific device orientation. It is useful for features
    /// that depend on the device's orientation (e.g., landscape vs. portrait).
    ///
    /// - Parameters:
    ///   - orientation: The required device orientation. This specifies the orientation in which the feature should be available.
    ///   - currentOrientation: The current device orientation. This represents the orientation of the device.
    /// - Returns: A boolean indicating whether the feature is available in the specified orientation.
    /// - Note: Device orientation can be retrieved from `UIDevice.current.orientation`.
    func isAvailable(forOrientation orientation: UIDeviceOrientation, currentOrientation: UIDeviceOrientation) -> Bool
    
    /// Checks if the feature is available based on the current size class.
    ///
    /// This method determines if the feature is available based on the device's size class. Size classes help in
    /// adapting the UI to different screen sizes and orientations.
    ///
    /// - Parameters:
    ///   - sizeClass: The required size class. This specifies the size class needed for the feature.
    ///   - currentSizeClass: The current size class. This represents the size class of the device.
    /// - Returns: A boolean indicating whether the feature is available in the specified size class.
    /// - Note: Size class values can be retrieved from `UITraitCollection` (e.g., `.regular`, `.compact`).
    func isAvailable(forSizeClass sizeClass: UIUserInterfaceSizeClass, currentSizeClass: UIUserInterfaceSizeClass) -> Bool
    #endif
    
    /// Checks if the feature is available based on a custom condition.
    ///
    /// This method allows for checking feature availability based on any custom condition specified by the user.
    /// It is a flexible option for scenarios where predefined criteria do not cover all cases.
    ///
    /// - Parameter condition: A closure that returns a boolean indicating whether the feature is available based on custom logic.
    /// - Returns: A boolean indicating whether the feature is available given the condition provided.
    /// - Note: This method can be used to incorporate dynamic and complex conditions into feature availability checks.
    func isAvailable(condition: () -> Bool) -> Bool
    
    /// Provides a detailed reason why the feature is not available based on the provided conditions.
    ///
    /// This method returns a string that explains why the feature is not available, helping to provide context or
    /// debugging information. It can be useful for displaying error messages or troubleshooting issues.
    ///
    /// - Returns: A string detailing why the feature is not available based on the current system and device conditions.
    /// - Note: Implementations of this method should provide clear and informative reasons for feature unavailability.
    @MainActor func availabilityReason() -> String
}
