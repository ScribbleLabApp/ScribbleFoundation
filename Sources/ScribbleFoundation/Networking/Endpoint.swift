//
//  Endpoint.swift
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

/// A protocol that defines a blueprint for creating network requests.
///
/// Conforming types must provide a `urlRequest` property that constructs a `URLRequest`
/// instance for the specific endpoint.
///
/// The `Endpoint` protocol serves as a foundation for defining various API endpoints and
/// constructing requests for interacting with network services. It allows for strong typing and
/// clear separation of concerns in network operations.
@available(iOS 18.0, macOS 15.0, *)
public protocol Endpoint {
    
    /// A `URLRequest` instance representing the network request for this endpoint.
    ///
    /// The `urlRequest` property constructs the necessary request, including URL, HTTP method, and any additional parameters required for the request.
    ///
    /// - Returns: A `URLRequest` object configured with the endpoint's details.
    var urlRequest: URLRequest { get }
}

/// A concrete implementation of the `Endpoint` protocol, representing a network endpoint.
///
/// This struct provides a way to define an API endpoint with a specific URL path, HTTP method,
/// and optional parameters. It constructs a `URLRequest` based on these properties.
///
/// Example Usage:
/// ```swift
/// let endpoint = APIEndpoint(path: "https://api.example.com/resource", method: .get, parameters: ["key": "value"])
/// let request = endpoint.urlRequest
/// ```
@available(iOS 18.0, macOS 15.0, *)
public struct APIEndpoint: Endpoint {
    /// The URL path for the endpoint.
    public let path: String
    
    /// The HTTP method for the request, represented by ``MethodType``.
    ///
    /// This enum provides a type-safe way to specify HTTP methods, ensuring only valid methods are used.
    public let method: MethodType
    
    /// Optional parameters to be included in the request.
    ///
    /// These parameters are added to the URL query string if the HTTP method is "GET", or to the request body if the method is "POST" or "PUT".
    public let parameters: [String: Any]?
    
    /// Constructs a `URLRequest` instance based on the endpoint's properties.
    ///
    /// This property builds a `URLRequest` object by combining the `path`, `method`, and `parameters`. It sets up the request URL, HTTP method, and query items or body as needed.
    ///
    /// - Returns: A `URLRequest` configured with the endpoint's path, method, and parameters.
    public var urlRequest: URLRequest {
        var components = URLComponents(string: path)!
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.requestString
        return request
    }
}
