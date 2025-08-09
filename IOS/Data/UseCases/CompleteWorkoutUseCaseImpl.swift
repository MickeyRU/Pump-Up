import Foundation

@MainActor
public final class CompleteWorkoutUseCaseImpl: CompleteWorkoutUseCase {
    private let repo: WorkoutRepository
    public init(repository: WorkoutRepository) { self.repo = repository }

    public func execute(workout: Workout) throws -> Workout {
        var w = workout
        w.status = .completed
        w.endDate = Date()
        try repo.save(w)
        return w
    }
}

