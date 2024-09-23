//
//  SAAccessibilityElement.swift
//  AccessibilityKit
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

import SwiftUI
import Foundation

/// A SwiftUI View extension to enhance accessibility by adding custom labels, hints, traits, values,
/// focus handling, and actions.
///
/// This method allows you to define accessibility metadata for a view, improving its usability with
/// assistive technologies like VoiceOver. You can specify a custom accessibility label, hint,
/// traits (e.g., making an element adjustable), value, and a set of custom actions accessible to
/// VoiceOver users. Additionally, it supports focus states for accessibility, providing enhanced
/// navigation and interaction.
@available(iOS 18.0, macOS 15.0, *)
public extension View {
    
    /// Adds accessibility information to the view, including label, hint, traits, value, focus state,
    /// and custom actions.
    ///
    /// - Parameters:
    ///   - label:                A `String` that serves as the accessibility label for the view.
    ///                           This is a brief description of the view's purpose.
    ///   - hint:                 A `String` that provides additional context or instructions to
    ///                           users interacting with the view. This is typically a short phrase
    ///                           explaining the control's function.
    ///   - traits:               A `AccessibilityTraits` object that describes the view’s
    ///                           behavior (e.g., `.button`, `.adjustable`). This helps
    ///                           VoiceOver classify the element appropriately.
    ///   - value:                An optional `String` representing the current value of the view.
    ///                           For instance, a slider might have its value expressed as a percentage.
    ///   - isFocused:            An optional `AccessibilityFocusState<Bool>.Binding`
    ///                           that specifies whether the view is currently focused by an assistive
    ///                           technology like VoiceOver. This helps manage dynamic focus
    ///                           states in more complex views.
    ///   - accessibilityActions: An array of tuples, where each tuple contains a `String`
    ///                           representing the action’s name and a closure (`() -> Void`)
    ///                           that defines the action’s behavior when invoked by VoiceOver.
    ///                           Custom actions can be triggered with VoiceOver gestures.
    ///
    /// - Returns: A modified view that incorporates the provided accessibility information.
    ///
    /// This method applies the specified accessibility properties, including label, hint, traits, and value, to the view.
    /// It conditionally adds focus states and custom actions, enabling assistive technologies to interact more
    /// effectively with the view.
    ///
    /// - Important: Ensure that the provided `accessibilityActions` are meaningful and usable with
    ///              assistive technologies. For example, custom actions should add real value beyond the
    ///              standard touch interaction.
    ///
    /// The following example shows how to use `accessibilityElement` to add accessibility information to a
    /// `Slider` view. The slider includes a custom label, hint, dynamic value, focus state, and custom actions.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @AccessibilityFocusState private var isFocused: Bool
    ///     @State private var sliderValue: Double = 50
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Slider(value: $sliderValue, in: 0...100)
    ///                 .accessibilityElement(
    ///                     label: "Volume Control",
    ///                     hint: "Adjust the volume level",
    ///                     traits: .adjustable,
    ///                     value: "\(Int(sliderValue))%",
    ///                     isFocused: $isFocused,
    ///                     accessibilityActions: [
    ///                         ("Max Volume", { sliderValue = 100 }),
    ///                         ("Mute", { sliderValue = 0 })
    ///                     ]
    ///                 )
    ///
    ///             Text(isFocused ? "Focused!" : "Not Focused")
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// In this example:
    ///
    /// - **Label**:                    The slider has an accessibility label of "Volume Control", making its purpose clear to VoiceOver users.
    /// - **Hint**:                      The hint provides additional guidance, telling the user that the slider adjusts the volume level.
    /// - **Traits**:                    The `.adjustable` trait informs VoiceOver that the slider’s value can be changed.
    /// - **Value**:                    The current slider value is dynamically set as the percentage of the volume level.
    /// - **Focus**:                   The focus state is managed with an `AccessibilityFocusState`, enabling the slider to
    ///                     respond to VoiceOver focus events.
    /// - **Custom Actions**:  Two custom actions—"Max Volume" and "Mute"—are added. These allow VoiceOver users
    ///                     to trigger specific actions (setting the slider value to max or muting) without interacting with
    ///                     the slider directly.
    ///
    /// This structure significantly improves the slider's accessibility, making it more intuitive and easier to use for individuals who
    /// rely on VoiceOver. Custom actions provide a direct way to change the volume to maximum or mute the sound entirely,
    /// offering greater flexibility in user interaction.
    func accessibilityElement(
        label: String,
        hint: String,
        traits: AccessibilityTraits,
        value: String? = nil,
        isFocused: AccessibilityFocusState<Bool>.Binding? = nil,
        accessibilityActions: [(String, () -> Void)] = []
    ) -> some View {
        self
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(label))
            .accessibilityHint(Text(hint))
            .accessibilityAddTraits(traits)
            ._applyIf(value != nil) { view in
                view.accessibilityValue(Text(value!))
            }
            ._applyIf(isFocused != nil) { view in
                view.accessibilityFocused(isFocused!)
            }
            ._applyIf(!accessibilityActions.isEmpty) { view in
                view.accessibilityActions {
                    ForEach(accessibilityActions, id: \.0) { actionName, action in
                        accessibilityAction(named: Text(actionName), action)
                    }
                }
            }
    }
}

/// A utility class that centralizes accessibility-related functionality for SwiftUI views.
///
/// The `AccessibilityHelper` class provides commonly-used accessibility methods to make SwiftUI
/// views more accessible to VoiceOver users. It includes functionalities for setting accessibility labels, hints,
/// traits, values, focus management, and custom actions.
///
/// The class is designed to ensure that accessibility features are applied consistently and efficiently across
/// various UI components.
///
/// - Important: All the methods in this class are static, meaning they can be used without instantiating the class.
@available(iOS 18.0, macOS 15.0, *)
public extension View {
    
    /// Applies accessibility information such as label, hint, and traits to a given view.
    ///
    /// This method adds the basic accessibility elements to a view, including its descriptive label,
    /// hint for VoiceOver users, and accessibility traits that describe the behavior of the element.
    ///
    /// - Parameters:
    ///   - view:    The `AnyView` to which the accessibility properties should be applied.
    ///   - label:   A `String` describing the purpose of the view for VoiceOver users.
    ///   - hint:    A `String` providing additional information or guidance for the view.
    ///   - traits: `AccessibilityTraits` that describe the element’s behavior,
    ///              such as `.button` or `.adjustable`.
    ///
    /// - Returns: A modified `AnyView` with the specified accessibility properties.
    ///
    /// ```swift
    /// let buttonView = Button("Tap Me") {}
    /// let accessibleButton = AccessibilityHelper.setAccessibility(
    ///     view: AnyView(buttonView),
    ///     label: "Tap Me Button",
    ///     hint: "Taps the button",
    ///     traits: .isButton
    /// )
    /// ```
    static func setAccessibility(
        view: AnyView,
        label: String,
        hint: String,
        traits: AccessibilityTraits
    ) -> AnyView {
        return AnyView(
            view
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(label))
                .accessibilityHint(Text(hint))
                .accessibilityAddTraits(traits)
        )
    }
    
//    /// Adds custom accessibility actions to a view for VoiceOver users.
//    ///
//    /// This method enables the addition of custom VoiceOver actions, which can be triggered via
//    /// specific VoiceOver gestures. Each action consists of a name and an associated closure that
//    /// is executed when the action is selected.
//    ///
//    /// - Parameters:
//    ///   - view:    The `AnyView` to which the custom actions should be applied.
//    ///   - actions: An array of tuples where each tuple contains a `String` for the action
//    ///              name and a closure (`() -> Void`) that executes the corresponding action.
//    ///
//    /// - Returns: A modified `AnyView` with the specified accessibility actions.
//    ///
//    /// ```swift
//    /// let buttonView = Button("Tap Me") {}
//    /// let accessibleButton = AccessibilityHelper.addAccessibilityActions(
//    ///     view: AnyView(buttonView),
//    ///     actions: [
//    ///         ("Action 1", { print("Action 1 performed") }),
//    ///         ("Action 2", { print("Action 2 performed") })
//    ///     ]
//    /// )
//    /// ```
//    static func addAccessibilityActions(
//        view: AnyView,
//        actions: [(String, () -> Void)]
//    ) -> AnyView {
//        return AnyView(
//            view.accessibilityActions {
//                ForEach(actions, id: \.0) { actionName, action in
//                    accessibilityAction(named: Text(actionName), action)
//                }
//            }
//        )
//    }
    
    /// Sets the dynamic accessibility value for a view.
    ///
    /// This method allows the specification of a dynamic value (e.g., a percentage or a numeric value)
    /// for accessibility purposes. VoiceOver will announce this value when interacting with the view.
    ///
    /// - Parameters:
    ///   - view:  The `AnyView` to which the dynamic value should be applied.
    ///   - value: A `String` representing the dynamic value (e.g., "50%").
    ///
    /// - Returns: A modified `AnyView` with the specified accessibility value.
    ///
    /// ```swift
    /// let sliderView = Slider(value: .constant(0.5), in: 0...1)
    /// let accessibleSlider = AccessibilityHelper.setAccessibilityValue(
    ///     view: AnyView(sliderView),
    ///     value: "50%"
    /// )
    /// ```
    static func setAccessibilityValue(
        view: AnyView,
        value: String? = nil
    ) -> AnyView {
        var modifiedView = view
        
        if let value = value {
            modifiedView = AnyView(
                modifiedView.accessibilityValue(Text(value))
            )
        }
        
        return modifiedView
    }
    
    /// Manages the focus state of a view for accessibility purposes.
    ///
    /// This method allows the view to be focused using accessibility technologies such as
    /// VoiceOver, enabling dynamic focus management for complex view hierarchies.
    ///
    /// - Parameters:
    ///   - view:      The `AnyView` to apply the focus state to.
    ///   - isFocused: An optional `AccessibilityFocusState<Bool>.Binding` that
    ///                manages the focus state of the view.
    ///
    /// - Returns: A modified `AnyView` that incorporates the focus state.
    ///
    /// ```swift
    /// @AccessibilityFocusState private var isFocused: Bool
    /// let textView = Text("Hello, World!")
    /// let accessibleTextView = AccessibilityHelper.setAccessibilityFocus(
    ///     view: AnyView(textView),
    ///     isFocused: $isFocused
    /// )
    /// ```
    static func setAccessibilityFocus(
        view: AnyView,
        isFocused: AccessibilityFocusState<Bool>.Binding? = nil
    ) -> AnyView {
        var modifiedView = view
        
        if let isFocused = isFocused {
            modifiedView = AnyView(
                modifiedView.accessibilityFocused(isFocused)
            )
        }
        
        return modifiedView
    }
}
