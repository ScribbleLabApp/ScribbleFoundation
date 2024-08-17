//
//  Complex.swift
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

import Darwin
import Foundation

// swiftlint:disable identifier_name

/// Structure representing a complex number.
@available(iOS 18.0, macOS 15.0, *)
public struct Complex {
    public var real: Double
    public var imaginary: Double
    
    /// Initializes a complex number.
    ///
    /// - Parameters:
    ///   - real: Real part.
    ///   - imaginary: Imaginary part.
    public init(real: Double, imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    
    /// Computes the modulus (magnitude) of the complex number.
    ///
    /// - Returns: The modulus (magnitude).
    public func modulus() -> Double {
        return Foundation.sqrt(real * real + imaginary * imaginary)
    }
    
    /// Computes the phase (argument) of the complex number.
    ///
    /// - Returns: The phase (argument) in radians.
    public func phase() -> Double {
        return atan2(imaginary, real)
    }
    
    /// Adds two complex numbers.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side complex number.
    ///   - rhs: Right-hand side complex number.
    /// - Returns: Result of addition.
    public static func +(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }
    
    /// Subtracts two complex numbers.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side complex number.
    ///   - rhs: Right-hand side complex number.
    /// - Returns: Result of subtraction.
    public static func -(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
    }
    
    /// Multiplies two complex numbers.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side complex number.
    ///   - rhs: Right-hand side complex number.
    /// - Returns: Result of multiplication.
    public static func *(lhs: Complex, rhs: Complex) -> Complex {
        let real = lhs.real * rhs.real - lhs.imaginary * rhs.imaginary
        let imaginary = lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
        return Complex(real: real, imaginary: imaginary)
    }
    
    /// Divides two complex numbers.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side complex number.
    ///   - rhs: Right-hand side complex number (divisor).
    /// - Returns: Result of division.
    public static func /(lhs: Complex, rhs: Complex) -> Complex {
        let denominator = rhs.real * rhs.real + rhs.imaginary * rhs.imaginary
        let real = (lhs.real * rhs.real + lhs.imaginary * rhs.imaginary) / denominator
        let imaginary = (lhs.imaginary * rhs.real - lhs.real * rhs.imaginary) / denominator
        return Complex(real: real, imaginary: imaginary)
    }
    
    /// Computes the exponential of a complex number.
    ///
    /// - Returns: Exponential of the complex number.
    public func exp() -> Complex {
        let expReal = Foundation.exp(real) * Darwin.cos(imaginary)
        let expImaginary = Foundation.exp(real) * Darwin.sin(imaginary)
        return Complex(real: expReal, imaginary: expImaginary)
    }
    
    /// Computes the natural logarithm of a complex number.
    ///
    /// - Returns: Natural logarithm of the complex number.
    public func log() -> Complex {
        let modulus = self.modulus()
        let phase = self.phase()
        return Complex(real: Foundation.log(modulus), imaginary: phase)
    }
    
    /// Computes the sine of a complex number.
    ///
    /// - Returns: Sine of the complex number.
    public func sin() -> Complex {
        let sinReal = Darwin.sin(real) * cosh(imaginary)
        let sinImaginary = Darwin.cos(real) * sinh(imaginary)
        return Complex(real: sinReal, imaginary: sinImaginary)
    }
    
    /// Computes the cosine of a complex number.
    ///
    /// - Returns: Cosine of the complex number.
    public func cos() -> Complex {
        let cosReal = Darwin.cos(real) * cosh(imaginary)
        let cosImaginary = -Darwin.sin(real) * sinh(imaginary)
        return Complex(real: cosReal, imaginary: cosImaginary)
    }
    
    /// Computes the tangent of a complex number.
    ///
    /// - Returns: Tangent of the complex number.
    public func tan() -> Complex {
        let sinPart = self.sin()
        let cosPart = self.cos()
        return sinPart / cosPart
    }
    
    /// Computes the arc sine of a complex number.
    ///
    /// - Returns: Arc sine of the complex number.
    public func asin() -> Complex {
        let i = Complex(real: 0.0, imaginary: 1.0)
        let one = Complex(real: 1.0, imaginary: 0.0)
        let term1 = (i * self) + ((one - (self * self)).sqrt())
        return -i * (term1.log())
    }
    
    /// Computes the arc cosine of a complex number.
    ///
    /// - Returns: Arc cosine of the complex number.
    public func acos() -> Complex {
        let i = Complex(real: 0.0, imaginary: 1.0)
        let one = Complex(real: 1.0, imaginary: 0.0)
        let term1 = self + (i * ((one - (self * self)).sqrt()))
        return -i * (term1.log())
    }
    
    /// Computes the arc tangent of a complex number.
    ///
    /// - Returns: Arc tangent of the complex number.
    public func atan() -> Complex {
        let i = Complex(real: 0.0, imaginary: 1.0)
        let _ = Complex(real: 1.0, imaginary: 0.0)
        let term1 = (i + self) / (i - self)
        return (i / 2.0) * term1.log()
    }
    
    /// Computes the square root of a complex number.
    ///
    /// - Returns: Square root of the complex number.
    public func sqrt() -> Complex {
        let modulus = self.modulus()
        let phase = self.phase() / 2.0
        let real = Foundation.sqrt(modulus) * Darwin.cos(phase)
        let imaginary = Foundation.sqrt(modulus) * Darwin.sin(phase)
        return Complex(real: real, imaginary: imaginary)
    }
    
    /// Computes the square root of a given complex number.
    ///
    /// - Parameter z: The complex number to compute the square root for.
    /// - Returns: Square root of the complex number.
    public static func sqrt(of z: Complex) -> Complex {
        let modulus = z.modulus()
        let phase = z.phase() / 2.0
        let real = Foundation.sqrt(modulus) * Darwin.cos(phase)
        let imaginary = Foundation.sqrt(modulus) * Darwin.sin(phase)
        return Complex(real: real, imaginary: imaginary)
    }
    
    /// Negates a complex number.
    ///
    /// - Parameter operand: The complex number to negate.
    /// - Returns: The negated complex number.
    public static prefix func -(operand: Complex) -> Complex {
        return Complex(real: -operand.real, imaginary: -operand.imaginary)
    }
    
    /// Returns the complex number itself (unary plus operator).
    ///
    /// - Parameter operand: The complex number.
    /// - Returns: The same complex number.
    public static prefix func +(operand: Complex) -> Complex {
        return operand
    }
    
    /// Adds a complex number to another complex number and assigns the result to the left-hand side operand.
    ///
    /// - Parameters:
    ///   - lhs: The complex number to which the addition is applied.
    ///   - rhs: The complex number to add.
    public static func +=(lhs: inout Complex, rhs: Complex) {
        lhs = lhs + rhs
    }

    /// Subtracts a complex number from another complex number and assigns the result to the left-hand side operand.
    ///
    /// - Parameters:
    ///   - lhs: The complex number from which the subtraction is applied.
    ///   - rhs: The complex number to subtract.
    public static func -=(lhs: inout Complex, rhs: Complex) {
        lhs = lhs - rhs
    }
}

/// Scalar multiplication
///
/// - Parameters:
///   - lhs: Left-hand side complex number.
///   - rhs: Scalar value.
/// - Returns: Result of scalar multiplication.
public func *(lhs: Complex, rhs: Double) -> Complex {
    return Complex(real: lhs.real * rhs, imaginary: lhs.imaginary * rhs)
}

/// Scalar division
///
/// - Parameters:
///   - lhs: Left-hand side complex number.
///   - rhs: Scalar value.
/// - Returns: Result of scalar division.
public func /(lhs: Complex, rhs: Double) -> Complex {
    return Complex(real: lhs.real / rhs, imaginary: lhs.imaginary / rhs)
}

// swiftlint:enable identifier_name
