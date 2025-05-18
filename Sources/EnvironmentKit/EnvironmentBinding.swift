//
//  EnvironmentBinding.swift
//
//  Created by James Sedlacek on 2/20/25.
//

import SwiftUI

/// A property wrapper that creates a two-way binding to a value in the SwiftUI environment.
///
/// `EnvironmentBinding` allows you to read and write a value that is provided by an ancestor view
/// using the `.environment(binding:)` view modifier. This is particularly useful when you need to
/// share mutable state across different parts of your view hierarchy without explicitly passing
/// bindings through initializers.
///
/// To use `EnvironmentBinding`, first, provide a `Binding` to an ancestor view using the
/// `.environment(binding:)` modifier. Then, in a descendant view, declare a property
/// with the `@EnvironmentBinding` attribute and the same type as the provided binding.
///
/// # Usage Example
///
/// ```swift
/// // In the parent view
/// struct ParentView: View {
///     @State private var sharedText: String = "Hello, Environment!"
///
///     var body: some View {
///         VStack {
///             TextField("Shared Text", text: $sharedText)
///             ChildView()
///         }
///         .environment(binding: $sharedText)
///     }
/// }
///
/// // In the child view
/// struct ChildView: View {
///     @EnvironmentBinding private var sharedText: String
///
///     var body: some View {
///         Text("Child observes: \(sharedText)")
///         Button("Modify from Child") {
///             sharedText = "Modified by Child"
///         }
///     }
/// }
/// ```
@MainActor
@propertyWrapper
public struct EnvironmentBinding<T: Equatable>: DynamicProperty {
    @Environment(ObservableValue<T>.self) private var observedValue

    /// The object stored in the container.
    public var wrappedValue: T {
        get { observedValue.value }
        nonmutating set { observedValue.value = newValue }
    }

    /// A binding to the object stored in the container.
    public var projectedValue: Binding<T> {
        .init(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    public init() {}
}
