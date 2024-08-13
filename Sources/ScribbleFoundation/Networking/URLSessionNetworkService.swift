//
//  URLSessionNetworkService.swift
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

import Network
import Foundation

/// A network service that uses `URLSession` to perform network requests and handle responses asynchronously.
///
/// `SCRURLSessionNetworkService` implements the `Networking` protocol and provides methods for
///  fetching data and handling network requests. This class leverages `async/await` for asynchronous
///  operations and supports decoding JSON responses into Swift types.
///
/// ## Features
/// - Asynchronous network requests with `async/await`.
/// - Decodes responses into `Decodable` types.
/// - Validates HTTP responses to ensure successful status codes.
///
/// ## Example Usage
///
/// ```swift
/// // Create an instance of the network service
/// let networkService = SCRURLSessionNetworkService()
///
/// // Define an endpoint
/// let endpoint = APIEndpoint(path: "https://api.example.com/data",
///                            method: .get, parameters: nil)
///
/// // Fetch data from the endpoint
/// Task {
///     do {
///         let data: MyDecodableType = try await networkService.fetch(endpoint)
///         // Handle the decoded data
///     } catch {
///         // Handle errors
///     }
/// }
/// ```
///
/// - Note: Available from iOS 18.0 and macOS 15.0.
@available(iOS 18.0, macOS 15.0, *)
public final class SCRURLSessionNetworkService: Networking {
    
    private let session: URLSession
    
    /// Initializes a new `SCRURLSessionNetworkService` instance with the specified `URLSession`.
    ///
    /// - Parameter session: The `URLSession` to use for network requests. Defaults to `URLSession.shared`.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetches and decodes data from the specified endpoint into a Swift type.
    ///
    /// This method performs a network request to the provided endpoint, waits for the response,
    /// and then decodes the response data into the specified type.
    ///
    /// - Parameter endpoint: The `Endpoint` object representing the network request details.
    /// - Returns: A `T` instance, which is the decoded data of type `T`.
    /// - Throws: An error if the network request fails or if decoding fails.
    public func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    /// Performs a network request to the specified endpoint and returns the raw data.
    ///
    /// This method performs a network request to the provided endpoint and checks if the response
    /// status code indicates success (200-299). It returns the raw data from the response.
    ///
    /// - Parameter endpoint: The `Endpoint` object representing the network request details.
    /// - Returns: The raw data received from the network request.
    /// - Throws: An error if the network request fails or if the response status code indicates a failure.
    public func request(_ endpoint: Endpoint) async throws -> Data {
        let (data, response) = try await session.data(for: endpoint.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
