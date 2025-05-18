# EnvironmentKit

**EnvironmentKit** is a Swift package designed specifically for enhancing dependency injection patterns in SwiftUI applications. It provides convenient property wrappers and view modifiers to streamline injecting dependencies via the SwiftUI `Environment`, enabling cleaner, maintainable, and testable code.

---

## Installation

You can install **EnvironmentKit** via the Swift Package Manager (SPM):

1. In Xcode, select **File** → **Add Packages...**.
2. Enter the package repository URL:

```
https://github.com/sedlacek-solutions/EnvironmentKit.git
```

3. Choose the desired version or branch, then click **Add Package**.

---

## EnvironmentBindable

The `@EnvironmentBindable` property wrapper simplifies injecting dependencies conforming to `Observable` into your SwiftUI views and automatically provides their `projectedValue`. This eliminates the need to manually wrap the dependency in `Bindable`.

### Before EnvironmentBindable:

Previously, you had to manually use `Bindable` inside the view:

```swift
@Observable
class MyService {
    var value: String = "Initial value"
}

struct ContentView: View {
    @Environment(MyService.self) private var service

    var body: some View {
        @Bindable var service = service
        TextField("Enter value", text: $service.value)
    }
}
```

### After EnvironmentBindable:

With `@EnvironmentBindable`, you can access the projected value directly, simplifying your view:

```swift
@Observable
class MyService {
    var value: String = "Initial value"
}

struct ContentView: View {
    @EnvironmentBindable private var service: MyService

    var body: some View {
        TextField("Enter value", text: $service.value)
    }
}
```

### Injecting Dependency

Inject the dependency at a higher level in your view hierarchy:

```swift
struct RootView: View {
    @State private var service = MyService()

    var body: some View {
        ContentView()
            .environment(service)
    }
}
```

---

## EnvironmentBinding & environment(binding:) Modifier

The `@EnvironmentBinding` property wrapper combined with the `environment(binding:)` view modifier allows you to inject and propagate SwiftUI bindings through the environment seamlessly.

### Usage

Example demonstrating `@EnvironmentBinding`:

```swift
struct ParentView: View {
    @State private var rootValue: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("Root value: \(rootValue)")
                .font(.headline)

            Button("Increment Root") {
                rootValue += 1
            }

            Divider()

            ChildView()

        }
        .padding()
        .environment(binding: $rootValue)
    }
}

struct ChildView: View {
    @EnvironmentBinding var childValue: Int

    var body: some View {
        VStack(spacing: 16) {
            Text("Child sees: \(childValue)")
            Button("Increment Child") {
                childValue += 1
            }
        }
        .padding()
        .border(Color.gray)
    }
}
```
