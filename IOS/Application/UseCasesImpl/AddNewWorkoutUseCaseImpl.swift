import Foundation

@MainActor
final class AddNewWorkoutUseCaseImpl: AddNewWorkoutUseCase {
    private let repository: WorkoutRepository
    
    init(repository: WorkoutRepository) {
        self.repository = repository
    }
    
    func execute(workout: Workout) throws {
        try repository.save(workout)
    }
}
