//
//  Process+Launch.swift
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
import ObjectiveC

#if os(macOS)
@available(macOS 15.0, *)
public extension Process {
    
    /// An enumeration representing errors that can occur during process execution.
    ///
    /// This enum is used to categorize different types of errors that may arise when launching or
    /// interacting with a process. It provides specific error cases for process exit statuses, signals,
    /// IO errors, and invalid process states.
    enum LaunchError: Swift.Error {
        case exit(Int32)
        case signal(Int32)
        case ioError(Int32)
        case invalidProcessState
        
        /// Initializes a `LaunchError` based on the termination status of a process.
        ///
        /// - Parameter process: The `Process` instance whose termination status is evaluated.
        /// - Returns: An optional `LaunchError` if the termination status indicates an error; otherwise, `nil`.
        init?(terminationOf process: Process) {
            switch process.terminationReason {
            case .exit where process.terminationStatus != 0:
                self = .exit(process.terminationStatus)
            case .uncaughtSignal:
                self = .signal(process.terminationStatus)
            default:
                return nil
            }
        }
    }
    
    /// Launches a process and allows for asynchronous interaction with its standard input, output, and error streams.
    ///
    /// - Parameters:
    ///   - queue: An optional `DispatchQueue` for scheduling IO operations.
    ///   - reportInterval: An optional `DispatchTimeInterval` specifying the maximum interval for
    ///                     reporting output. If set, `stdout` and `stderr` streams will yield empty
    ///                     elements at this interval even if no data is available.
    ///   - build: A closure that defines the interaction with the process. This closure provides async functions
    ///            for writing to the process's standard input and reading from its standard output and error streams.
    /// - Returns: The result of the `build` operation.
    ///
    /// # Example #
    /// Simplified usage:
    /// ```
    /// let output: AsyncThrowingOutputStream<Data, any Error> = try await process.launch()
    /// ```
    /// Extended usage:
    /// ```
    /// try await process.launch(reportInterval: .seconds(1)) { input, output, error in
    ///     try await input(Data()) // Write arbitrary data to process input
    ///     for try await data in output { /* Handle process output */ }
    ///     for try await data in error { /* Handle process error */ }
    ///     // Process input is closed at this point. `output` and `error` streams may still have data.
    /// }
    /// ```
    func launch<R>(
        queue target: DispatchQueue? = nil,
        reportInterval: DispatchTimeInterval? = nil,
        build: (
            (Data) async throws -> Void,          // stdin
            AsyncThrowingStream<Data, any Error>, // stdout
            AsyncThrowingStream<Data, any Error>  // stderr
        ) async throws -> R = { _, o, _ in o }
    ) async throws -> R {
        let process: Process = self
        
        guard !process.isRunning && process.processIdentifier == 0 else { throw LaunchError.invalidProcessState }
        
        let group = DispatchGroup()
        let inputPipe = Pipe(), outputPipe = Pipe(), errorPipe = Pipe()
        let queue = DispatchQueue(label: "IO for \(process)", target: target)
        
        process.standardInput = inputPipe
        process.standardOutput = outputPipe
        
        group.enter()
        process.terminationHandler = { _ in
            group.leave()
        }
        
        group.enter()
        let stdinIO = DispatchIO(
            type: .stream,
            fileDescriptor: inputPipe.fileHandleForWriting.fileDescriptor,
            queue: queue
        ) { [inputPipe] _ in
            try? inputPipe.fileHandleForWriting.close()
            group.leave()
        }
        defer { stdinIO.close() }
        
        group.enter()
        let stdoutIO = DispatchIO(
            type: .stream,
            fileDescriptor: outputPipe.fileHandleForReading.fileDescriptor,
            queue: queue
        ) { _ in
            try! outputPipe.fileHandleForReading.close()
            group.leave()
        }
        if let reportInterval {
            stdoutIO.setInterval(interval: reportInterval, flags: [.strictInterval])
        }
        
        group.enter()
        let stderrIO = DispatchIO(
            type: .stream,
            fileDescriptor: errorPipe.fileHandleForReading.fileDescriptor,
            queue: queue
        ) { _ in
            try! errorPipe.fileHandleForReading.close()
            group.leave()
        }
        if let reportInterval {
            stderrIO.setInterval(interval: reportInterval, flags: [.strictInterval])
        }
        
        let input: (Data) async throws -> Void = { data in
            try await withCheckedThrowingContinuation { continuation in
                stdinIO.write(offset: 0, data: data.dispatchData, queue: queue) { isDone, _, error in
                    if error != 0 {
                        continuation.resume(throwing: LaunchError.ioError(error))
                    } else if isDone {
                        continuation.resume()
                    }
                }
            }
        }
        
        let output = AsyncThrowingStream<Data, any Swift.Error> { upstream in
            group.notify(queue: queue) {
                upstream.finish(throwing: LaunchError(terminationOf: process))
            }
            
            stdoutIO.read(offset: 0, length: .max, queue: .global()) { isDone, data, error in
                if let data {
                    upstream.yield(.init(dispatchData: data))
                }
                if error != 0 {
                    upstream.finish(throwing: LaunchError.ioError(error))
                }
                if isDone {
                    stdoutIO.close()
                }
            }
        }
        
        let error = AsyncThrowingStream<Data, any Swift.Error> { upstream in
            group.notify(queue: queue) {
                upstream.finish(throwing: LaunchError(terminationOf: process))
            }
            
            stderrIO.read(offset: 0, length: .max, queue: .global()) { isDone, data, error in
                if let data {
                    upstream.yield(.init(dispatchData: data))
                }
                if error != 0 {
                    upstream.finish(throwing: LaunchError.ioError(error))
                }
                if isDone {
                    stderrIO.close()
                }
            }
        }
        try process.run()
        
        return try await build(input, output, error)
    }
}

@available(macOS 15.0, *)
private extension Data {
    
    /// Converts a `Data` object to `DispatchData`.
    ///
    /// This conversion allows `Data` to be used with `DispatchIO`, which requires `DispatchData` for
    /// input/output operations.
    ///
    /// - Returns: A `DispatchData` representation of the `Data` object.
    var dispatchData: DispatchData {
        self as NSObject as? DispatchData ?? self.withUnsafeBytes(DispatchData.init(bytes:))
    }
    
    /// Initializes a `Data` object from `DispatchData`.
    ///
    /// - Parameter dispatchData: The `DispatchData` to convert into a `Data` object.
    init(dispatchData: DispatchData) {
        if let nsdata = dispatchData as NSObject as? NSData {
            self.init(referencing: nsdata)
        } else {
            self.init()
            for region in dispatchData.regions {
                self.append(contentsOf: region)
                region.withUnsafeBytes { buffer in
                    guard let ptr = buffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
                    self.append(ptr, count: buffer.count)
                }
            }
        }
    }
}
#endif
