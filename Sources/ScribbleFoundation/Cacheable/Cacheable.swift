//
//  Cacheable.swift
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

/// A protocol for objects that support caching functionality.
///
/// Conforming types implement methods to cache objects, retrieve them by key, and remove them from the cache.
/// This is useful for implementing various caching mechanisms, such as in-memory or persistent storage caches.
@available(iOS 18.0, macOS 15.0, *)
public protocol Cacheable {
    associatedtype Key
    associatedtype Value
    
    /// Caches an object with the specified key.
    ///
    /// - Parameters:
    ///   - key: The key to cache the object with. This key is used to uniquely identify the cached object.
    ///   - value: The object to cache. This is the value that will be associated with the key in the cache.
    /// - Note: Caching an object with the same key more than once will overwrite the existing cached object.
    func cache(key: Key, value: Value)
    
    /// Retrieves a cached object for the specified key.
    ///
    /// - Parameter key: The key to retrieve the object for. This key is used to look up the cached object.
    /// - Returns: The cached object associated with the key, or `nil` if no object is found for the given key.
    /// - Note: If the key does not exist in the cache, this method returns `nil`.
    func retrieve(for key: Key) -> Value?
    
    /// Removes a cached object for the specified key.
    ///
    /// - Parameter key: The key to remove the cached object for. This key is used to locate and remove the object from the cache.
    /// - Note: If the key does not exist in the cache, this method has no effect.
    func remove(for key: Key)
}
