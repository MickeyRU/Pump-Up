import Foundation

@MainActor
public protocol CompleteWorkoutUseCase {
    /// Ставит статус .completed, endDate = now и сохраняет
    func execute(workout: Workout) throws -> Workout
}
