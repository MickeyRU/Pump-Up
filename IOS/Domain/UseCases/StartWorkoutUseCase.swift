import Foundation

@MainActor
public protocol StartWorkoutUseCase {
    /// Переводит существующую тренировку в .inProgress и сохраняет
    func execute(workout: Workout) throws -> Workout
}
