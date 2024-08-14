//
//  DynamicProperty+.swift
//  ScribbleFoundationUI
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
//     contributors may be used to endorse or promote products derived from this
//     software without specific prior written permission.
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

import Combine
import SwiftUI

/// Creates a SwiftUI view that manages an internal `Bool` state and applies a content view builder with a `Binding<Bool>`.
///
/// This function initializes a view with an internal `Bool` state, providing a `Binding<Bool>` to the specified content view builder.
/// It allows you to easily create views that depend on a boolean state without manually managing the state.
///
/// - Parameters:
///   - type: A `Bool.Type` that indicates the type of the state managed internally. This parameter is used for type inference purposes.
///   - content: A closure that takes a `Binding<Bool>` and returns a view. The `Binding<Bool>` represents the internal
///              boolean state and allows two-way binding to it.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to construct the UI, with a `Binding<Bool>` to the internal state.
///
/// ```swift
/// struct ExampleView: View {
///     var body: some View {
///         withInlineState(Bool.self) { isOn in
///             Toggle("Enable feature", isOn: isOn)
///                 .padding()
///         }
///     }
/// }
/// ```
///
/// In this example, `withInlineState` initializes the internal state as `false` and provides a `Binding<Bool>` to a `Toggle` view.
/// The `Toggle` view updates the internal boolean state when toggled, demonstrating the use of state binding in SwiftUI views.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
@MainActor
public func withInlineState<Content: View>(
    _ type: Bool.Type,
    @ViewBuilder content: @escaping (Binding<Bool>) -> Content
) -> some View {
    WithInlineState(initialValue: false, content: content)
}

/// Creates a SwiftUI view that manages an internal state of type `Value`
/// and applies a content view builder with a `Binding<Value>`.
///
/// This function initializes a view with an internal state of the specified
/// type `Value`, and provides a `Binding<Value>` to the `content` closure.
/// The `content` closure constructs the view using this binding, allowing
/// for reactive and dynamic updates based on state changes.
///
/// - Parameters:
///   - initialValue: The initial value for the state of type `Value`. This
///     value is used to initialize the internal state when the view is created.
///   - content: A closure that takes a `Binding<Value>` and returns a view
///     of type `Content`. The `Binding<Value>` represents the internal state
///     and allows the content view to read and update the state.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to
///   construct the UI, with a `Binding<Value>` to the internal state.
///
/// - Note: The `Value` type must be a type that conforms to `Equatable`.
///
/// ```swift
/// struct CounterView: View {
///     var body: some View {
///         withInlineState(initialValue: 0) { count in
///             VStack {
///                 Text("Count: \(count.wrappedValue)")
///                 Button("Increment") {
///                     count.wrappedValue += 1
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `withInlineState` initializes the internal state with
/// `0` and provides a `Binding<Int>` to the `content` closure. The `Text`
/// view displays the current count, and the `Button` updates the count
/// when pressed, demonstrating how the state binding allows for interactive
/// and reactive UI updates.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
@MainActor
public func withInlineState<Value, Content: View>(
    initialValue: Value,
    @ViewBuilder content: @escaping (Binding<Value>) -> Content
) -> some View {
    WithInlineState(initialValue: initialValue, content: content)
}

/// Creates a SwiftUI view that manages an internal `ObservableObject`
/// and applies a content view builder with the `Object` instance.
///
/// This function initializes a view with the specified `ObservableObject`
/// and provides it to the `content` closure. The `content` closure constructs
/// the view using the provided object, allowing the view to react to changes
/// in the observed object.
///
/// - Parameters:
///   - object: An instance of `Object` that conforms to `ObservableObject`.
///     This object is used to initialize the internal state and is passed
///     directly to the `content` closure.
///
///   - content: A closure that takes an `Object` and returns a view of type
///     `Content`. The `Object` parameter is the instance of the observable
///     object that the view will use, allowing for dynamic updates based on
///     changes to this object.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to
///   construct the UI, with the `Object` instance passed directly to it.
///
/// - Note: The `Object` type must conform to `ObservableObject` to work with
///   this function. The `@_disfavoredOverload` attribute suggests that this
///   overload is less preferred compared to other potential overloads.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var count: Int = 0
/// }
///
/// struct MyView: View {
///     @StateObject private var viewModel = MyViewModel()
///
///     var body: some View {
///         withInlineObservedObject(viewModel) { viewModel in
///             VStack {
///                 Text("Count: \(viewModel.count)")
///                 Button("Increment") {
///                     viewModel.count += 1
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `withInlineObservedObject` initializes the view with an
/// instance of `MyViewModel`. The `content` closure builds a view that displays
/// the current count and provides a button to update it, demonstrating how
/// the view reacts to changes in the `ObservableObject`.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
@_disfavoredOverload
@MainActor
public func withInlineObservedObject<Object: ObservableObject, Content: View>(
    _ object: Object,
    @ViewBuilder content: @escaping (Object) -> Content
) -> some View {
    WithInlineObservedObject(object: object, content: content)
}

/// Creates a SwiftUI view that manages an optional internal `ObservableObject`
/// and applies a content view builder with the `Object?` instance.
///
/// This function initializes a view with an optional `ObservableObject` and
/// provides it to the `content` closure. The `content` closure constructs the
/// view using the provided object, which can be `nil`. This allows the view
/// to handle cases where the object might not be available.
///
/// - Parameters:
///   - object: An optional instance of `Object` that conforms to `ObservableObject`.
///     This object is used to initialize the internal state and is passed directly
///     to the `content` closure. If `nil`, the view will handle the absence of the object.
///
///   - content: A closure that takes an optional `Object?` and returns a view of type
///     `Content`. The `Object?` parameter allows the view to be built based on whether
///     the object is present or `nil`.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to construct
///   the UI, with the optional `Object` instance passed directly to it.
///
/// - Note: The `Object` type must conform to `ObservableObject` to work with this function.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var count: Int = 0
/// }
///
/// struct MyView: View {
///     @StateObject private var viewModel = MyViewModel()
///
///     var body: some View {
///         withInlineObservedObject(viewModel) { viewModel in
///             VStack {
///                 if let viewModel = viewModel {
///                     Text("Count: \(viewModel.count)")
///                     Button("Increment") {
///                         viewModel.count += 1
///                     }
///                 } else {
///                     Text("No view model available.")
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `withInlineObservedObject` initializes the view with an
/// optional `MyViewModel`. The `content` closure builds a view that either
/// displays the current count if the `viewModel` is not `nil`, or shows a
/// message indicating that no view model is available.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
@MainActor
public func withInlineObservedObject<Object: ObservableObject, Content: View>(
    _ object: Object?,
    @ViewBuilder content: @escaping (Object?) -> Content
) -> some View {
    WithOptionalInlineObservedObject(object: object, content: content)
}

/// Creates a SwiftUI view that manages an internal `ObservableObject`
/// by initializing it with a closure and applies a content view builder.
///
/// This function initializes a view with an `ObservableObject` provided by
/// a closure and passes the object to the `content` closure. This setup allows
/// the view to reactively update based on changes to the `ObservableObject`.
///
/// - Parameters:
///   - object: A closure that returns an instance of `Object` conforming to
///     `ObservableObject`. The closure is executed to initialize the internal
///     state of the view with the returned object.
///
///   - content: A closure that takes an `Object` and returns a view of type
///     `Content`. The `Object` parameter is the instance of the observable
///     object that the view will use, allowing the view to respond to changes
///     in the object.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to
///   construct the UI, with the `Object` instance created by the closure.
///
/// - Note: The `Object` type must conform to `ObservableObject` to work with
///   this function. The `@autoclosure` attribute allows the `object` parameter
///   to be provided as a simple expression that will be automatically converted
///   into a closure. The `@_disfavoredOverload` attribute indicates that this
///   overload is less preferred compared to other potential overloads.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var count: Int = 0
/// }
///
/// struct MyView: View {
///     var body: some View {
///         withInlineStateObject(MyViewModel()) { viewModel in
///             VStack {
///                 Text("Count: \(viewModel.count)")
///                 Button("Increment") {
///                     viewModel.count += 1
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `withInlineStateObject` initializes the view with a new
/// instance of `MyViewModel`. The `content` closure builds a view that displays
/// the current count and provides a button to update it, demonstrating how
/// the view reacts to changes in the `ObservableObject`.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
@_disfavoredOverload
@MainActor
public func withInlineStateObject<Object: ObservableObject, Content: View>(
    _ object: @autoclosure @escaping () -> Object,
    @ViewBuilder content: @escaping (Object) -> Content
) -> some View {
    WithInlineStateObject(object: object(), content: content)
}

/// Creates a SwiftUI view that manages an optional internal `ObservableObject`
/// by initializing it with a closure and applies a content view builder.
///
/// This function initializes a view with an optional `ObservableObject` provided
/// by a closure and passes it to the `content` closure. This setup allows the
/// view to handle cases where the object might be `nil`, reacting accordingly.
///
/// - Parameters:
///   - object: A closure that returns an optional instance of `Object` conforming
///     to `ObservableObject`. The closure is executed to initialize the internal
///     state of the view with the returned object or `nil`.
///
///   - content: A closure that takes an optional `Object?` and returns a view of
///     type `Content`. The `Object?` parameter allows the view to be constructed
///     based on whether the object is present or `nil`.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to construct
///   the UI, with the optional `Object` instance created by the closure.
///
/// - Note: The `Object` type must conform to `ObservableObject` to work with this function.
///   The `@autoclosure` attribute allows the `object` parameter to be passed as a simple
///   expression that will be automatically converted into a closure.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var count: Int = 0
/// }
///
/// struct MyView: View {
///     var body: some View {
///         withInlineStateObject(MyViewModel()) { viewModel in
///             VStack {
///                 if let viewModel = viewModel {
///                     Text("Count: \(viewModel.count)")
///                     Button("Increment") {
///                         viewModel.count += 1
///                     }
///                 } else {
///                     Text("No view model available.")
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `withInlineStateObject` initializes the view with an optional
/// `MyViewModel`. The `content` closure builds a view that either displays the
/// current count if the `viewModel` is not `nil`, or shows a message indicating
/// that no view model is available.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
@MainActor
public func withInlineStateObject<Object: ObservableObject, Content: View>(
    _ object: @autoclosure @escaping () -> Object?,
    @ViewBuilder content: @escaping (Object?) -> Content
) -> some View {
    WithInlineOptionalStateObject(object: object(), content: content)
}

/// Creates a SwiftUI view that manages an internal `ObservableObject`
/// by initializing it with a closure and applies a content view builder.
///
/// This function initializes a view with an `ObservableObject` provided by
/// a closure and passes it to the `content` closure wrapped in an `ObservedObject`.
/// This setup allows the view to reactively update based on changes to the
/// `ObservableObject`, which is wrapped and managed internally.
///
/// - Parameters:
///   - object: A closure that returns an instance of `Object` conforming
///     to `ObservableObject`. The closure is executed to initialize the internal
///     state of the view with the returned object.
///
///   - content: A closure that takes an `ObservedObject<Object>` and returns
///     a view of type `Content`. The `ObservedObject` wrapper allows the view
///     to react to changes in the `ObservableObject` and ensures that the view
///     updates accordingly.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to
///   construct the UI, with the `ObservableObject` instance wrapped in an
///   `ObservedObject` and passed to the closure.
///
/// - Note: The `Object` type must conform to `ObservableObject` to work with
///   this function. The `@autoclosure` attribute allows the `object` parameter
///   to be passed as a simple expression that is automatically converted into
///   a closure.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var count: Int = 0
/// }
///
/// struct MyView: View {
///     var body: some View {
///         withInlineStateObject(MyViewModel()) { viewModel in
///             VStack {
///                 Text("Count: \(viewModel.wrappedValue.count)")
///                 Button("Increment") {
///                     viewModel.wrappedValue.count += 1
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `withInlineStateObject` initializes the view with a new
/// instance of `MyViewModel`. The `content` closure builds a view that displays
/// the current count and provides a button to update it. The `ObservableObject`
/// is wrapped in `ObservedObject` to enable reactive updates.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
@MainActor
public func withInlineStateObject<Object: ObservableObject, Content: View>(
    _ object: @autoclosure @escaping () -> Object,
    @ViewBuilder content: @escaping (ObservedObject<Object>) -> Content
) -> some View {
    WithInlineStateObject(object: object(), content: { content(ObservedObject(wrappedValue: $0)) })
}

/// Creates a SwiftUI view that updates at regular intervals using a timer.
///
/// This function initializes a view that maintains a state value updated by a
/// timer. The view will update its state every specified interval, and the
/// content view builder will be called with the current state value.
///
/// - Parameters:
///   - interval: The time interval between updates, in seconds. The timer will
///     fire repeatedly at this interval, updating the internal state value.
///
///   - content: A closure that takes an `Int` representing the current timer
///     value and returns a view of type `Content`. This closure is used to build
///     the view, allowing it to reactively display the current state value.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to construct
///   the UI, with the state value updated periodically based on the timer interval.
///
/// ```swift
/// struct TimerView: View {
///     var body: some View {
///         withInlineTimerState(interval: 1.0) { count in
///             VStack {
///                 Text("Seconds elapsed: \(count)")
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `withInlineTimerState` creates a view that updates every second.
/// The `content` closure builds a view displaying the number of seconds elapsed since
/// the view appeared. The timer fires at the interval specified (1.0 second), and the
/// view updates to reflect the current count.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
@MainActor
public func withInlineTimerState<Content: View>(
    interval: TimeInterval,
    @ViewBuilder content: @escaping (Int) -> Content
) -> some View {
    WithInlineTimerState(interval: interval, content: content)
}

/// A SwiftUI view that maintains an internal state value and uses a content builder.
///
/// `WithInlineState` is a generic view struct that manages an internal state value
/// of type `Value`. It uses the SwiftUI `State` property wrapper to handle the state
/// and provides a `Binding<Value>` to the `content` view builder, allowing the view
/// to reactively update based on changes to the state.
///
/// This struct is useful when you want to encapsulate a stateful view component and
/// pass the state binding to the content view builder for dynamic updates.
///
/// - Parameters:
///   - initialValue: The initial value of the state. This value is used to initialize
///     the internal `State` property.
///
///   - content: A closure that takes a `Binding<Value>` and returns a view of type
///     `Content`. The `Binding<Value>` allows the view to read and write the state
///     value, ensuring that changes are reflected in the UI.
///
/// ```swift
/// struct CounterView: View {
///     var body: some View {
///         WithInlineState(initialValue: 0) { count in
///             VStack {
///                 Text("Count: \(count.wrappedValue)")
///                 Button("Increment") {
///                     count.wrappedValue += 1
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `WithInlineState` is used to create a counter view that displays
/// and updates a count value. The `content` closure builds a view that shows the count
/// and provides a button to increment it. The state is managed internally and updated
/// reactively based on user interactions.
///
/// - Note: `Value` must be a type that conforms to `Equatable` to be used with `State`.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
private struct WithInlineState<Value, Content: View>: View {
    @State private var value: Value
    
    let content: (Binding<Value>) -> Content
    
    /// Initializes a new instance of `WithInlineState` with the given initial value
    /// and content view builder.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value for the state.
    ///   - content: A closure that takes a `Binding<Value>` and returns a view of
    ///     type `Content`.
    init(
        initialValue: Value,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}

/// A SwiftUI view that wraps an `ObservableObject` with an `ObservedObject`
/// and uses a content builder to display its data.
///
/// `WithInlineObservedObject` is a generic view struct designed to simplify
/// the usage of `ObservableObject` within SwiftUI views. It wraps the provided
/// `ObservableObject` in an `ObservedObject` property wrapper, allowing the
/// view to reactively update based on changes to the observed object.
///
/// This struct is particularly useful when you want to manage an `ObservableObject`
/// and pass it directly to a content builder, ensuring that the content view reacts
/// to changes in the object.
///
/// - Parameters:
///   - object: An instance of `Object` that conforms to `ObservableObject`. This
///     object is wrapped in an `ObservedObject` and passed to the `content` view
///     builder.
///
///   - content: A closure that takes the `Object` and returns a view of type
///     `Content`. This closure defines how the view should be built using the
///     observed object.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to construct
///   the UI, with the `ObservableObject` instance wrapped in `ObservedObject`
///   and passed to the closure.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var message: String = "Hello, world!"
/// }
///
/// struct MyView: View {
///     @StateObject private var viewModel = MyViewModel()
///
///     var body: some View {
///         WithInlineObservedObject(object: viewModel) { model in
///             VStack {
///                 Text(model.message)
///                 Button("Update") {
///                     model.message = "Updated message!"
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `WithInlineObservedObject` is used to create a view that
/// displays and updates a message from `MyViewModel`. The `content` closure
/// builds the UI using the observed object, ensuring that any changes to the
/// `message` property are reflected in the UI.
///
/// - Note: The `Object` type must conform to `ObservableObject` to work with
///   this struct.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
private struct WithInlineObservedObject<Object: ObservableObject, Content: View>: View {
    @ObservedObject private var object: Object
    
    let content: (Object) -> Content
    
    /// Initializes a new instance of `WithInlineObservedObject` with the given
    /// observable object and content view builder.
    ///
    /// - Parameters:
    ///   - object: An instance of `Object` that conforms to `ObservableObject`.
    ///   - content: A closure that takes the `Object` and returns a view of
    ///     type `Content`.
    init(
        object: Object,
        @ViewBuilder content: @escaping (Object) -> Content
    ) {
        self._object = ObservedObject(wrappedValue: object)
        self.content = content
    }
    
    /// The body of the view, which uses the content closure to build the UI.
    var body: some View {
        content(object)
    }
}

/// A SwiftUI view that wraps an optional `ObservableObject` with `ObservedObject`
/// and uses a content builder to display its data.
///
/// `WithOptionalInlineObservedObject` is a generic view struct designed to handle
/// an optional `ObservableObject`. It wraps the provided object in an `ObservedObject`
/// property wrapper, ensuring that the view can reactively update based on changes
/// to the observed object. If the object is `nil`, the initialization will fail with
/// a fatal error, as `ObservedObject` cannot handle a `nil` value.
///
/// This struct is useful when you need to conditionally provide an `ObservableObject`
/// to a view, but must ensure that a valid object is always used.
///
/// - Parameters:
///   - object: An optional instance of `Object` that conforms to `ObservableObject`.
///     The object will be wrapped in an `ObservedObject` if it is not `nil`. If it is
///     `nil`, a fatal error will be raised during initialization.
///
///   - content: A closure that takes an optional `Object` (`Object?`) and returns a
///     view of type `Content`. This closure defines how the view should be constructed
///     using the observed object, if present.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to construct
///   the UI, with the optional `ObservableObject` instance wrapped in `ObservedObject`
///   and passed to the closure.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var message: String = "Hello, world!"
/// }
///
/// struct MyView: View {
///     var viewModel: MyViewModel? = MyViewModel()  // Optional ViewModel
///
///     var body: some View {
///         WithOptionalInlineObservedObject(object: viewModel) { model in
///             VStack {
///                 if let model = model {
///                     Text(model.message)
///                     Button("Update") {
///                         model.message = "Updated message!"
///                     }
///                 } else {
///                     Text("No data available")
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `WithOptionalInlineObservedObject` is used to handle an optional
/// `MyViewModel` instance. The `content` closure builds the UI based on the presence
/// of the `model`. If the `model` is `nil`, a fallback message is displayed.
///
/// - Note: The `Object` type must conform to `ObservableObject` and cannot be `nil`
///   when initializing the struct.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
private struct WithOptionalInlineObservedObject<Object: ObservableObject, Content: View>: View {
    @ObservedObject private var object: Object

    /// A closure that builds the view using an optional `Object`.
    ///
    /// This closure receives an optional `Object` and returns a view of type
    /// `Content`. The `Object` is wrapped in an `ObservedObject` and is used
    /// to dynamically update the view based on its state.
    let content: (Object?) -> Content
    
    /// Initializes a new instance of `WithOptionalInlineObservedObject` with the
    /// given optional observable object and content view builder.
    ///
    /// - Parameters:
    ///   - object: An optional instance of `Object` that conforms to `ObservableObject`.
    ///     A fatal error is raised if this value is `nil`.
    ///   - content: A closure that takes an optional `Object` and returns a view of
    ///     type `Content`.
    init(
        object: Object?,
        @ViewBuilder content: @escaping (Object?) -> Content
    ) {
        if let object = object {
            self._object = ObservedObject(wrappedValue: object)
        } else {
            fatalError("Object cannot be nil when using ObservedObject")
        }
        self.content = content
    }
    
    /// The body of the view, which uses the content closure to build the UI.
    ///
    /// The `content` closure is called with the `ObservedObject` instance, providing
    /// a way to dynamically construct the view based on the observed object's state.
    var body: some View {
        content(object)
    }
}

/// A SwiftUI view that wraps an `ObservableObject` using `StateObject`
/// and uses a content builder to display its data.
///
/// `WithInlineStateObject` is a generic view struct that manages an instance of
/// an `ObservableObject` using `StateObject`. It provides a convenient way to
/// initialize a `StateObject` and pass it to a content builder closure, allowing
/// the view to reactively update based on changes to the state object.
///
/// This struct is useful when you want to embed a `StateObject` directly within
/// a view and define its presentation using a content builder.
///
/// - Parameters:
///   - object: An instance of `Object` that conforms to `ObservableObject`. This
///     object is wrapped in a `StateObject` property wrapper, allowing it to
///     manage and update its state reactively within the view.
///
///   - content: A closure that takes the `Object` and returns a view of type
///     `Content`. This closure defines how the view should be constructed using
///     the state object.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to construct
///   the UI, with the `ObservableObject` instance managed by `StateObject` and passed
///   to the closure.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var message: String = "Hello, world!"
/// }
///
/// struct MyView: View {
///     var viewModel = MyViewModel()  // StateObject is managed internally
///
///     var body: some View {
///         WithInlineStateObject(object: viewModel) { model in
///             VStack {
///                 Text(model.message)
///                 Button("Update") {
///                     model.message = "Updated message!"
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `WithInlineStateObject` is used to create a view that manages
/// the state of `MyViewModel`. The `content` closure constructs the UI based on
/// the `model`, allowing for updates to be reflected in the view whenever the
/// `message` property changes.
///
/// - Note: The `Object` type must conform to `ObservableObject` to work with this
///   struct.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
private struct WithInlineStateObject<Object: ObservableObject, Content: View>: View {
    @StateObject private var object: Object
    
    /// A closure that builds the view using the `Object`.
    ///
    /// This closure receives the `Object` and returns a view of type `Content`.
    /// The `Object` is managed by `StateObject` and is used to dynamically update
    /// the view based on its state.
    let content: (Object) -> Content
    
    /// Initializes a new instance of `WithInlineStateObject` with the given
    /// observable object and content view builder.
    ///
    /// - Parameters:
    ///   - object: An instance of `Object` that conforms to `ObservableObject`.
    ///   - content: A closure that takes the `Object` and returns a view of type
    ///     `Content`.
    init(
        object: Object,
        @ViewBuilder content: @escaping (Object) -> Content
    ) {
        self._object = StateObject(wrappedValue: object)
        self.content = content
    }
    
    /// The body of the view, which uses the content closure to build the UI.
    ///
    /// The `content` closure is called with the `StateObject` instance, providing
    /// a way to dynamically construct the view based on the state object.
    var body: some View {
        content(object)
    }
}

/// A SwiftUI view that wraps an optional `ObservableObject` using `StateObject`.
///
/// `WithInlineOptionalStateObject` is a generic view struct that manages an instance
/// of `ObservableObject` using `StateObject`. It provides a way to initialize a `StateObject`
/// with an optional object, defaulting to a placeholder if the provided object is `nil`.
/// The view is constructed using a content builder closure that takes the `ObservableObject`
/// instance and returns a view.
///
/// This struct is useful when you have an optional `ObservableObject` and want to ensure
/// that a `StateObject` is always provided for the view's content, even if the original
/// object is `nil`.
///
/// - Parameters:
///   - object: An optional instance of `Object` that conforms to `ObservableObject`. If `nil`,
///     a default instance of `DefaultObservableObject` is used (cast to `Object`).
///
///   - content: A closure that takes the `Object` and returns a view of type `Content`. This
///     closure defines how the view should be constructed using the state object.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to construct the
///   UI, with the `ObservableObject` managed by `StateObject` and passed to the closure.
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var message: String = "Hello, world!"
/// }
///
/// struct MyView: View {
///     var viewModel: MyViewModel? = nil  // Optional state object
///
///     var body: some View {
///         WithInlineOptionalStateObject(object: viewModel) { model in
///             VStack {
///                 Text(model?.message ?? "No model available")
///                 Button("Update") {
///                     model?.message = "Updated message!"
///                 }
///             }
///             .padding()
///         }
///     }
/// }
/// ```
/// In this example, `WithInlineOptionalStateObject` handles an optional `MyViewModel`.
/// If `viewModel` is `nil`, a default `DefaultObservableObject` is used, ensuring that
/// the view can still be constructed and displayed.
///
/// - Note: The `Object` type must conform to `ObservableObject`. The default instance
///   used when `object` is `nil` must be compatible with the type of `Object`.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
private struct WithInlineOptionalStateObject<Object: ObservableObject, Content: View>: View {
    @StateObject private var object: Object
    
    /// A closure that builds the view using the `Object`.
    ///
    /// This closure receives the `Object` and returns a view of type `Content`.
    /// The `Object` is managed by `StateObject` and is used to dynamically update
    /// the view based on its state.
    let content: (Object) -> Content
    
    /// Initializes a new instance of `WithInlineOptionalStateObject` with the given
    /// optional observable object and content view builder.
    ///
    /// - Parameters:
    ///   - object: An optional instance of `Object` that conforms to `ObservableObject`.
    ///     If `nil`, a default instance of `DefaultObservableObject` is used (cast to `Object`).
    ///   - content: A closure that takes the `Object` and returns a view of type `Content`.
    init(
        object: Object?,
        @ViewBuilder content: @escaping (Object) -> Content
    ) {
        if let object = object {
            self._object = StateObject(wrappedValue: object)
        } else {
            // swiftlint:disable force_cast
            self._object = StateObject(wrappedValue: DefaultObservableObject() as! Object)
            // swiftlint:enable force_cast
        }
        self.content = content
    }
    
    /// The body of the view, which uses the content closure to build the UI.
    ///
    /// The `content` closure is called with the `StateObject` instance, providing
    /// a way to dynamically construct the view based on the state object.
    var body: some View {
        content(object)
    }
}

/// A SwiftUI view that displays content based on a continuously updating timer.
///
/// `WithInlineTimerState` manages a state value that updates at regular intervals
/// based on the provided `TimeInterval`. It uses a `Timer` to increment the state
/// value and triggers a view update whenever the value changes. The view is constructed
/// using the content builder closure which receives the current timer value.
///
/// This struct is useful for scenarios where you need to periodically update the view
/// based on a timer, such as for creating real-time updates or animations.
///
/// - Parameters:
///   - interval: The time interval between updates, in seconds. The timer will fire at
///     this interval and increment the state value.
///
///   - content: A closure that takes the current timer value (`Int`) and returns a view
///     of type `Content`. This closure defines how the view should be constructed using
///     the current value from the timer.
///
/// - Returns: A SwiftUI view that uses the provided `content` closure to build the UI
///   based on the periodically updated value.
///
/// ```swift
/// struct TimerView: View {
///     var body: some View {
///         WithInlineTimerState(interval: 1.0) { value in
///             VStack {
///                 Text("Seconds elapsed: \(value)")
///                 // Additional view components here
///             }
///         }
///     }
/// }
/// ```
/// In this example, `WithInlineTimerState` creates a timer that updates every second,
/// displaying the elapsed seconds in a `Text` view. The view will update automatically
/// as the timer fires and the value increments.
///
/// - Note: The timer will start when the view appears and stop when it disappears.
///   Ensure that the interval is set according to the requirements of your use case.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
private struct WithInlineTimerState<Content: View>: View {
    @State private var value: Int = 0
    @State private var timer: Timer?
    private let interval: TimeInterval

    /// A closure that builds the view using the current timer value.
    ///
    /// This closure receives the current `value` of type `Int` and returns a view
    /// of type `Content`. The view updates automatically as the timer fires and
    /// increments the value.
    let content: (Int) -> Content

    /// Initializes a new instance of `WithInlineTimerState` with the specified interval
    /// and content view builder.
    ///
    /// - Parameters:
    ///   - interval: The time interval between timer updates, in seconds.
    ///   - content: A closure that takes the current timer value and returns a view
    ///     of type `Content`.
    init(
        interval: TimeInterval,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._value = State(initialValue: 0)
        self._timer = State(initialValue: nil)
        self.interval = interval
        self.content = content
    }

    /// The body of the view, which uses the content closure to build the UI.
    ///
    /// The `content` closure is called with the current `value`, which is updated
    /// periodically by the timer. The timer starts when the view appears and stops
    /// when the view disappears.
    var body: some View {
        content(value)
            .onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                    Task { @MainActor in
                        value += 1
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                self.timer = nil
            }
    }
}

/// A default implementation of `ObservableObject` that can be used as a placeholder.
///
/// `DefaultObservableObject` is a simple class that conforms to the `ObservableObject`
/// protocol. It is intended to be used as a default or fallback implementation in scenarios
/// where an `ObservableObject` is required but no specific functionality is needed.
///
/// This class does not provide any additional properties or methods beyond those inherited
/// from `ObservableObject`. Its primary use is to act as a generic or default observable object
/// when initializing views or managing state where the actual object implementation is not critical.
///
/// - Note: Use `DefaultObservableObject` when you need an `ObservableObject` instance but
///   do not have a specific implementation to provide. It can be useful in cases where
///   you need to initialize a state or manage bindings but don't need to react to changes
///   or provide additional functionality.
///
/// - Conformance: Conforms to the `ObservableObject` protocol.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
private class DefaultObservableObject: ObservableObject {}
