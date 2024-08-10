//
//  NotificationCenterManager.swift
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

/// A utility class for posting and observing notifications in a type-safe manner.
public final class NotificationCenterManager {
    private let notificationCenter = NotificationCenter.default
    
    /// Posts a notification with the specified name and optional userInfo.
    ///
    /// - Parameters:
    ///   - name: The name of the notification.
    ///   - userInfo: Optional userInfo dictionary to include with the notification.
    public func post(name: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
        notificationCenter.post(name: name, object: nil, userInfo: userInfo)
    }
    
    /// Adds an observer for the specified notification name.
    ///
    /// - Parameters:
    ///   - name: The name of the notification.
    ///   - observer: The observer to call when the notification is posted.
    ///   - queue: The operation queue to deliver the notification on. If `nil`, the main queue is used.
    public func addObserver(for name: Notification.Name, using block: @Sendable @escaping (Notification) -> Void, queue: OperationQueue? = .main) {
        notificationCenter.addObserver(forName: name, object: nil, queue: queue, using: block)
    }
    
    /// Removes all observers.
    public func removeAllObservers() {
        notificationCenter.removeObserver(self)
    }
}
