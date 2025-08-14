import SwiftUI

private struct WorkoutStatsProviderKey: EnvironmentKey {
    static let defaultValue: WorkoutStatsProviding = WorkoutStatsService()
}

extension EnvironmentValues {
    var workoutStatsProvider: WorkoutStatsProviding {
        get { self[WorkoutStatsProviderKey.self] }
        set { self[WorkoutStatsProviderKey.self] = newValue }
    }
}
