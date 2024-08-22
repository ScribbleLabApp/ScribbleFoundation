# ``ScribbleFoundation``

A Powerful Foundation for ScribbleLab

@Metadata {
    @PageImage(
        purpose: icon,
        source: "ScribbleFoundation", 
        alt: "A technology icon representing the ScribbleFoundation framework.")
    @PageColor(blue)
    
    @Available(iOS, introduced: "18.0")
    @Available(iPadOS, introduced: "18.0")
    @Available(macOS, introduced: "15.0")
    @Available(visionOS, introduced: "2.0")
    
    @Available(Swift, introduced: "6")
    
    @SupportedLanguage(swift)
}

## Overview

ScribbleFoundation is a Swift library designed to provide a set of foundational utilities and protocols for iOS and macOS applications. It includes various components such as rate limiting, auditing, validation, and more, aimed at improving code organization, consistency, and functionality.

The ScribbleFoundation library offers a suite of protocols and utilities to help manage common tasks in software development. It includes protocols for rate limiting operations, auditing actions, validating data, and other essential functionalities that can be reused across different projects.

## Topics

### Essentials

### Availability

- <doc:Availability>
- <doc:FeatureAvailabilityChecker>
- <doc:featureAvailability>
- <doc:FeatureAvailability>
- <doc:AvailabilityConditionBuilder>
- <doc:SCRDeviceType>
- <doc:getCurrentDeviceType()>

### Analytics & Logging

- <doc:Analytics>
- <doc:AnalyticsLogger>
- <doc:SCRLog>

### Algebra 

- <doc:EigenvalueDecomposition>
- <doc:LUDecomposition>
- <doc:QRDecomposition>
- <doc:SingularValueDecomposition>

### Core Protocols

- <doc:Authenticatable>
- <doc:Cacheable>
- <doc:Cancellable>
- <doc:Configurable>
- <doc:Comparable>
- <doc:Trackable>
- <doc:Transformable>

### Complex

- <doc:Complex>
- <doc:Math>
- <doc:Math/Numeric>
- <doc:Math/besselJ(n:x:)>
- <doc:Math/erf(_:)>
- <doc:Math/gamma(_:)>
- <doc:Math/gamma(_:_:)>
- <doc:Math/legendreP(n:x:)>

### Validation & Formatting

- <doc:Validation>
- <doc:Validatable>
- <doc:DateFormatterManager>

### Auditing

- <doc:Auditable>
- <doc:AuditEntry>
- <doc:AuditLevel>

### Rate Limitation

- <doc:Limitable>
- <doc:RateLimitConfiguration>
- <doc:RateLimitStatus>
- <doc:RateLimitEventType>

### Random

- <doc:Random>
- <doc:Random/MersenneTwister>
- <doc:Random/MarkovChain>
- <doc:Random/generateNumber(lowerBound:upperBound:)>

### Networking

- <doc:Networking>
- <doc:NetworkRequestable>
- <doc:Endpoint>
- <doc:APIEndpoint>
- <doc:SCRNetworkingMonitor>
- <doc:SCRURLSessionNetworkService>

### Numeric

- <doc:UInt9>
- <doc:UInt19>

### Data Handling

- <doc:Serializable>
- <doc:Serialization>
- <doc:SerializableError>
- <doc:UserDefaultsManager>

### Observation & Notifications

- <doc:Observer>
- <doc:Observable>
- <doc:NotificationCenterManager>

### Image Handling

- <doc:ImageLoader>

### Retry & Exception Handling

- <doc:Retryable>
- <doc:ExceptionHandling>

### Extensions

- <doc:Atomics>
- <doc:SwiftUICore>

### Sendable

- <doc:SendableString>
