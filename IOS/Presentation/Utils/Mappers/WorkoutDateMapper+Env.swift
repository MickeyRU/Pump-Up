import SwiftUI

private struct WorkoutDateMapperKey: EnvironmentKey {
    static let defaultValue: WorkoutDateMapper = DefaultWorkoutDateMapper()
}

extension EnvironmentValues {
    var workoutDateMapper: WorkoutDateMapper {
        get { self[WorkoutDateMapperKey.self] }
        set { self[WorkoutDateMapperKey.self] = newValue }
    }
}
