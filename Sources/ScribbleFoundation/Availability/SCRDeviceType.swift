//
//  SCRDeviceType.swift
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
#if canImport(AppKit) || os(macOS)
import AppKit
#endif
import Foundation

/// Represents the various types of Apple devices that the app might run on.
///
/// Use this enum to identify the type of device your code is currently running on,
/// which helps in writing platform-specific logic.
///
/// The `SCRDeviceType` enum categorizes devices into several distinct types,
/// such as iPhone, iPad, Mac, etc. It also includes a case for unrecognized device
/// types (`.unspecified`) and simulators (`.simulator`).
@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 2.0, tvOS 18.0, *)
public enum SCRDeviceType {
    
    /// Indicates that the app is running on an iPhone.
    case iPhone
    
    /// Indicates that the app is running on an iPad.
    case iPad
    
    /// Indicates that the app is running on an Apple Watch.
    case watch
    
    /// Indicates that the app is running on an Apple TV.
    case tv
    
    /// Indicates that the app is running on an Apple Vision Pro.
    case vision
    
    /// Indicates that the app is running on a Mac.
    case mac
    
    /// Indicates that the app is running on a device connected to CarPlay.
    case carPlay
    
    /// Indicates that the app is running on a HomePod.
    case homePod
    
    /// Indicates that the app is running in a simulator.
    case simulator
    
    /// Indicates that the device type could not be determined.
    case unspecified
}

/// Retrieves the current device type that the application is running on.
///
/// This function identifies the device type based on the current environment and user interface idiom,
/// such as iPhone, iPad, Mac, etc. It handles various platforms like iOS, macOS, watchOS, tvOS,
/// and also identifies if the app is running in a simulator.
///
/// - Returns: An `SCRDeviceType` value representing the current device type.
///
/// ```swift
/// let deviceType = getCurrentDeviceType()
/// switch deviceType {
/// case .iPhone:
///     print("Running on an iPhone")
/// case .iPad:
///     print("Running on an iPad")
/// case .mac:
///     print("Running on a Mac")
/// case .simulator:
///     print("Running in a simulator")
/// default:
///     print("Unrecognized device type")
/// }
/// ```
///
/// - Important: The function uses platform-specific checks and might return `.unspecified` if the device type cannot be determined.
@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 2.0, tvOS 18.0, *)
@MainActor
public func getCurrentDeviceType() -> SCRDeviceType {
    #if targetEnvironment(simulator)
    return .simulator
    #elseif canImport(UIKit)
    switch UIDevice.current.userInterfaceIdiom {
    case .unspecified:
        return .unspecified
    case .phone:
        return .iPhone
    case .pad:
        return .iPad
    case .tv:
        return .tv
    case .carPlay:
        return .carPlay
    case .mac:
        return .mac
    case .vision:
        return .vision
    @unknown default:
        return .unspecified
    }
    #elseif os(macOS)
    return .mac
    #elseif os(watchOS)
    return .watch
    #elseif os(tvOS)
    return .tv
    #else
    return .unspecified
    #endif
}
