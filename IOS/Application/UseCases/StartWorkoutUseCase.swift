import Foundation

protocol StartWorkoutUseCase {
    func execute(id: WorkoutID, now: Date) async throws -> Workout
}

final class StartWorkoutUseCaseImpl: StartWorkoutUseCase {
    private let repo: WorkoutRepository
    
    init(repository: WorkoutRepository) {
        self.repo = repository
    }
    
    func execute(id: WorkoutID, now: Date) async throws -> Workout {
        try await repo.update(id) { $0.start(at: now) }
    }
}
