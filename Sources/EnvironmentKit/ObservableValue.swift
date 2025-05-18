//
//  Container.swift
//
//  Created by James Sedlacek on 12/27/24.
//

import Foundation


/// An observable wrapper class for a value of type `T`.
///
/// `ObservableValue` is used internally by `EnvironmentBinding` and the `.environment(binding:)`
/// view modifier to propagate changes of an environment-bound value through the SwiftUI
/// view hierarchy. It conforms to `Observable` to trigger view updates when its `value` changes.
/// It also conforms to `Equatable` if `T` is `Equatable`, allowing for comparisons.
@Observable
final class ObservableValue<T: Equatable> {
    var value: T

    init(_ initialValue: T) {
        self.value = initialValue
    }
}

extension ObservableValue: Equatable {
    nonisolated static func == (
        lhs: ObservableValue<T>,
        rhs: ObservableValue<T>
    ) -> Bool {
        lhs.value == rhs.value
    }
}
