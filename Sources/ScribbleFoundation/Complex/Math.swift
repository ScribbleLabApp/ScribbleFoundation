//
//  Math.swift
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

/// A collection of advanced mathematical functions.
///
/// The `Math` class provides static methods for computing special functions such
/// as the Gamma function, Bessel functions, Legendre polynomials, and others.
@available(iOS 18.0, macOS 15.0, *)
public class Math {
    
    /// Computes the Gamma function for a given value.
    ///
    /// The Gamma function is a generalization of the factorial function to non-integer values. It is defined as:
    ///
    /// Γ(x) = ∫ from 0 to ∞ of t^(x-1) * e^(-t) dt
    ///
    /// - Parameter x: The input value.
    /// - Returns: The value of the Gamma function at `x`.
    ///
    ///   ```swift
    ///   let result = Math.gamma(5.0)
    ///   // result is approximately 24.0
    ///   ```
    public static func gamma(_ x: Double) -> Double {
        let g = 7
        let p: [Double] = [0.99999999999980993,
                           676.5203681218851,
                           -1259.1392167224028,
                           771.32342877765313,
                           -176.61502916214059,
                           12.507343278686905,
                           -0.13857109526572012,
                           9.9843695780195716e-6,
                           1.5056327351493116e-7]
        
        if x < 0.5 {
            return Double.pi / (sin(Double.pi * x) * gamma(1 - x))
        } else {
            let x = x - 1
            var a = p[0]
            let t = x + Double(g) + 0.5
            for i in 1..<p.count {
                a += p[i] / (x + Double(i))
            }
            return sqrt(2 * Double.pi) * pow(t, x + 0.5) * exp(-t) * a
        }
    }
    
    /// Computes the product of two Gamma functions divided by the Gamma function of their sum.
    ///
    /// This is also known as the Beta function.
    ///
    /// - Parameters:
    ///   - x: The first input value.
    ///   - y: The second input value.
    /// - Returns: The value of the computed Beta function.
    ///
    ///   ```swift
    ///   let result = Math.gamma(3.0, 4.0)
    ///   // result is approximately 0.0333
    ///   ```
    public static func gamma(
        _ x: Double,
        _ y: Double
    ) -> Double {
        return gamma(x) * gamma(y) / gamma(x + y)
    }
    
    /// Computes the error function for a given value.
    ///
    /// The error function is defined as:
    ///
    /// erf(x) = (2/√π) ∫ from 0 to x of e^(-t²) dt
    ///
    /// - Parameter x: The input value.
    /// - Returns: The value of the error function at `x`.
    ///
    ///   ```swift
    ///   let result = Math.erf(1.0)
    ///   // result is approximately 0.8427
    ///   ```
    public static func erf(_ x: Double) -> Double {
        // Using the approximation by Abramowitz and Stegun
        let a1 = 0.254829592
        let a2 = -0.284496736
        let a3 = 1.421413741
        let a4 = -1.453152027
        let a5 = 1.061405429
        let p = 0.3275911
        
        let sign = x < 0 ? -1 : 1
        let absX = abs(x)
        let t = 1.0 / (1.0 + p * absX)
        let y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-absX * absX)
        
        return Double(sign) * y
    }
    
    /// Computes the Bessel function of the first kind for a given value.
    ///
    /// The Bessel function of the first kind is a solution to Bessel's differential equation that is finite at the origin (x = 0).
    ///
    /// - Parameters:
    ///   - n: The order of the Bessel function.
    ///   - x: The input value.
    /// - Returns: The value of the Bessel function of the first kind at `x`.
    ///
    ///   ```swift
    ///   let result = Math.besselJ(n: 0, x: 2.5)
    ///   // result is approximately 0.4970
    ///   ```
    public static func besselJ(
        n: Int,
        x: Double
    ) -> Double {
        // Using a series expansion for Bessel functions
        let m = 100
        let sumLimit = 1e-10
        var sum = 0.0
        
        for k in 0...m {
            let term = pow(-1.0, Double(k)) * pow(x / 2, Double(2 * k + n)) / (factorial(k) * factorial(k + n))
            if abs(term) < sumLimit { break }
            sum += term
        }
        
        return sum
    }
    
    /// Computes the Legendre polynomial of a given degree.
    ///
    /// The Legendre polynomials are a sequence of orthogonal polynomials that arise in solving the Legendre differential equation.
    ///
    /// - Parameters:
    ///   - n: The degree of the Legendre polynomial.
    ///   - x: The input value.
    /// - Returns: The value of the Legendre polynomial of degree `n` at `x`.
    ///
    ///   ```swift
    ///   let result = Math.legendreP(n: 3, x: 0.5)
    ///   // result is approximately -0.4375
    ///   ```
    public static func legendreP(
        n: Int,
        x: Double
    ) -> Double {
        if n == 0 {
            return 1.0
        } else if n == 1 {
            return x
        } else {
            return ((2.0 * Double(n) - 1.0) * x * legendreP(n: n - 1, x: x) - (Double(n) - 1.0) * legendreP(n: n - 2, x: x)) / Double(n)
        }
    }
    
    /// Computes the factorial of a given non-negative integer.
    ///
    /// The factorial of a non-negative integer `n` is the product of all positive integers less than or equal to `n`.
    ///
    /// - Parameter n: The input integer.
    /// - Returns: The factorial of `n`.
    ///
    ///   ```swift
    ///   let result = Math.factorial(5)
    ///   // result is 120
    ///   ```
    private static func factorial(_ n: Int) -> Double {
        return n == 0 ? 1.0 : Double(n) * factorial(n - 1)
    }
}
