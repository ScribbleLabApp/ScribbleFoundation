//
//  SAHaptics.swift
//  AccessibilityKit
//
//  Copyright (c) 2024 ScribbleLabApp LLC. All rights reserved
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this
//     list of conditions and the following disclaimer in the documentation
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
//

import Foundation
import CoreHaptics

public final class SAHaptics {
    private var hapticEngine: CHHapticEngine?
    
    public init() {
        if let error = startHapticEngine() {
            a11yLogger.log("Haptic Engine Initialization Error: \(error.localizedDescription)", with: .info)
        }
    }
    
    public func startHapticEngine() -> SAError? {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return .systemVersionIncompatible(
                "SAAccessibilityKit is unable to start CHHapticEngine due to unsupported hardware"
            )
        }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
            return nil
        } catch {
            return .hapticError("\(error.localizedDescription)")
        }
    }
    
    /// Plays a haptic pattern with customizable intensity and sharpness.
    ///
    /// - Parameters:
    ///   - intensity: A `Float` value representing the intensity of the haptic feedback (0.0 to 1.0).
    ///   - sharpness: A `Float` value representing the sharpness of the haptic feedback (0.0 to 1.0).
    ///
    /// - Returns: An optional `SAError` if there was an issue creating or playing the haptic pattern.
    public func playHaptic(intensity: Float, sharpness: Float) -> SAError? {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return .systemVersionIncompatible("Haptic feedback is not supported on this device.")
        }
        
        let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        ], relativeTime: 0)
        
        let hapticPattern: CHHapticPattern
        do {
            hapticPattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
        } catch {
            return .hapticError("Failed to create haptic pattern: \(error.localizedDescription)")
        }
        
        let player: CHHapticPatternPlayer
        do {
            player = try hapticEngine?.makePlayer(with: hapticPattern) ?? CHHapticPatternPlayer()
        } catch {
            return .hapticError("Failed to create haptic player: \(error.localizedDescription)")
        }
        
        do {
            try player.start(atTime: CHHapticTimeImmediate)
            return nil
        } catch {
            return .hapticError("Failed to start haptic player: \(error.localizedDescription)")
        }
    }
    
    public func stopHapticEngine() {
        hapticEngine?.stop()
    }
}
