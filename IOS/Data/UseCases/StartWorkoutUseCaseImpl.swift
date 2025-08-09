import Foundation

@MainActor
public final class StartWorkoutUseCaseImpl: StartWorkoutUseCase {
    private let repo: WorkoutRepository
    public init(repository: WorkoutRepository) { self.repo = repository }

    public func execute(workout: Workout) throws -> Workout {
        var w = workout
        // если только создана — переведём в inProgress и при необходимости обновим startDate
        w.status = .inProgress
        // w.startDate = Date() // если нужно принудительно обновлять
        try repo.save(w)
        return w
    }
}

