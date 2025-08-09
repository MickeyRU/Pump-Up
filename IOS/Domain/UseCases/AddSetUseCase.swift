import Foundation

@MainActor
public protocol AddSetUseCase {
    /// Добавляет подход (reps/restTime) и сохраняет
    func execute(workout: Workout, reps: Int, restTime: TimeInterval) throws -> Workout
}
