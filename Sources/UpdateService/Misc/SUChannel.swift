//
//  SUChannel.swift
//  UpdateService
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

/// An enumeration representing the different update channels for the app.
///
/// - `stable`: Represents the stable channel, where users receive stable production releases.
/// - `pre_release`: Represents the pre-release channel, where users receive alpha/beta releases.
@available(iOS 18.0, macOS 15.0, *)
public enum SUChannel: String {
    
    /// The stable update channel.
    case stable
    
    /// The pre-release update channel.
    case pre_release
    
    /// The currently subscribed update channel, if any.
    ///
    /// This property retrieves the value from `UserDefaults` where the subscribed channel is saved.
    /// If no channel has been saved, this property returns `nil`.
    ///
    /// - Returns: The `SUChannel` if a channel is subscribed, otherwise `.stable`.
    public static var subscribed: SUChannel? {
        guard let channelString = UserDefaults.standard.string(forKey: "kSubscribedChannel") else {
            return .stable
        }
        
        return SUChannel(rawValue: channelString)
    }
    
    /// Sets the current channel as the subscribed channel and stores it in `UserDefaults`.
    ///
    /// This method writes the string representation of the `SUChannel` to `UserDefaults`
    /// under the key `"kSubscribedChannel"`, allowing it to persist across app sessions.
    ///
    /// - Note: This method does not check if a channel is already subscribed.
    public func setAsSubscribed() {
        UserDefaults.standard.set(rawValue, forKey: "kSubscribedChannel")
    }
    
    /// A user-friendly display name for the update channel.
    ///
    /// - Returns: A `String` representing the name of the update channel.
    ///   - For `.stable`: Returns "Stable".
    ///   - For `.pre_release`: Returns "Alpha/Beta".
    var displayName: String {
        switch self {
        case .stable:
            return "Stable"
        case .pre_release:
            return "Alpha/Beta"
        }
    }
}
