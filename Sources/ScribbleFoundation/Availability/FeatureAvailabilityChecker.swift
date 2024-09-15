//
//  FeatureAvailabilityChecker.swift
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

/// A class responsible for checking the availability of features based on various system and device criteria.
///
/// The `FeatureAvailabilityChecker` class implements the `Availability` protocol, providing methods to determine
/// if a specific feature is available based on the operating system version, device type, device orientation,
/// size class, and custom conditions. It allows for flexible and dynamic checks to ensure that features are only
/// enabled or used when appropriate for the current system state.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public struct FeatureAvailabilityChecker: Availability {
    
    public init() {}
    
    public func isFeatureAvailable(using conditions: () -> Bool) -> Bool {
        return conditions()
    }
    
    public func isAvailable(
        forOS version: OperatingSystemVersion,
        currentVersion: OperatingSystemVersion
    ) -> Bool {
        return currentVersion.majorVersion > version.majorVersion ||
               (currentVersion.majorVersion == version.majorVersion && currentVersion.minorVersion >= version.minorVersion) ||
               (currentVersion.majorVersion == version.majorVersion && currentVersion.minorVersion == version.minorVersion &&
                currentVersion.patchVersion >= version.patchVersion)
    }
    
    public func isAvailable(
        forDeviceType deviceType: SCRDeviceType,
        currentDeviceType: SCRDeviceType
    ) -> Bool {
        return currentDeviceType == deviceType
    }
    
    #if !os(macOS) && canImport(UIKit)
    public func isAvailable(
        forOrientation orientation: UIDeviceOrientation,
        currentOrientation: UIDeviceOrientation
    ) -> Bool {
        return currentOrientation == orientation
    }
    
    public func isAvailable(
        forSizeClass sizeClass: UIUserInterfaceSizeClass,
        currentSizeClass: UIUserInterfaceSizeClass
    ) -> Bool {
        return currentSizeClass == sizeClass
    }
    #endif
    
    public func isAvailable(condition: () -> Bool) -> Bool {
        return condition()
    }
    
    #if canImport(UIKit)
    public func availabilityReason() -> String {
        let currentVersion = ProcessInfo.processInfo.operatingSystemVersion
        let currentDeviceType = getCurrentDeviceType()
        let currentOrientation = UIDevice.current.orientation
        let currentSizeClass = UIScreen.main.traitCollection.horizontalSizeClass
        
        if !isAvailable(
            forOS: OperatingSystemVersion(
                majorVersion: 18,
                minorVersion: 0,
                patchVersion: 0),
            currentVersion: currentVersion
        ) {
            return "Feature requires iOS 18.0 or later."
        }
        if !isAvailable(forDeviceType: .iPad, currentDeviceType: currentDeviceType) {
            return "Feature requires an iPad."
        }
        
        #if !os(macOS) && canImport(UIKit)
        if !isAvailable(forOrientation: .portrait, currentOrientation: currentOrientation) {
            return "Feature requires portrait orientation."
        }
        if !isAvailable(forSizeClass: .regular, currentSizeClass: currentSizeClass) {
            return "Feature requires regular size class."
        }
        #endif
        
        return "Feature is not available due to custom conditions."
    }
    #endif
}
