//
//  Networking.swift
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

/// A protocol that defines network operations for fetching and requesting data.
///
/// The `Networking` protocol outlines the methods required to perform network requests and handle
/// responses asynchronously. It supports fetching and decoding data from a specified endpoint,
/// as well as performing raw network requests.
@available(iOS 18.0, macOS 15.0, *)
public protocol Networking: AnyObject {
    
    /// Fetches and decodes data from the specified endpoint into a Swift type.
    ///
    /// This method performs a network request to the provided endpoint, waits for the response, and
    /// then decodes the response data into the specified type.
    ///
    /// - Parameter endpoint: The `Endpoint` object representing the network request details.
    /// - Returns: A `T` instance, which is the decoded data of type `T`.
    /// - Throws: An error if the network request fails or if decoding fails.
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    
    /// Performs a network request to the specified endpoint and returns the raw data.
    ///
    /// This method performs a network request to the provided endpoint and checks if the response
    /// status code indicates success (200-299). It returns the raw data from the response.
    ///
    /// - Parameter endpoint: The `Endpoint` object representing the network request details.
    /// - Returns: The raw data received from the network request.
    /// - Throws: An error if the network request fails or if the response status code indicates a failure.
    func request(_ endpoint: Endpoint) async throws -> Data
}
