//
//  SUNetworkMonitor.swift
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

import Atomics
import Network
import Foundation
import ScribbleFoundation

internal final class SUNetworkMonitor: Sendable {
    
    /// A thread-safe boolean that indicates if the device is connected to the internet.
    private let _isConnectedToInternet = ManagedAtomic<Bool>(false)
    
    /// A boolean property that provides the current internet connection status.
    ///
    /// This property returns the latest value of the connection status, which is managed in a
    /// thread-safe manner using `ManagedAtomic`.
    ///
    /// - Returns: A boolean indicating whether the device is connected to the internet.
    public var isConnectedToInternet: Bool {
        return _isConnectedToInternet.load(ordering: .sequentiallyConsistent)
    }
    
    
    /// The network path monitor used to detect changes in network connectivity.
    private let monitor = NWPathMonitor()
    
    /// The dispatch queue on which the network monitor runs.
    private let monitorQueue = DispatchQueue(label: "NetworkingMonitor")
    
    
    /// Initializes a new `SCRNetworkingMonitor` instance and starts monitoring network status.
    ///
    /// This initializer sets up the `NWPathMonitor` to start monitoring network changes immediately.
    public init() {
        startMonitoring()
    }
    
    /// Stops monitoring network status.
    ///
    /// This method cancels the network path monitoring and cleans up resources.
    deinit {
        stopMonitoring()
    }
    
    /// Starts monitoring network status.
    ///
    /// Sets the `NWPathMonitor`'s path update handler to update the internet connection status
    /// whenever a network change is detected.
    internal func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.updateConnectionStatus(path: path)
            }
        }
        
        monitor.start(queue: monitorQueue)
    }
    
    /// Stops monitoring network status.
    ///
    /// This method cancels the `NWPathMonitor` and stops receiving network status updates.
    internal func stopMonitoring() {
        monitor.cancel()
    }
    
    /// Updates the connection status based on the provided network path.
    ///
    /// This method is called on the main thread to ensure thread safety when updating the connection status.
    ///
    /// - Parameter path: The `NWPath` object containing the latest network status information.
    @MainActor
    private func updateConnectionStatus(path: NWPath) {
        _isConnectedToInternet.store(path.status == .satisfied, ordering: .sequentiallyConsistent)
        
        if path.status == .satisfied {
            suLogger.log(
                "Update Service: Connected to internet",
                with: .info
            )
        }
    }
}
