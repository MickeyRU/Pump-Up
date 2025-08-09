import Foundation

@MainActor
public protocol AddWorkoutUseCase {
    func execute(workout: Workout) throws
}

@MainActor
final class AddWorkoutUseCaseImpl: AddWorkoutUseCase {
    private let repository: WorkoutRepository
    
    init(repository: WorkoutRepository) {
        self.repository = repository
    }
    
    func execute(workout: Workout) throws {
        try repository.save(workout)
    }
}
