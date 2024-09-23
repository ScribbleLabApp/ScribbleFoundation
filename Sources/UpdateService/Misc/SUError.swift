//
//  SUError.swift
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
public enum SUError: Error {
    case kInvalidDMGFile(code: Int = -800)
    case kMountingFailed(code: Int = -801)
    case kNoMountedVolume(code: Int = -802)
    case kApplicationNotFoundInDMG(code: Int = -803)
    
    case kApplicationInstallationFailed(code: Int = -810)
    case kApplicationRemovalFailed(code: Int = -811)
    case kApplicationMoveFailed(code: Int = -812)
    
    case kNetworkError(code: Int = -820)
    case kPoorNetworkConnection(code: Int = -821)
    case kNetworkConnectionLost(code: Int = -825)
    
    case kTimeoutError(code: Int = -831, timeoutInterval: Double)
    case kParsingError(code: Int = -835)
    case kInvalidResponseFormat(code: Int = -836, message: String?)
    case kApiError(code: Int = -839, httpsStatusCode: Int, message: String?)
    
    case kFileNotFound(code: Int = -840, filePath: String?)
    
    case kDatabaseConnectionFailed(code: Int = -850)
    case kAuthenticationFailed(code: Int = -853, message: String?)
    case kInvalidCredentials(code: Int = -856)
    
    case kResourceUnavailable(code: Int = -870, resourceName: String?)
    
    case kUnknownUpdateChannel(code: Int = -880)
    
    case kInternalError(code: Int = -898, message: String?)
    case kUnknownError(code: Int = -899, message: String?)
    
    case kUserNotEligible(code: Int = -1000, message: String?)
    case kPermissionDenied(code: Int = -1001, message: String?)
}
