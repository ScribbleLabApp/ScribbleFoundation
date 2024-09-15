//
//  AccessibilityElement.swift
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
            .applyIf(value != nil) { view in
                view.accessibilityValue(Text(value!))
            }
            .applyIf(isFocused != nil) { view in
                view.accessibilityFocused(isFocused!)
            }
            .applyIf(!accessibilityActions.isEmpty) { view in
                view.accessibilityActions {
                    ForEach(accessibilityActions, id: \.0) { actionName, action in
                        accessibilityAction(named: Text(actionName), action)
                    }
                }
            }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public extension View {
    /// Utility to conditionally apply a modifier to a View.
    /// This function applies a given transformation to the view only if the condition is met.
    ///
    /// - Parameters:
    ///   - condition: A `Bool` determining whether the transformation should be applied.
    ///   - transform: A closure that applies the transformation to the view.
    ///
    /// - Returns: The transformed view if the condition is `true`, or the original view if `false`.
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
