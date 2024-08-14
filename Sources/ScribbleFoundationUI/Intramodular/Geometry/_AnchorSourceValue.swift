//
//  File.swift
//  ScribbleFoundation
//
//  Created by Nevio Hirani on 13.08.24.
//

import SwiftUI

@frozen
public enum _AnchorSourceValue: Equatable {
    private enum InitializationError: Error {
        case failedToExtract
    }
    
    case point(CGPoint)
    case unitPoint(UnitPoint)
    case rect(CGRect)
     
    public init<T>(from source: Anchor<T>.Source) throws {
        guard let value = Mirror(reflecting: source)[_ScribbleFoundation_keyPath: "box.value"] else {
            throw InitializationError.failedToExtract
        }
        
        switch value {
        case let value as CGPoint:
            self = .point(value)
        case let value as UnitPoint:
            self = .unitPoint(value)
        case let value as CGRect:
            self = .rect(value)
        default:
            throw InitializationError.failedToExtract
        }
    }
}
