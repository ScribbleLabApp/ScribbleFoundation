//
//  EigenvalueDecomposition.swift
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
import Accelerate

// swiftlint:disable all

/// Computes the eigenvalues and eigenvectors of a symmetric matrix using the Eigenvalue Decomposition.
///
/// The EigenvalueDecomposition class computes the eigenvalues and eigenvectors of a real symmetric matrix `A`.
/// It decomposes the matrix into the form `A = V * D * V^T`, where `D` is a diagonal matrix containing the
/// eigenvalues and `V` is a matrix whose columns are the corresponding eigenvectors. This decomposition is
/// fundamental in various numerical methods, including solving linear systems, principal component analysis (PCA),
/// and stability analysis of dynamical systems.
///
///    ```swift
///     let matrix = [[5.0, 2.0, 1.0],
///                   [2.0, 3.0, 1.0],
///                   [1.0, 1.0, 4.0]]
///
///     let eigenDecomposition = EigenvalueDecomposition(matrix: matrix)
///
///     print("Eigenvalues: \(eigenDecomposition.eigenvalues)")
///     print("Eigenvectors:")
///
///     for vector in eigenDecomposition.eigenvectors {
///         print(vector)
///     }
///    ```
///
/// The Eigenvalue Decomposition is computed using two main algorithms:
///
/// 1. **Reduction to Tridiagonal Form (`tred2`)**:
///    - Householder reduction to tridiagonal form.
///    - Computes the eigenvalues by transforming the input matrix into a tridiagonal matrix.
///
/// 2. **QL Algorithm with Implicit Shifts (`tql2`)**:
///    - QL algorithm to compute the eigenvectors and refine the eigenvalues.
///    - Uses implicit shifts for improved accuracy and stability.
///
/// Both algorithms work iteratively to converge on accurate eigenvalues and eigenvectors. The resulting
/// eigenvalues are stored in `eigenvalues`, and the corresponding eigenvectors are stored in `eigenvectors`.
///
/// - Important: This implementation assumes that the input matrix A is symmetric.
///
/// - Complexity: O(n^3), where n is the size of the matrix.
@available(iOS 18.0, macOS 15.0, *)
public class EigenvalueDecomposition {
    
    /// The computed eigenvalues of the matrix.
    public var eigenvalues: [Double]
    
    /// The computed eigenvectors of the matrix.
    public var eigenvectors: [[Double]]
    
    /// Initializes the Eigenvalue Decomposition for the given symmetric matrix.
    ///
    /// - Parameter matrix: The symmetric matrix for which eigenvalues and eigenvectors are computed.
    public init(matrix: [[Double]]) {
        let n = matrix.count
        
        self.eigenvalues = [Double](repeating: 0.0, count: n)
        self.eigenvectors = [[Double]](repeating: [Double](repeating: 0.0, count: n), count: n)
        
        var a = matrix
        var z = [[Double]](repeating: [Double](repeating: 0.0, count: n), count: n)
        var d = [Double](repeating: 0.0, count: n)
        var e = [Double](repeating: 0.0, count: n)
        
        tred2(a: &a, n: n, d: &d, e: &e)
        tql2(a: &a, n: n, d: &d, e: &e, z: &z)
        
        self.eigenvalues = d
        self.eigenvectors = z
    }
    
    /// Reduces the input matrix to tridiagonal form using Householder reflections.
    ///
    /// - Parameters:
    ///   - a: The matrix to be decomposed (modified in-place).
    ///   - n: The size of the matrix.
    ///   - d: Output array of diagonal elements of the tridiagonal matrix.
    ///   - e: Output array of off-diagonal elements of the tridiagonal matrix.
    public func tred2(
        a: inout [[Double]],
        n: Int,
        d: inout [Double],
        e: inout [Double]
    ) {
        for i in 0..<n {
            d[i] = a[n-1][i]
        }
        
        for i in stride(from: n-1, through: 1, by: -1) {
            var scale = 0.0
            var h = 0.0
            
            if i > 1 {
                for k in 0..<i {
                    scale += abs(d[k])
                }
                
                if scale == 0.0 {
                    e[i] = d[i-1]
                    
                    for j in 0..<i {
                        d[j] = a[i-1][j]
                        a[i][j] = 0.0
                        a[j][i] = 0.0
                    }
                } else {
                    for k in 0..<i {
                        d[k] /= scale
                        h += d[k] * d[k]
                    }
                    
                    var f = d[i-1]
                    var g = sqrt(h)
                    
                    if f > 0 {
                        g = -g
                    }
                    
                    e[i] = scale * g
                    h -= f * g
                    
                    for j in 0..<i {
                        f = d[j]
                        a[j][i] = f
                        g = e[j] + a[j][j] * f
                        
                        for k in stride(from: j+1, to: i, by: 1) {
                            g += a[k][j] * d[k]
                            e[k] += a[k][j] * g
                        }
                        
                        e[j] = g
                    }
                    
                    f = 0.0
                    
                    for j in 0..<i {
                        e[j] /= h
                        f += e[j] * d[j]
                    }
                    
                    let hh = f / (h + h)
                    
                    for j in 0..<i {
                        e[j] -= hh * d[j]
                    }
                    for j in 0..<i {
                        f = d[j]
                        g = e[j]
                        
                        for k in stride(from: j, to: i, by: 1) {
                            a[k][j] -= (f * e[k] + g * d[k])
                        }
                        
                        d[j] = a[i-1][j]
                        a[i][j] = 0.0
                    }
                }
            } else {
                e[i] = d[i-1]
                d[i-1] = a[i-1][i-1]
                
                for j in 0..<i-1 {
                    d[j] = a[i-1][j]
                    a[i][j] = 0.0
                    a[j][i] = 0.0
                }
            }
            
            d[i] = h
        }
        
        for i in 0..<n-1 {
            a[n-1][i] = a[i][i]
            a[i][i] = 1.0
            
            let h = d[i+1]
            
            if h != 0.0 {
                for k in 0...i {
                    d[k] = a[k][i+1] / h
                }
                
                for j in 0...i {
                    var g = 0.0
                    
                    for k in 0...i {
                        g += a[k][i+1] * a[k][j]
                    }
                    
                    for k in 0...i {
                        a[k][j] -= g * d[k]
                    }
                }
            }
            
            for k in 0...i {
                a[k][i+1] = 0.0
            }
        }
        
        for j in 0..<n {
            d[j] = a[n-1][j]
            a[n-1][j] = 0.0
        }
        
        a[n-1][n-1] = 1.0
        e[0] = 0.0
    }
    
    /// QL algorithm with implicit shifts to compute eigenvalues and eigenvectors.
    ///
    /// - Parameters:
    ///   - a: The tridiagonal matrix obtained from `tred2` (modified in-place).
    ///   - n: The size of the matrix.
    ///   - d: Input array of diagonal elements of the tridiagonal matrix.
    ///   - e: Input array of off-diagonal elements of the tridiagonal matrix.
    ///   - z: Matrix to accumulate transformations (modified in-place).
    private func tql2(
        a: inout [[Double]],
        n: Int,
        d: inout [Double],
        e: inout [Double],
        z: inout [[Double]]
    ) {
        for i in 1..<n {
            e[i-1] = e[i]
        }
        e[n-1] = 0.0
        
        var f = 0.0
        var tst1 = 0.0
        let eps = pow(2.0, -52.0)
        
        for l in 0..<n {
            tst1 = max(tst1, abs(d[l]) + abs(e[l]))
            var m = l
            while m < n {
                if abs(e[m]) <= eps * tst1 {
                    break
                }
                m += 1
            }
            
            if m > l {
                var iter = 0
                repeat {
                    iter += 1

                    var g = d[l]
                    var p = (d[l+1] - g) / (2.0 * e[l])
                    var r = hypot(p, 1.0)
                    if p < 0 {
                        r = -r
                    }
                    d[l] = e[l] / (p + r)
                    d[l+1] = e[l] * (p + r)
                    let dl1 = d[l+1]
                    var h = g - d[l]
                    for i in l+2..<n {
                        d[i] -= h
                    }
                    f += h
                    
                    p = d[m]
                    
                    var c = 1.0
                    var c2 = c
                    var c3 = c
                    let el1 = e[l+1]
                    var s = 0.0
                    var s2 = 0.0
                    
                    for i in stride(from: m-1, through: l, by: -1) {
                        c3 = c2
                        c2 = c
                        s2 = s
                        g = c * e[i]
                        h = c * p
                        r = hypot(p, e[i])
                        e[i+1] = s * r
                        s = e[i] / r
                        c = p / r
                        p = c * d[i] - s * g
                        d[i+1] = h + s * (c * g + s * d[i])
                        
                        for k in 0..<n {
                            h = z[k][i+1]
                            z[k][i+1] = s * z[k][i] + c * h
                            z[k][i] = c * z[k][i] - s * h
                        }
                    }
                    p = -s * s2 * c3 * el1 * e[l] / dl1
                    e[l] = s * p
                    d[l] = c * p
                    
                } while abs(e[l]) > eps * tst1
            }
            d[l] += f
            e[l] = 0.0
        }
        
        for i in 0..<n-1 {
            var k = i
            var p = d[i]
            for j in i+1..<n {
                if d[j] < p {
                    k = j
                    p = d[j]
                }
            }
            if k != i {
                d[k] = d[i]
                d[i] = p
                for j in 0..<n {
                    let tmp = z[j][i]
                    z[j][i] = z[j][k]
                    z[j][k] = tmp
                }
            }
        }
    }
}

// swiftlint:enable all
