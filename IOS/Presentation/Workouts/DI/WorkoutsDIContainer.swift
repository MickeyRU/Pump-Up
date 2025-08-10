import Foundation

@MainActor
final class WorkoutsDIContainer: ObservableObject {
    let repo: WorkoutRepository
    let ucs: WorkoutUseCases
    let stats: WorkoutStatsProviding


    init(repo: WorkoutRepository) {
        self.repo = repo
        self.ucs = WorkoutUseCases(add: AddNewWorkoutUseCaseImpl(repository: repo),
                                   start: StartWorkoutUseCaseImpl(repository: repo),
                                   addSet: AddSetUseCaseImpl(repository: repo),
                                   complete: CompleteWorkoutUseCaseImpl(repository: repo))
        self.stats = WorkoutStatsService()
    }
}
