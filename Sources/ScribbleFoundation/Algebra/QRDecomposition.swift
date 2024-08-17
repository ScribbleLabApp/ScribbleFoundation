//
//  QRDecomposition.swift
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

/// Computes the QR decomposition of a matrix.
///
/// The QRDecomposition class computes the QR decomposition of a matrix `A`.
/// The QR decomposition factors the matrix into the product of an orthogonal matrix `Q`
/// and an upper triangular matrix `R`, such that `A = Q * R`. This decomposition
/// is useful in various numerical methods, including solving linear least squares
/// problems and eigenvalue computations.
///
///    ```swift
///    let matrix = [[1.0, -1.0, 4.0],
///                  [3.0, 2.0, 5.0],
///                  [2.0, -3.0, 1.0]]
///
///    let qrDecomposition = QRDecomposition(matrix: matrix)
///
///    print("Orthogonal matrix Q:")
///    for row in qrDecomposition.Q {
///        print(row)
///    }
///
///    print("Upper triangular matrix R:")
///    for row in qrDecomposition.R {
///        print(row)
///    }
///    ```
///
/// The QR decomposition is computed using the Gram-Schmidt process modified to
/// construct an orthogonal matrix `Q` and an upper triangular matrix `R`.
///
/// - Parameters:
///   - matrix: The matrix for which QR decomposition is computed.
@available(iOS 18.0, macOS 15.0, *)
public class QRDecomposition {
    
    /// The orthogonal matrix Q in the QR decomposition.
    public var Q: [[Double]]
    
    /// The upper triangular matrix R in the QR decomposition.
    public var R: [[Double]]
    private let m: Int
    private let n: Int
    
    /// Initializes the QR decomposition for the given matrix.
    ///
    /// - Parameter matrix: The matrix for which QR decomposition is computed.
    public init(matrix: [[Double]]) {
        self.m = matrix.count
        self.n = matrix[0].count
        self.Q = matrix
        self.R = [[Double]](repeating: [Double](repeating: 0.0, count: n), count: n)
        
        for k in 0..<n {
            var norm = 0.0
            for i in 0..<m {
                norm += Q[i][k] * Q[i][k]
            }
            norm = sqrt(norm)
            
            R[k][k] = norm
            for i in 0..<m {
                Q[i][k] /= norm
            }
            
            for j in k+1..<n {
                R[k][j] = 0.0
                for i in 0..<m {
                    R[k][j] += Q[i][k] * matrix[i][j]
                }
                for i in 0..<m {
                    Q[i][j] -= R[k][j] * Q[i][k]
                }
            }
        }
    }
}
