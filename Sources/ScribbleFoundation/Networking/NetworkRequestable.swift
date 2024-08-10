//
//  NetworkRequestable.swift
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

/// A protocol for creating and executing network requests.
///
/// Conforming types implement this protocol to specify how to create a `URLRequest` and execute the network request.
/// The protocol defines a method for executing the request asynchronously and returning the response data.
///
/// - Note: The protocol is designed to be used with Swift's concurrency model, using `async` and `throws` for asynchronous
///         execution and error handling.
@available(iOS 18.0, macOS 15.0, *)
public protocol NetworkRequestable {
    
    /// Creates a `URLRequest` for the network request.
    ///
    /// This property provides the `URLRequest` that defines the details of the network request,
    /// including the URL, HTTP method, headers, and body.
    var urlRequest: URLRequest { get }
    
    /// Executes the network request and returns the response data.
    ///
    /// This method performs the network request asynchronously and returns the data received in the response.
    /// It throws an error if the request fails or if there is an issue with the response.
    ///
    /// - Returns: The response data as `Data`.
    /// - Throws: An error if the network request fails or if the response is invalid.
    func execute() async throws -> Data
}
