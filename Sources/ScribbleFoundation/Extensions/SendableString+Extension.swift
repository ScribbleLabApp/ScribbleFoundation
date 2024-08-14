//
//  SendableString+Extension.swift
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
public extension SendableString {
    
    /// Appends a string to the current string asynchronously.
    ///
    /// This method modifies the current string by appending the provided string to it.
    ///
    /// - Parameter string: The string to append to the current string.
    func append(_ string: String) async throws {
        do {
            try await asyncMutate { current in
                current + string
            }
        } catch {
            throw SendableError.append
        }
    }
    
    /// Prepends a string to the current string asynchronously.
    ///
    /// This method modifies the current string by prepending the provided string to it.
    ///
    /// - Parameter string: The string to prepend to the current string.
    func prepend(_ string: String) async throws {
        do {
            try await asyncMutate { current in
                string + current
            }
        } catch {
            throw SendableError.prepend
        }
    }
    
    /// Replaces occurrences of a target string with a replacement string asynchronously.
    ///
    /// This method modifies the current string by replacing all occurrences of the target string with the replacement string.
    ///
    /// - Parameters:
    ///   - target: The substring to replace.
    ///   - replacement: The string to replace the target with.
    func replace(_ target: String, with replacement: String) async throws {
        do {
            try await asyncMutate { current in
                current.replacingOccurrences(of: target, with: replacement)
            }
        } catch {
            throw SendableError.replace
        }
    }
    
    /// Trims whitespace and newline characters from the current string asynchronously.
    ///
    /// This method modifies the current string by removing leading and trailing whitespace and newline characters.
    func trim() async throws {
        do {
            try await asyncMutate { current in
                current.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            throw SendableError.trim
        }
    }
    
    enum SendableError: Error {
        case append
        case prepend
        case replace
        case trim
    }
}
