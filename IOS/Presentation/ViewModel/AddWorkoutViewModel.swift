import Foundation

@MainActor
final class AddWorkoutViewModel: ObservableObject {
    @Published var workoutType: WorkoutType = .pull_ups
    @Published var reps: Int = 5
    @Published var sets: Int = 10
    @Published var restTime: TimeInterval = 120

    func buildWorkout() -> Workout {
        let planningData = WorkoutPlanData(repeatsPerSet: reps, sets: sets, restTime: restTime)
        return Workout(type: workoutType, planning: planningData)
    }
}
