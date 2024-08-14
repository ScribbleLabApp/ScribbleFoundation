//
//  File.swift
//  ScribbleFoundation
//
//  Created by Nevio Hirani on 14.08.24.
//

import Foundation
import LocalAuthentication

public protocol SFLA {
    /// Typealias for biometric authentication completion handler
    typealias BiometricUnlockCompletion = (Bool, Error?) -> Void
    
    /// Performs biometric authentication using Face ID/Touch ID or any other available biometric method.
    ///
    /// - Parameters:
    ///    - completion: A closure indicating the result of the authentication.
    ///      The closure has two parameters:
    ///        - success: A Boolean value indicating whether the authentication was successful.
    ///        - error: An optional `Error` object containing details in case of failure.
    ///
    func unlockWithBiometrics(completion: @escaping BiometricUnlockCompletion)
}
