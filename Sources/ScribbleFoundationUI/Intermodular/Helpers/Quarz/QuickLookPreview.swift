//
//  _QuickLookPreviewPanelPresenter.swift
//  ScribbleFoundationUI
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

#if os(macOS)

import Quartz
import SwiftUI

/// A class that represents a Quick Look preview item on macOS.
@available(macOS 15.0, *)
public class QuickLookPreviewItem: NSObject, QLPreviewItem {
    
    /// The URL of the item to be previewed.
    public var previewItemURL: URL?
    
    /// The title of the item to be previewed.
    public var previewItemTitle: String?
    
    /// Initializes a new `QuickLookPreviewItem` instance.
    ///
    /// - Parameters:
    ///   - url: The URL of the item to be previewed.
    ///   - title: The title of the item to be previewed.
    public init(url: URL, title: String) {
        self.previewItemURL = url
        self.previewItemTitle = title
    }
}

/// A SwiftUI view that presents a Quick Look preview on macOS.
@available(macOS 15.0, *)
public struct QuickLookPreview: NSViewRepresentable {
    
    /// The type of view used for the Quick Look preview.
    public typealias NSViewType = QLPreviewView
    
    /// The URL of the item to be previewed.
    public let url: URL?
    
    /// Initializes a new `QuickLookPreview` instance.
    ///
    /// - Parameter url: The URL of the item to be previewed.
    public init(url: URL?) {
        self.url = url
    }
    
    /// Creates and returns an `NSView` instance for the Quick Look preview.
    ///
    /// - Parameter context: The context in which the view is created.
    /// - Returns: An `NSViewType` instance.
    public func makeNSView(
        context: Context
    ) -> NSViewType {
        let nsView = QLPreviewView()
        
        nsView.autostarts = true
        
        return nsView
    }
    
    /// Updates the `NSView` instance with new information.
    ///
    /// - Parameters:
    ///   - nsView: The `NSViewType` instance to update.
    ///   - context: The context in which the update is made.
    public func updateNSView(
        _ nsView: NSViewType,
        context: Context
    ) {
        nsView.previewItem = url.map({ $0 as QLPreviewItem })
        nsView.refreshPreviewItem()
    }
}

@available(macOS 15.0, *)
extension QuickLookPreview {
    
    /// Initializes a `QuickLookPreview` with a `QuickLookPreviewItem`.
    ///
    /// - Parameter item: The `QuickLookPreviewItem` to be previewed.
    public init(
        item: QuickLookPreviewItem
    ) {
        self.init(url: item.previewItemURL)
    }
}

#endif
