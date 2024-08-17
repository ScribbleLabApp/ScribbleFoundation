//
//  Random+MersenneTwister.swift
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

public extension Random {
    
    /// A high-quality random number generator using the Mersenne Twister algorithm.
    ///
    /// The Mersenne Twister is a pseudorandom number generator (PRNG) known for its long period and
    /// high-quality randomness. This implementation supports seeding and generating random 32-bit unsigned integers.
    ///
    /// - Note: This class is available on iOS 18.0 and later.
    ///
    /// # Topics
    /// - ``MersenneTwister/init(seed:)``
    /// - ``MersenneTwister/seed(_:)``
    /// - ``MersenneTwister/nextUInt32()``
    ///
    @available(iOS 18.0, *)
    class MersenneTwister {
        
        /// The size of the state vector.
        private static let n = 624
        
        /// The period parameter.
        private static let m = 397
        
        /// A constant vector a.
        private static let matrixA: UInt32 = 0x9908b0df
        
        /// Most significant w-r bits.
        private static let upperMask: UInt32 = 0x80000000
        
        /// Least significant r bits.
        private static let lowerMask: UInt32 = 0x7fffffff
        
        /// The state vector.
        private var mt = [UInt32](repeating: 0, count: n)
        
        /// The index for the state vector.
        private var index = n + 1
        
        /// Initializes a new instance of the Mersenne Twister with the given seed.
        ///
        /// This method initializes the Mersenne Twister with a specific seed value, allowing for reproducible
        /// sequences of random numbers.
        ///
        /// - Parameter seed: The initial seed value to initialize the generator.
        ///
        /// ```swift
        /// let rng = Random.MersenneTwister(seed: 54321)
        /// ```
        public init(seed: UInt32) {
            self.seed(seed)
        }
        
        /// Seeds the Mersenne Twister with the given value.
        ///
        /// This method reinitializes the internal state of the Mersenne Twister with a new seed value.
        /// It allows you to start a new sequence of random numbers.
        ///
        /// - Parameter seed: The seed value to initialize the generator.
        ///
        /// ```swift
        /// let rng = Random.MersenneTwister(seed: 12345)
        /// rng.seed(98765) // Resets with a new seed
        /// ```
        public func seed(_ seed: UInt32) {
            mt[0] = seed
            
            for i in 1..<MersenneTwister.n {
                mt[i] = 1812433253 &* (mt[i - 1] ^ (mt[i - 1] >> 30)) &+ UInt32(i)
            }
            
            index = MersenneTwister.n
        }
        
        /// Generates the next random 32-bit unsigned integer.
        ///
        /// This method generates and returns the next pseudorandom number in the sequence.
        ///
        /// - Returns: A pseudorandom 32-bit unsigned integer.
        ///
        /// ```swift
        /// let rng = Random.MersenneTwister(seed: 12345)
        /// let randomValue = rng.nextUInt32()
        /// print(randomValue) // Output will be a random 32-bit unsigned integer
        /// ```
        public func nextUInt32() -> UInt32 {
            if index >= MersenneTwister.n {
                twist()
            }
            
            var y = mt[index]
            y ^= (y >> 11)
            y ^= (y << 7) & 0x9d2c5680
            y ^= (y << 15) & 0xefc60000
            y ^= (y >> 18)
            
            index += 1
            return y
        }
        
        /// Performs the twist transformation to generate new random values.
        ///
        /// This method is called automatically when more random numbers are needed.
        private func twist() {
            let n = MersenneTwister.n
            let m = MersenneTwister.m
            let matrixA = MersenneTwister.matrixA
            let upperMask = MersenneTwister.upperMask
            let lowerMask = MersenneTwister.lowerMask
            
            for i in 0..<n {
                let y = (mt[i] & upperMask) | (mt[(i + 1) % n] & lowerMask)
                mt[i] = mt[(i + m) % n] ^ (y >> 1)
                if y % 2 != 0 {
                    mt[i] ^= matrixA
                }
            }
            index = 0
        }
    }
}
