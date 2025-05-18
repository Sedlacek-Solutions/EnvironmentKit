//
//  EnvironmentBindable.swift
//
//  Created by James Sedlacek on 3/6/24.
//

import SwiftUI

/// A property wrapper that provides a convenient way to bind observable objects from the environment
/// to a SwiftUI view. This wrapper simplifies the process of accessing and binding environment objects
/// that conform to the Observable protocol.
///
/// Example usage:
/// ```swift
/// // Define your observable object
/// @Observable class UserSettings {
///     var username: String = ""
///     var isLoggedIn: Bool = false
/// }
///
/// // In your view
/// struct ContentView: View {
///     @EnvironmentBindable private var settings: UserSettings
///
///     var body: some View {
///         VStack {
///             // Access the wrapped value directly
///             Text("Hello, \(settings.username)")
///
///             // Use two-way binding with $
///             TextField("Username", text: $settings.username)
///             Toggle("Logged In", isOn: $settings.isLoggedIn)
///         }
///     }
/// }
///
/// // In your app or scene
/// @main
/// struct MyApp: App {
///     @State private var settings = UserSettings()
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .environment(settings)
///         }
///     }
/// }
/// ```
@propertyWrapper
public struct EnvironmentBindable<T: Observable & AnyObject>: DynamicProperty {
    /// The observable object accessed through the environment.
    @Environment(T.self) private var object

    /// The current value of the observable object.
    public var wrappedValue: T { _object.wrappedValue }

    /// A bindable projection of the observable object, allowing it to be used with SwiftUI's
    /// two-way binding mechanism.
    public var projectedValue: Bindable<T> {
        @Bindable var wrappedValue = wrappedValue
        return $wrappedValue
    }

    /// Initializes a new instance of `EnvironmentBindable`.
    public init() {}
}
