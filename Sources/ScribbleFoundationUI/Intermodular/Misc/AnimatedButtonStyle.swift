//
//  AnimatedButtonStyle.swift
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

import SwiftUI
import Foundation


/// A button style that applies an animated gradient border and text effect.
///
/// `AnimatedButtonStyle` adds a gradient border and text color animation to any button. The animation is created using a
/// `LinearGradient` and moves continuously across the button. The gradient colors and animation duration can be customized.
///
/// ```swift
/// Button(action: {
///     print("Button tapped!")
/// }) {
///     Text("Tap Me")
/// }
/// .animatedButtonStyle(
///     gradientColors: [.orange, .pink, .yellow],
///     animationDuration: 3.0
/// )
/// ```
///
/// - Parameters:
///   - gradientColors: An array of `Color` objects that defines the gradient for the button's border and text.
///   - animationDuration: A `Double` representing the duration of the gradient animation in seconds.
@available(iOS 18.0, macOS 15.0, *)
public struct AnimatedButtonStyle: ButtonStyle {
    
    /// The starting point of the gradient animation.
    @State private var start = UnitPoint(x: -1, y: 0)
    
    /// The ending point of the gradient animation.
    @State private var end = UnitPoint(x: 1, y: 0)
    
    /// An array of `Color` objects that defines the gradient for the button's border and text.
    var gradientColors: [Color]
    
    /// The duration of the gradient animation in seconds.
    var animationDuration: Double
    
    /// Creates the view that represents the body of a button.
    ///
    /// This method constructs the button's view by applying padding, a background with an animated gradient border,
    /// and an overlay for the animated text gradient.
    ///
    /// - Parameter configuration: A structure that contains information about the button's current state.
    /// - Returns: A view that represents the button's content with a gradient animation.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: start,
                    endPoint: end
                ).mask(RoundedRectangle(cornerRadius: 10)
                 .stroke(lineWidth: 4))
            )
            .overlay(
                configuration.label
                    .foregroundColor(.clear)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: start,
                            endPoint: end
                        ).mask(configuration.label)
                    )
            )
            .onAppear {
                withAnimation(
                    Animation.linear(
                        duration: animationDuration
                    ).repeatForever(autoreverses: false)
                ) {
                    start = UnitPoint(x: 1, y: 0)
                    end = UnitPoint(x: -1, y: 0)
                }
            }
    }
}

// TODO: Make parameters optional in the future
@available(iOS 18.0, macOS 15.0, *)
public extension View {
    
    /// Applies the `AnimatedButtonStyle` to a button with customizable gradient colors and animation duration.
    ///
    /// This modifier allows you to apply the `AnimatedButtonStyle` to any button in SwiftUI. You can customize the gradient colors
    /// and the animation duration, or use the default values.
    ///
    /// ```swift
    /// Button(action: {
    ///     print("Button tapped!")
    /// }) {
    ///     Text("Tap Me")
    /// }
    /// .animatedButtonStyle(
    ///     gradientColors: [.orange, .yellow, .blue],
    ///     animationDuration: 3.0
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - gradientColors: An array of `Color` objects used for the gradient. Defaults to `[.red, .yellow, .green, .blue, .purple, .pink]`.
    ///   - animationDuration: The duration of the gradient animation in seconds. Defaults to `2.0`.
    /// - Returns: A view that applies the `AnimatedButtonStyle`.
    func animatedButtonStyle(
        gradientColors: [Color] = [.red, .yellow, .green, .blue, .purple, .pink],
        animationDuration: Double = 2.0
    ) -> some View {
        self.buttonStyle(AnimatedButtonStyle(gradientColors: gradientColors, animationDuration: animationDuration))
    }
}
