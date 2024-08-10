//
//  Atomics+Extension.swift
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

import Atomics
import Foundation

@available(iOS 18.0, macOS 15.0, *)
public extension ManagedAtomic where Value: Numeric {
    
    /// Atomically increments the current value by 1.
    ///
    /// This method repeatedly attempts to increment the value of the `ManagedAtomic` instance by 1,
    /// using a compare-and-exchange operation to ensure atomicity and prevent race conditions.
    ///
    /// The increment operation will continue until it successfully updates the value without encountering
    /// any conflicts with other concurrent updates.
    func increment() {
        while true {
            let currentValue = self.load(ordering: .sequentiallyConsistent)
            let newValue = currentValue + 1
            if self.compareExchange(expected: currentValue, desired: newValue, ordering: .sequentiallyConsistent).exchanged {
                break
            }
        }
    }
    
    /// Atomically decrements the current value by 1.
    ///
    /// This method repeatedly attempts to decrement the value of the `ManagedAtomic` instance by 1,
    /// using a compare-and-exchange operation to ensure atomicity and prevent race conditions.
    ///
    /// The decrement operation will continue until it successfully updates the value without encountering
    /// any conflicts with other concurrent updates.
    func decrement() {
        while true {
            let currentValue = self.load(ordering: .sequentiallyConsistent)
            let newValue = currentValue - 1
            if self.compareExchange(expected: currentValue, desired: newValue, ordering: .sequentiallyConsistent).exchanged {
                break
            }
        }
    }
    
    /// Atomically adds a specified value to the current value.
    ///
    /// This method repeatedly attempts to add the given value to the `ManagedAtomic` instance's current value,
    /// using a compare-and-exchange operation to ensure atomicity and prevent race conditions.
    ///
    /// The addition operation will continue until it successfully updates the value without encountering
    /// any conflicts with other concurrent updates.
    ///
    /// - Parameter value: The value to add to the current value.
    func add(_ value: Value) {
        while true {
            let currentValue = self.load(ordering: .sequentiallyConsistent)
            let newValue = currentValue + value
            if self.compareExchange(expected: currentValue, desired: newValue, ordering: .sequentiallyConsistent).exchanged {
                break
            }
        }
    }
    
    /// Atomically subtracts a specified value from the current value.
    ///
    /// This method repeatedly attempts to subtract the given value from the `ManagedAtomic` instance's current value,
    /// using a compare-and-exchange operation to ensure atomicity and prevent race conditions.
    ///
    /// The subtraction operation will continue until it successfully updates the value without encountering
    /// any conflicts with other concurrent updates.
    ///
    /// - Parameter value: The value to subtract from the current value.
    func subtract(_ value: Value) {
        while true {
            let currentValue = self.load(ordering: .sequentiallyConsistent)
            let newValue = currentValue - value
            if self.compareExchange(expected: currentValue, desired: newValue, ordering: .sequentiallyConsistent).exchanged {
                break
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public extension ManagedAtomic where Value: Sendable {
    
    /// Asynchronously applies a transformation function to the current value.
    ///
    /// This method uses a detached task to apply a specified transformation function to the `ManagedAtomic`
    /// instance's current value. The transformation is applied atomically to ensure that concurrent updates
    /// are handled correctly.
    ///
    /// The function will be retried until the transformation is successfully applied without conflicts.
    ///
    /// - Parameter mutate: A sendable closure that takes the current value and returns a new value.
    /// - Note: The closure should be `@Sendable` to ensure it can be safely used in asynchronous tasks.
    func asyncMutate(_ mutate: @Sendable @escaping (Value) -> Value) async {
        await withCheckedContinuation { continuation in
            Task.detached(priority: .medium) {
                while true {
                    let currentValue = self.load(ordering: .sequentiallyConsistent)
                    let newValue = mutate(currentValue)
                    
                    let result = self.compareExchange(expected: currentValue, desired: newValue, ordering: .sequentiallyConsistent)
                    
                    if result.exchanged {
                        continuation.resume()
                        break
                    }
                }
            }
        }
    }
}
