import Foundation

struct NewWorkoutInput {
    let type: WorkoutType
    let planning: WorkoutPlanData
    let startImmediately: Bool
}

protocol AddNewWorkoutUseCase {
    func execute(_ input: NewWorkoutInput, now: Date) async throws -> Workout
}

final class AddNewWorkoutUseCaseImpl: AddNewWorkoutUseCase {
    private let repo: WorkoutRepository

    init(repository: WorkoutRepository) {
        self.repo = repository
    }
    
    func execute(_ input: NewWorkoutInput, now: Date = .now) async throws -> Workout {
        var w = Workout(
            id: WorkoutID(raw: UUID()),
            type: input.type,
            startDate: nil,
            status: .notStarted,
            planning: input.planning,
            endDate: nil,
            sets: []
        )
        if input.startImmediately { w.start(at: now) }
        try await repo.save(w)
        return w
    }
}
