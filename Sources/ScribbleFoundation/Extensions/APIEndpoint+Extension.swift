//
//  APIEndpoint+Extension.swift
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

@available(iOS 18.0, macOS 15.0, *)
public extension APIEndpoint {
    /// An enumeration representing the various HTTP methods used in network requests.
    ///
    /// This enum provides a type-safe way to specify HTTP methods, reducing the chance of errors
    /// that might occur with raw string literals. Each case in the enum corresponds to a common HTTP method.
    enum MethodType {
        
        /// Represents the HTTP GET method used for retrieving resources.
        case get
        
        /// Represents the HTTP POST method used for submitting data to be processed.
        case post
        
        /// Represents the HTTP PUT method used for updating resources.
        case put
        
        /// Represents the HTTP PATCH method used for partially updating resources.
        case patch
        
        /// Represents the HTTP DELETE method used for removing resources.
        case delete
        
        /// A computed property that returns the string representation of the HTTP method.
        ///
        /// This property converts the enum case to the corresponding HTTP method string,
        /// which can be used to configure the `URLRequest` object. This ensures that
        /// the HTTP method is represented as a valid string for network requests.
        ///
        /// - Returns: A string representing the HTTP method, such as "GET", "POST", "PUT", "PATCH", or "DELETE".
        var requestString: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .patch: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }
}
