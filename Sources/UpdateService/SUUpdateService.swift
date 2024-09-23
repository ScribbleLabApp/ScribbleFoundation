//
//  SUUpdateService.swift
//  UpdateService
//
//  Copyright (c) 2024 ScribbleLabApp LLC. All rights reserved
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this
//     list of conditions and the following disclaimer in the documentation
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

import SwiftUI
import Foundation

/// `SUUpdateService` is a singleton class responsible for managing software updates
/// for the ScribbleLabApp. It fetches release information from GitHub and provides
/// details about available updates.
@available(iOS 18.0, macOS 15.0, *) @MainActor
public final class SUUpdateService: ObservableObject {
    public static let shared = SUUpdateService()
    
    public init() {
        latestRelease = nil
        isUpdateAvailable = false
    }
    
    /// The GitHub repository name in the format "`<username>/<repository>`".
    let repository = "ScribbleLabApp/ScribbleLab"
    
    /// Holds the latest release fetched from GitHub.
    private var latestRelease: SUGitHubRelease?
    
    /// A published property that indicates whether an update is available.
    /// - Note: It will be updated when `checkForUpdates(channel:)` is called and
    ///   a new release is detected.
    @Published public var isUpdateAvailable: Bool = false
    
    /// Fetches release information from the GitHub repository for the given update channel.
    ///
    /// - Parameters:
    ///   - channel: The update channel to check (`.stable` or `.pre_release`).
    ///   - completion: A closure that gets called with the result of the release fetch.
    ///     It returns either a `SUGitHubRelease` on success or an `SUError` on failure.
    ///
    /// - Throws:
    ///   - `SUError.kUnknownUpdateChannel` if an unknown update channel is provided.
    ///   - `SUError.kNetworkError` if there is an error in the network request.
    ///   - `SUError.kParsingError` if the fetched release information cannot be parsed.
    ///   - `SUError.kApiError` if there is an API error from GitHub.
    ///
    /// ```swift
    /// try await updateService.fetchReleases(channel: .stable) { result in
    ///     switch result {
    ///     case .success(let release):
    ///         print("Fetched release: \(release)")
    ///     case .failure(let error):
    ///         print("Failed to fetch release: \(error)")
    ///     }
    /// }
    /// ```
    public func fetchReleases(
        channel: SUChannel,
        completion: @Sendable @escaping (Result<SUGitHubRelease, SUError>) -> Void
    ) async throws {
        
        let url: URL
        
        if channel == .stable {
            url = URL(string: "https://api.github.com/repos/\(repository)/releases/latest")!
            suLogger.log("SU: Fetching releases from channel 'stable'")
        } else if channel == .pre_release {
            url = URL(string: "https://api.github.com/repos/\(repository)/releases")!
            suLogger.log("SU: Fetching releases from channel 'pre-release'")
        } else {
            suLogger.error("SU_ERR: Unknown Update Channel -880 UUCH")
            throw SUError.kUnknownUpdateChannel(code: -880)
        }
        
        // Create a URL session data task to fetch release information
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.kNetworkError(code: -820)))
                
                suLogger.error("A network error occurred: \(error.localizedDescription) - code: -820")
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(
                    .failure(
                        .kInvalidResponseFormat(
                            code: -836,
                            message: "\(String(describing: error?.localizedDescription))"
                        )
                    )
                )
                
                suLogger.error("No valid HTTP response - error code: -836")
                
                return
            }
            
            guard let data = data else {
                completion(
                    .failure(
                        .kInternalError(
                            code: -898,
                            message: "\(String(describing: error?.localizedDescription))")
                    )
                )
                
                suLogger.error("No data received from API - error code: -898")
                
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let release = try JSONDecoder().decode(
                        SUGitHubRelease.self,
                        from: data
                    )
                    
                    DispatchQueue.main.async {
                        self.latestRelease = release
                        self.isUpdateAvailable = true
                        
                        suLogger.log("SU: New update Available")
                        
                        completion(.success(release))
                    }
                } catch {
                    completion(.failure(.kParsingError(code: -835)))
                    
                    suLogger.error("Parsing error: \(error.localizedDescription) - code: -835")
                }
                
            case 404:
                completion(
                    .failure(
                        .kApiError(
                            code: -839,
                            httpsStatusCode: 404,
                            message: "\(String(describing: error?.localizedDescription))")
                    )
                )
                
                suLogger.error("No releases found - HTTP 404 / error code: -839")
                
            case 403:
                completion(
                    .failure(
                        .kPermissionDenied(
                            code: -1001,
                            message: "User not eligible for update"
                        )
                    )
                )
                
                suLogger.error("Access denied - HTTP 403 / error code: -1001")
                
            default:
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                completion(
                    .failure(
                        .kApiError(
                            httpsStatusCode: httpResponse.statusCode,
                            message: errorMessage
                        )
                    )
                )
                
                suLogger.error("API error: \(errorMessage) - HTTP \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
    
    /// Checks if a new update is available for the given update channel.
    ///
    /// - Parameter channel: The update channel to check (`.stable` or `.pre_release`).
    /// - Throws:
    ///   - `SUError.kInternalError` if fetching the release or comparing versions fails.
    ///   - Any other `SUError` thrown by `fetchReleases(channel:completion:)`.
    ///
    /// ```swift
    /// do {
    ///     try await updateService.checkForUpdates(channel: .stable)
    ///     if updateService.isUpdateAvailable {
    ///         print("New update is available!")
    ///     }
    /// } catch {
    ///     print("Error checking for updates: \(error)")
    /// }
    /// ```
    public func checkForUpdates(channel: SUChannel) async throws {
        try await fetchReleases(channel: channel) { result in
            switch result {
            case .success(let latestRelease):
                let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                
                if latestRelease.tagName > currentVersion {
                    DispatchQueue.main.async {
                        self.isUpdateAvailable = true
                        print("SU: New Update available - isUpdateAvailable is set to true")
                    }
                }
            case .failure(let failure):
                suLogger.error("Failed to fetch releases: \(failure.localizedDescription) (-898 SUINTR)")
                
                // You can also throw a new error, but not from within the closure
                // throw SUError.kInternalError(code: -898, message: "Failed to fetch releases")
            }
        }
    }
}
