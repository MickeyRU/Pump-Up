import Foundation

protocol FinishWorkoutUseCase {
    func execute(id: WorkoutID, now: Date) async throws -> Workout
}

final class FinishWorkoutUseCaseImpl: FinishWorkoutUseCase {
    private let repo: WorkoutRepository
    
    init(repository: WorkoutRepository) {
        self.repo = repository
    }

    func execute(id: WorkoutID, now: Date) async throws -> Workout {
        try await repo.update(id) { $0.finish() }
    }
}
