import Foundation

protocol AddSetUseCase {
    func execute(id: WorkoutID, set: WorkoutSetData) async throws -> Workout
}

final class AddSetUseCaseImpl: AddSetUseCase {
    private let repo: WorkoutRepository
    
    init(repository: WorkoutRepository) {
        self.repo = repository
    }
    
    func execute(id: WorkoutID, set: WorkoutSetData) async throws -> Workout {
        try await repo.update(id) { $0.addSet(set) }
    }
}
