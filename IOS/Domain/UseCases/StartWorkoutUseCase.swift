import Foundation

protocol StartWorkoutUseCase {
    func execute(type: WorkoutType, planning: WorkoutPlanData) -> Workout
}

final class StartWorkoutUseCaseImpl: StartWorkoutUseCase {
    func execute(type: WorkoutType, planning: WorkoutPlanData) -> Workout {
        Workout(
            type: type,
            startDate: Date(),
            status: .inProgress,
            planning: planning,
            endDate: nil,
            sets: []
        )
    }
}
