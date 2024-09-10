//
//  BackdropBlur.swift
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

/// A UIView subclass that represents a backdrop layer using Core Animation's `CABackdropLayer`.
///
/// `UIBackdropView` provides a convenient way to access the `CABackdropLayer`, which is used to create a
/// visual backdrop effect (similar to the blurring effect seen in system UI elements). It overrides the `layerClass` property
/// to return `CABackdropLayer`, a private Core Animation class.
///
/// ```swift
/// let backdropView = UIBackdropView()
/// // Use `backdropView` in your custom UIView hierarchy
/// ```
///
/// This view is particularly useful for creating effects such as Gaussian blur, as found in the system's background elements.
///
/// - Note: If the `CABackdropLayer` is not available (e.g., on unsupported platforms or older OS versions), it defaults to `CALayer`.
@available(iOS 18.0, macOS 15.0, *)
public class UIBackdropView: UIView {
    
    /// Overrides the `layerClass` to provide a `CABackdropLayer` for backdrop effects.
    ///
    /// - Returns: The `CABackdropLayer` class, or `CALayer` if `CABackdropLayer` is unavailable.
    public override class var layerClass: AnyClass {
        NSClassFromString("CABackdropLayer") ?? CALayer.self
    }
}

/// A SwiftUI wrapper for `UIBackdropView` to allow backdrop effect in SwiftUI views.
///
/// `Backdrop` is a `UIViewRepresentable` that bridges UIKit's `UIBackdropView` to SwiftUI, enabling a backdrop layer effect in
/// SwiftUI layouts. It simplifies the use of complex Core Animation layers, such as the `CABackdropLayer`, in a declarative SwiftUI environment.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Backdrop()
///             .frame(width: 200, height: 200)
///     }
/// }
/// ```
///
/// - Note: `Backdrop` serves as the foundational component for adding background blur and other visual effects in SwiftUI by leveraging
///          UIKit under the hood.
@available(iOS 18.0, macOS 15.0, *)
public struct Backdrop: UIViewRepresentable {
    
    /// Creates and returns an instance of `UIBackdropView`.
    ///
    /// - Parameter context: The context object containing information about the current state of the view.
    /// - Returns: A new instance of `UIBackdropView` to be used in the SwiftUI hierarchy.
    public func makeUIView(context: Context) -> UIBackdropView {
        UIBackdropView()
    }
    
    /// Updates the state of the `UIBackdropView` with new information from SwiftUI.
    ///
    /// - Parameters:
    ///   - uiView: The `UIBackdropView` instance to update.
    ///   - context: The context object containing information about the current state of the view.
    public func updateUIView(_ uiView: UIBackdropView, context: Context) {}
}

/// A SwiftUI view that applies a blur effect over a `Backdrop` layer.
///
/// `Blur` is a convenient SwiftUI view that combines the `Backdrop` with SwiftUI's `.blur` modifier to add a Gaussian blur effect.
/// You can customize the blur's intensity (radius) and specify whether the blur should be opaque.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Blur(radius: 10, opaque: true)
///             .frame(width: 300, height: 300)
///     }
/// }
/// ```
///
/// - Parameters:
///   - radius: The intensity of the blur effect. Defaults to `3`.
///   - opaque: A Boolean value indicating whether the blur effect should be opaque. Defaults to `false`.
///
/// - Note: The blur effect is applied over a backdrop, which mimics system-wide effects, like those used in control centers or navigation bars.
@available(iOS 18.0, macOS 15.0, *)
public struct Blur: View {
    
    /// The radius of the blur effect. A larger value results in a stronger blur.
    var radius: CGFloat = 3
    
    /// A Boolean value that indicates whether the blur effect is opaque.
    var opaque: Bool = false
    
    /// The content and behavior of the `Blur` view.
    ///
    /// The body creates a `Backdrop` and applies the blur effect using the specified parameters.
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
    }
}

/// A SwiftUI view that combines blur and saturation effects over a `Backdrop`.
///
/// `SaturationBlur` adds flexibility by applying both a blur and saturation adjustment,
/// allowing you to create vivid or desaturated blur effects.
///

/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         SaturationBlur(radius: 5, saturation: 0.8)
///             .frame(width: 300, height: 300)
///     }
/// }
/// ```
///
/// - Parameters:
///   - radius: The intensity of the blur effect.
///   - saturation: The level of color saturation, where `1.0` is normal.
///
@available(iOS 18.0, macOS 15.0, *)
public struct SaturationBlur: View {
    
    var radius: CGFloat = 3
    var opaque: Bool = false
    var saturation: Double = 1.0
    
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
            .saturation(saturation)
    }
}

/// A SwiftUI view that applies a customizable blur effect with rounded corners.
///
/// `RoundedBackdrop` allows for applying a blur effect along with a `RoundedRectangle` shape
/// to achieve rounded corners for a blurred region.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         RoundedBackdrop(radius: 10, cornerRadius: 20)
///             .frame(width: 200, height: 200)
///     }
/// }
/// ```
///
/// - Parameters:
///   - radius: The intensity of the blur.
///   - cornerRadius: The radius of the corners to round.
///
@available(iOS 18.0, macOS 15.0, *)
public struct RoundedBackdrop: View {
    
    var radius: CGFloat = 3
    var cornerRadius: CGFloat = 12
    var opaque: Bool = false
    
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

/// A SwiftUI view that applies a blur effect and shadow over a `Backdrop`.
///
/// `ShadowedBackdrop` applies a blur combined with a shadow to give depth to your UI.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         ShadowedBackdrop(radius: 10, shadowColor: .black, shadowRadius: 10)
///             .frame(width: 300, height: 300)
///     }
/// }
/// ```
///
/// - Parameters:
///   - radius: The blur radius.
///   - shadowColor: The color of the shadow.
///   - shadowRadius: The intensity of the shadow.
///
@available(iOS 18.0, macOS 15.0, *)
public struct ShadowedBackdrop: View {
    
    var radius: CGFloat = 3
    var opaque: Bool = false
    var shadowColor: Color = .black
    var shadowRadius: CGFloat = 10
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 5
    
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
            .shadow(
                color: shadowColor.opacity(0.3),
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
    }
}

/// A SwiftUI view that applies a gradient overlay on top of a blur effect.
///
/// `GradientBackdrop` adds a linear gradient on top of the backdrop blur,
/// allowing you to create a colorful visual effect.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         GradientBackdrop(radius: 10, gradientColors: [.red, .blue])
///             .frame(width: 300, height: 300)
///     }
/// }
/// ```
///
/// - Parameters:
///   - radius: The blur radius.
///   - gradientColors: An array of `Color` to create the gradient.
///
@available(iOS 18.0, macOS 15.0, *)
public struct GradientBackdrop: View {
    
    var radius: CGFloat = 3
    var opaque: Bool = false
    var gradientColors: [Color] = [.blue, .purple, .pink]
    
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(0.5)
            )
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct ScalableBackdrop: View {
    
    var radius: CGFloat = 3
    var scale: CGFloat = 1.0
    var opaque: Bool = false
    
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
            .scaleEffect(scale)
            .animation(.easeInOut(duration: 0.3), value: scale)
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct MotionBlur: View {
    var radius: CGFloat = 5
    var direction: Angle = .degrees(0)
    var opaque: Bool = false
    
    public var body: some View {
        Backdrop()
            .rotationEffect(direction)
            .blur(radius: radius, opaque: opaque)
    }
    
    /// Modifier to adjust the blur radius
    public func blurRadius(_ radius: CGFloat) -> MotionBlur {
        var blur = self
        blur.radius = radius
        return blur
    }
    
    /// Modifier to adjust the direction of the blur
    public func blurDirection(_ direction: Angle) -> MotionBlur {
        var blur = self
        blur.direction = direction
        return blur
    }
    
    /// Modifier to adjust opacity
    public func blurOpaque(_ opaque: Bool) -> MotionBlur {
        var blur = self
        blur.opaque = opaque
        return blur
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct BoxBlur: View {
    
    var radius: CGFloat = 8
    var opaque: Bool = false
    
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
            .mask(Rectangle().padding(-radius))
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct BokehBlur: View {
    var radius: CGFloat = 15
    var bokehStrength: CGFloat = 0.8
    var opaque: Bool = false
    
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
            .brightness(bokehStrength)
            .overlay(
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .scaleEffect(bokehStrength)
            )
    }
    
    /// Modifier to adjust the Bokeh strength
    public func bokehStrength(_ strength: CGFloat) -> BokehBlur {
        var blur = self
        blur.bokehStrength = strength
        return blur
    }
    
    /// Modifier to adjust the blur radius
    public func blurRadius(_ radius: CGFloat) -> BokehBlur {
        var blur = self
        blur.radius = radius
        return blur
    }
    
    /// Modifier to adjust opacity
    public func blurOpaque(_ opaque: Bool) -> BokehBlur {
        var blur = self
        blur.opaque = opaque
        return blur
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct TiltShiftBlur: View {
    var radius: CGFloat = 10
    var focalPoint: UnitPoint = .center
    var opaque: Bool = false
    
    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.5),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    /// Modifier to adjust the blur radius
    public func blurRadius(_ radius: CGFloat) -> TiltShiftBlur {
        var blur = self
        blur.radius = radius
        return blur
    }
    
    /// Modifier to adjust the focal point
    public func focalPoint(_ point: UnitPoint) -> TiltShiftBlur {
        var blur = self
        blur.focalPoint = point
        return blur
    }
    
    /// Modifier to adjust opacity
    public func blurOpaque(_ opaque: Bool) -> TiltShiftBlur {
        var blur = self
        blur.opaque = opaque
        return blur
    }
}
