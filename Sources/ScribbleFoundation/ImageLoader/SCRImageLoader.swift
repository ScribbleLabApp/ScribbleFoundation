//
//  SCRImageLoader.swift
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

#if canImport(UIKit)
import UIKit
public typealias _Image = UIImage
#else
import AppKit
public typealias _Image = NSImage
#endif

/// A utility class for asynchronously loading and caching images from URLs.
///
/// This class provides functionality to load images from network URLs and cache them to avoid redundant network requests.
/// It supports both iOS and macOS by using platform-specific image types: `UIImage` on iOS and `NSImage` on macOS.
///
/// - Note: This class uses `NSCache` for in-memory caching of images. Cached images are identified by their URL strings.
///
/// Example usage:
/// ```swift
/// let imageLoader = ImageLoader()
/// Task {
///     if let image = await imageLoader.load(from: URL(string: "https://example.com/image.png")!) {
///         // Use the loaded image
///     }
/// }
/// ```
@available(iOS 18.0, macOS 15.0, *)
public final class ImageLoader {
    private let cache = NSCache<NSString, _Image>()
    
    /// Loads an image from the specified URL asynchronously.
    ///
    /// First, checks if the image is already cached. If not, it fetches the image data from the URL, creates an image,
    /// caches it, and then returns it.
    ///
    /// - Parameter url: The URL of the image to load.
    /// - Returns: An optional `_Image`. Returns the image if successfully loaded and cached; otherwise, returns `nil`.
    public func load(from url: URL) async -> _Image? {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = _Image(data: data) {
                cache.setObject(image, forKey: url.absoluteString as NSString)
                return image
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        
        return nil
    }
}
