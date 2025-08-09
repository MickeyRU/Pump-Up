import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
    @Published private(set) var workout: Workout
    @Published var isResting = false
    @Published var restRemaining: Int = 0
    @Published var repsForNextSet: Int

    private let startUC: StartWorkoutUseCase
    private let addSetUC: AddSetUseCase
    private let completeUC: CompleteWorkoutUseCase

    private var restTask: Task<Void, Never>?

    init(workout: Workout,
         startUC: StartWorkoutUseCase,
         addSetUC: AddSetUseCase,
         completeUC: CompleteWorkoutUseCase) {
        self.workout = workout
        self.startUC = startUC
        self.addSetUC = addSetUC
        self.completeUC = completeUC
        self.repsForNextSet = workout.planning.repeatsPerSet
    }

    // MARK: Derived stats
    var completedSets: Int { workout.sets.count }
    var totalReps: Int { workout.sets.reduce(0) { $0 + $1.reps } }
    var averageReps: Double { completedSets == 0 ? 0 : Double(totalReps) / Double(completedSets) }
    var totalRestTime: TimeInterval { workout.sets.reduce(0) { $0 + $1.restTime } }
    var duration: TimeInterval {
        guard let end = workout.endDate else { return 0 }
        return end.timeIntervalSince(workout.startDate)
    }
    var progress: Double {
        guard workout.planning.sets > 0 else { return 0 }
        return Double(completedSets) / Double(workout.planning.sets)
    }

    // MARK: UI control
    var canStart: Bool { workout.status == .notStarted }
    var canDoSet: Bool { workout.status == .inProgress && !isResting && completedSets < workout.planning.sets }
    var canFinish: Bool { workout.status != .completed && (workout.status == .inProgress || completedSets > 0) }

    // MARK: Actions
    func startWorkout() {
        guard canStart else { return }
        do {
            let updated = try startUC.execute(workout: workout)
            workout = updated
        } catch { /* TODO: показать ошибку */ }
    }

    func performSet() {
        guard canDoSet else { return }
        let rest = workout.planning.restTime
        do {
            let updated = try addSetUC.execute(workout: workout, reps: repsForNextSet, restTime: rest)
            workout = updated
            startRestCountdown(seconds: Int(rest))
        } catch { /* TODO: показать ошибку */ }
    }

    func finishWorkout() {
        guard canFinish else { return }
        cancelRest()
        do {
            let updated = try completeUC.execute(workout: workout)
            workout = updated
        } catch { /* TODO: показать ошибку */ }
    }

    func skipRest() {
        cancelRest()
        isResting = false
        restRemaining = 0
    }

    // MARK: Rest timer
    private func startRestCountdown(seconds: Int) {
        cancelRest()
        isResting = true
        restRemaining = max(0, seconds)

        restTask = Task { [weak self] in
            guard let self else { return }
            while self.restRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run { self.restRemaining -= 1 }
                if Task.isCancelled { return }
            }
            await MainActor.run { self.isResting = false }
        }
    }

    private func cancelRest() {
        restTask?.cancel()
        restTask = nil
    }

    var restRemainingString: String {
        String(format: "%02d:%02d", restRemaining / 60, restRemaining % 60)
    }

    deinit { restTask?.cancel() }
}
