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
//     contributors may be used to endorse or promote products derived from this
//     software without specific prior written permission.
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

import SwiftUI
import QuickLookUI

/// A SwiftUI view wrapper for presenting Quick Look previews on macOS.
@available(macOS 15.0, *)
private struct _QuickLookPreviewPanelPresenter: NSViewRepresentable {
    private var isPresented: Binding<Bool>
    private var items: () -> [QLPreviewItem]
    
    /// Initializes a `_QuickLookPreviewPanelPresenter` instance.
    ///
    /// - Parameters:
    ///   - items: A closure returning an array of `QLPreviewItem` instances.
    ///   - isPresented: A binding that determines whether the Quick Look panel is presented.
    init(
        items: @escaping @autoclosure () -> [QLPreviewItem],
        isPresented: Binding<Bool>
    ) {
        self.isPresented = isPresented
        self.items = items
    }
    
    /// Creates and returns an `NSView` instance for the Quick Look preview.
    ///
    /// - Parameter context: The context in which the view is created.
    /// - Returns: An `NSViewType` instance.
    func makeNSView(
        context: Context
    ) -> NSViewType {
        let view = NSViewType()
        return view
    }
    
    /// Updates the `NSView` instance with new information.
    ///
    /// - Parameters:
    ///   - view: The `NSViewType` instance to update.
    ///   - context: The context in which the update is made.
    func updateNSView(
        _ view: NSViewType,
        context: Context
    ) {
        view.coordinator = context.coordinator
        context.coordinator.items = items
        context.coordinator.isPresented = isPresented
        
        if isPresented.wrappedValue {
            context.coordinator.show()
        } else {
            context.coordinator.hide()
        }
    }
    
    /// Creates and returns a `Coordinator` instance.
    ///
    /// - Returns: A `Coordinator` instance.
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: isPresented)
    }
}

@available(macOS 15.0, *)
extension _QuickLookPreviewPanelPresenter {
    
    /// Initializes a `_QuickLookPreviewPanelPresenter` with URLs.
    ///
    /// - Parameters:
    ///   - items: A closure returning an array of `URL` instances.
    ///   - isPresented: A binding that determines whether the Quick Look panel is presented.
    init(
        items: @escaping @autoclosure () -> [URL],
        isPresented: Binding<Bool>
    ) {
        self.init(items: items().map({ $0 as QLPreviewItem }), isPresented: isPresented)
    }
    
    /// Initializes a `_QuickLookPreviewPanelPresenter` with a single `QLPreviewItem`.
    ///
    /// - Parameters:
    ///   - item: The `QLPreviewItem` to display.
    ///   - isPresented: A binding that determines whether the Quick Look panel is presented.
    init<T: QLPreviewItem>(
        item: T,
        isPresented: Binding<Bool>
    ) {
        self.init(items: [item], isPresented: isPresented)
    }
    
    /// Initializes a `_QuickLookPreviewPanelPresenter` with a single `URL`.
    ///
    /// - Parameters:
    ///   - url: The `URL` to display.
    ///   - isPresented: A binding that determines whether the Quick Look panel is presented.
    init(
        url: URL,
        isPresented: Binding<Bool>
    ) {
        self.init(items: [url], isPresented: isPresented)
    }
}

@available(macOS 15.0, *)
extension _QuickLookPreviewPanelPresenter {
    
    /// An `NSView` subclass for managing the Quick Look preview panel control.
    class NSViewType: NSView {
        weak var coordinator: Coordinator?
        
        override func acceptsPreviewPanelControl(
            _ panel: QLPreviewPanel!
        ) -> Bool {
            coordinator?.isPresented.wrappedValue ?? false
        }
        
        override open func beginPreviewPanelControl(
            _ panel: QLPreviewPanel!
        ) {}
        
        override open func endPreviewPanelControl(
            _ panel: QLPreviewPanel!
        ) {
            coordinator?.hide()
        }
    }
    
    /// A coordinator for managing the Quick Look preview panel's data source and delegate methods.
    class Coordinator: NSObject, QLPreviewPanelDataSource, @preconcurrency QLPreviewPanelDelegate {
        static let panelWillCloseNotification = Notification.Name(rawValue: "QuickLookPreviewPanelWillClose")
        
        fileprivate var items: (() -> [QLPreviewItem]) = { [] }
        fileprivate var isPresented: Binding<Bool>
        
        fileprivate var previewPanel: QLPreviewPanel?
        fileprivate var previewItems: [QLPreviewItem]?
        
        fileprivate init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
            super.init()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(panelWillClose),
                name: QLPreviewPanel.willCloseNotification,
                object: nil
            )
        }
        
        @MainActor fileprivate func show() {
            let panel = self.setupPreviewPanel()
            panel.makeKeyAndOrderFront(nil)
        }
        
        @MainActor fileprivate func hide() {
            _tearDownPreviewPanel()
        }
        
        @MainActor @discardableResult
        private func setupPreviewPanel() -> QLPreviewPanel {
            if let previewPanel {
                return previewPanel
            }
            
            self.previewItems = items()
            let panel = QLPreviewPanel.shared()!
            panel.delegate = self
            panel.updateController()
            panel.dataSource = self
            self.previewPanel = panel
            
            return panel
        }
        
        @MainActor private func _tearDownPreviewPanel() {
            guard let previewPanel else { return }
            
            if isPresented.wrappedValue {
                DispatchQueue.main.async { [self] in
                    isPresented.wrappedValue = false
                }
            }
            
            previewPanel.dataSource = nil
            previewPanel.delegate = nil
            self.previewPanel = nil
            self.previewItems = nil
        }
        
        func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
            previewItems?.count ?? 0
        }
        
        override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
            return true
        }
        
        @MainActor override open func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
            self.previewPanel?.delegate = self
        }
        
        @MainActor override open func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
            _tearDownPreviewPanel()
        }
        
        func previewPanel(
            _ panel: QLPreviewPanel!,
            previewItemAt index: Int
        ) -> QLPreviewItem {
            previewItems![index] as QLPreviewItem
        }
        
        @MainActor func previewPanel(
            _ panel: QLPreviewPanel!,
            handle event: NSEvent!
        ) -> Bool {
            if event.type == .keyDown && event.keyCode == 53 { // Escape key
                _tearDownPreviewPanel()
                return true
            }
            return false
        }
        
        @MainActor @objc private func panelWillClose() {
            _tearDownPreviewPanel()
        }
        
        func windowShouldClose(_ sender: NSWindow) -> Bool {
            _tearDownPreviewPanel()
            return true
        }
        
        func windowWillClose(_ notification: Notification) {
            _tearDownPreviewPanel()
        }
    }
}

// MARK: - Preview

@available(macOS 15.0, *)
extension View {
    
    /// Presents a Quick Look preview for a given `QLPreviewItem`.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that determines whether the Quick Look panel is presented.
    ///   - item: A closure returning a `QLPreviewItem` to display.
    /// - Returns: A view that presents the Quick Look preview.
    public func quickLookPreview(
        isPresented: Binding<Bool>,
        item: @escaping @autoclosure () -> any QLPreviewItem
    ) -> some View {
        background {
            _QuickLookPreviewPanelPresenter(item: item(), isPresented: isPresented)
                .accessibilityHidden(true) // Removed .frameZeroClipped()
        }
    }
    
    /// Presents a Quick Look preview for a given `URL`.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that determines whether the Quick Look panel is presented.
    ///   - item: A closure returning a `URL` to display.
    /// - Returns: A view that presents the Quick Look preview.
    public func quickLookPreview(
        isPresented: Binding<Bool>,
        item: @escaping @autoclosure () -> URL
    ) -> some View {
        quickLookPreview(isPresented: isPresented, item: item() as QLPreviewItem)
    }
    
    /// Presents a Quick Look preview for an array of `QLPreviewItem` instances.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that determines whether the Quick Look panel is presented.
    ///   - items: A closure returning an array of `QLPreviewItem` instances to display.
    /// - Returns: A view that presents the Quick Look preview.
    public func quickLookPreview<T: QLPreviewItem>(
        isPresented: Binding<Bool>,
        items: @escaping @autoclosure () -> [T]
    ) -> some View {
        background {
            _QuickLookPreviewPanelPresenter(items: items(), isPresented: isPresented)
                .accessibilityHidden(true)
        }
    }
}

#endif
