import Foundation

@MainActor
public final class AddSetUseCaseImpl: AddSetUseCase {
    private let repo: WorkoutRepository
    public init(repository: WorkoutRepository) { self.repo = repository }

    public func execute(workout: Workout, reps: Int, restTime: TimeInterval) throws -> Workout {
        var w = workout
        w.sets.append(.init(reps: reps, restTime: restTime))
        try repo.save(w)
        return w
    }
}

