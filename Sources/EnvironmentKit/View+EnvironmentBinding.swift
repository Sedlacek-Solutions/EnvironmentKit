//
//  View+EnvironmentBinding.swift
//
//  Created by James Sedlacek on 2/20/25.
//

import SwiftUI

extension View {
    /// Makes a `Binding` available to descendant views in the environment.
    ///
    /// Use this modifier to pass a `Binding` down the view hierarchy. Descendant views can
    /// then access and modify this binding using the `@EnvironmentBinding` property wrapper.
    ///
    /// - Parameter binding: The `Binding` to make available in the environment.
    /// - Returns: A view that makes the `binding` available to its descendants.
    ///
    /// # Usage Example
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var count: Int = 0
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text("Count: \(count)")
    ///             Button("Increment") {
    ///                 count += 1
    ///             }
    ///             CounterDisplayView()
    ///         }
    ///         .environment(binding: $count) // Provide the binding here
    ///     }
    /// }
    ///
    /// struct CounterDisplayView: View {
    ///     @EnvironmentBinding private var count: Int // Access the binding here
    ///
    ///     var body: some View {
    ///         Text("CounterDisplayView sees: \(count)")
    ///         Button("Decrement from Display") {
    ///             count -= 1
    ///         }
    ///     }
    /// }
    /// ```
    public func environment<T: Equatable>(binding: Binding<T>) -> some View {
        modifier(EnvironmentBindingViewModifier(binding: binding))
    }
}

/// A view modifier that facilitates the environment binding mechanism.
///
/// `EnvironmentBindingViewModifier` is responsible for creating an `ObservableValue`
/// instance from the provided `Binding` and injecting it into the SwiftUI environment.
/// It also sets up `onChange` observers to keep the `Binding` and the `ObservableValue`
/// synchronized. This modifier is applied automatically when you use the
/// `.environment(binding:)` extension on `View`.
struct EnvironmentBindingViewModifier<T: Equatable>: ViewModifier {
    @State private var observedValue: ObservableValue<T>
    @Binding private var binding: T

    init(binding: Binding<T>) {
        observedValue = .init(binding.wrappedValue)
        self._binding = binding
    }

    func body(content: Content) -> some View {
        content
            .environment(observedValue)
            .onChange(of: binding) { _, newValue in
                guard newValue != observedValue.value else { return }
                observedValue.value = newValue
            }
            .onChange(of: observedValue.value) { _, newValue in
                guard newValue != binding else { return }
                binding = newValue
            }
    }
}
