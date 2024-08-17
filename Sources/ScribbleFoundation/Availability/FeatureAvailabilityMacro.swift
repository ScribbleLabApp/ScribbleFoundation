//
//  FeatureAvailabilityMacro.swift
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
import Foundation

/// A typealias for `FeatureAvailability` to simplify usage.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public typealias featureAvailability<T: Availability> = FeatureAvailability<T>

/// A property wrapper that checks if a feature is available based on various conditions.
///
/// The `featureAvailability` property wrapper allows you to conditionally enable or disable features
/// in your application based on custom conditions evaluated at runtime. This property wrapper leverages
/// the `Availability` protocol to perform checks against different criteria, such as operating system
/// version, device type, orientation, size class, and any other custom conditions.
///
/// ```swift
/// import SwiftUI
///
/// struct ContentView: View {
///     @FeatureAvailability(
///         feature: MyFeatureChecker(),
///         conditions: {
///             // Define conditions using AvailabilityConditionBuilder
///             UIDevice.current.userInterfaceIdiom == .phone &&
///             ProcessInfo().operatingSystemVersion >= OperatingSystemVersion(majorVersion: 18, minorVersion: 0, patchVersion: 0) &&
///             AvailabilityConditionBuilder.buildOr(
///                 UIDevice.current.orientation.isPortrait,
///                 UIDevice.current.orientation.isLandscape
///             )
///         }
///     )
///     private var isFeatureAvailable: Bool
///
///     var body: some View {
///         VStack {
///             if isFeatureAvailable {
///                 Text("Feature is available!")
///             } else {
///                 Text("Feature is not available. Reason: \(MyFeatureChecker().availabilityReason())")
///             }
///         }
///     }
/// }
/// ```
///
/// In this example, `FeatureAvailability` checks if `MyFeatureChecker` is available based on
/// device type, operating system version, and orientation conditions. The `availabilityReason` method
/// provides a detailed reason if the feature is not available.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
@propertyWrapper
public struct FeatureAvailability<T: Availability> {
    
    private let feature: T
    private let conditions: () -> Bool
    
    /// Creates a property wrapper for checking feature availability.
    ///
    /// - Parameters:
    ///   - feature: The `Availability` conforming object used to check the feature's availability.
    ///   - conditions: A closure that returns a boolean indicating whether the feature is available
    ///     based on custom conditions provided through the `AvailabilityConditionBuilder`.
    public init(
        feature: T,
        @AvailabilityConditionBuilder conditions: @escaping () -> Bool
    ) {
        self.feature = feature
        self.conditions = conditions
    }
    
    /// The wrapped value that indicates whether the feature is available based on the provided conditions.
    ///
    /// - Returns: A boolean indicating whether the feature is available.
    public var wrappedValue: Bool {
        // Use the feature's availability methods and custom conditions
        feature.isFeatureAvailable(using: conditions)
    }
    
    /// Provides a detailed reason why the feature is not available.
    ///
    /// - Returns: A string detailing why the feature is not available based on the provided conditions.
    @MainActor public func availabilityReason() -> String {
        feature.availabilityReason()
    }
    
    /// Checks if the feature is available based on additional conditions.
    ///
    /// - Parameter additionalConditions: A closure that returns a boolean indicating whether the feature
    ///   is available with additional conditions combined with the original conditions.
    /// - Returns: A boolean indicating whether the feature is available given the additional conditions.
    public func isAvailable(with additionalConditions: () -> Bool) -> Bool {
        feature.isFeatureAvailable(using: { conditions() && additionalConditions() })
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
@resultBuilder
public struct AvailabilityConditionBuilder {
    
    /// Builds a boolean condition by combining all provided components.
    ///
    /// - Parameter components: The boolean components to combine.
    /// - Returns: A boolean indicating whether all components satisfy the condition.
    public static func buildBlock(_ components: Bool...) -> Bool {
        components.allSatisfy { $0 }
    }
    
    /// Builds a boolean condition by combining all provided components using logical AND.
    ///
    /// - Parameters:
    ///   - components: The boolean components to combine.
    /// - Returns: A boolean indicating whether all components satisfy the condition.
    public static func buildAnd(_ components: Bool...) -> Bool {
        components.allSatisfy { $0 }
    }
    
    /// Builds a boolean condition by combining all provided components using logical OR.
    ///
    /// - Parameters:
    ///   - components: The boolean components to combine.
    /// - Returns: A boolean indicating whether any component satisfies the condition.
    public static func buildOr(_ components: Bool...) -> Bool {
        components.contains(true)
    }
    
    /// Builds a boolean condition by combining all provided components using logical NOT.
    ///
    /// - Parameter component: The boolean component to negate.
    /// - Returns: A boolean indicating the negation of the component.
    public static func buildNot(_ component: Bool) -> Bool {
        !component
    }
}
