//
//  Random+MarkovChain.swift
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

@available(iOS 18.0, macOS 15.0, *)
public extension Random {
    
    /// A class representing a Markov Chain for simulating state transitions.
    ///
    /// This class simulates a series of state transitions based on a provided transition matrix.
    /// Each state transition is determined probabilistically, according to the transition matrix.
    ///
    /// @Beta
    /// - Note: This class is currently in beta and may change in future releases.
    ///
    /// # Topics
    /// - `nextState()`
    /// - `init(transitionMatrix:initialState:states:)`
    ///
    @available(iOS 18.0, macOS 15.0, *)
    class MarkovChain {
        private var transitionMatrix: [[Double]]
        private var states: [String]
        private var currentState: Int
        
        /// Initializes a new Markov Chain with the given transition matrix, initial state, and state names.
        ///
        /// - Parameters:
        ///   - transitionMatrix: A matrix where `transitionMatrix[i][j]` represents the probability of transitioning
        ///     from state `i` to state `j`.
        ///   - initialState: The index of the initial state.
        ///   - states: An array of state names corresponding to the indices in the transition matrix.
        ///
        /// ```swift
        /// let states = ["Sunny", "Cloudy", "Rainy"]
        /// let transitionMatrix = [
        ///     [0.8, 0.2, 0.0],  // From Sunny to Sunny, Cloudy, Rainy
        ///     [0.3, 0.5, 0.2],  // From Cloudy to Sunny, Cloudy, Rainy
        ///     [0.2, 0.3, 0.5]   // From Rainy to Sunny, Cloudy, Rainy
        /// ]
        /// let markovChain = Random.MarkovChain(transitionMatrix: transitionMatrix,
        ///                                      initialState: 0, states: states)
        /// ```
        public init(transitionMatrix: [[Double]], initialState: Int, states: [String]) {
            self.transitionMatrix = transitionMatrix
            self.currentState = initialState
            self.states = states
        }
        
        /// Advances the Markov Chain to the next state and returns the name of the new state.
        ///
        /// The next state is determined based on the transition probabilities from the current state.
        ///
        /// - Returns: The name of the new state.
        ///
        /// ```swift
        /// let nextState = markovChain.nextState()
        /// print("The next state is: \(nextState)")
        /// ```
        public func nextState() -> String {
            let rng = MersenneTwister(seed: UInt32(time(nil)))
            let randomValue = Double(rng.nextUInt32()) / Double(UInt32.max)
            var cumulativeProbability = 0.0
            
            for (index, probability) in transitionMatrix[currentState].enumerated() {
                cumulativeProbability += probability
                if randomValue < cumulativeProbability {
                    currentState = index
                    break
                }
            }
            
            return states[currentState]
        }
    }
}
