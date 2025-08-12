import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
    @Published private(set) var workout: Workout
    @Published private(set) var stats: WorkoutStats
    
    @Published var isResting = false
    @Published var restRemaining: Int = 0
    @Published var repsForNextSet: Int

    private let ucs: WorkoutUseCases
    private let statsProvider: WorkoutStatsProviding

    private var restTask: Task<Void, Never>?
    private var durationTask: Task<Void, Never>?
    
    var progress: Double {
        let plan = stats.plannedSets
        guard plan > 0 else { return 0 }
        return Double(stats.totalSets) / Double(plan)
    }
    
    init(workout: Workout,
         ucs: WorkoutUseCases,
         statsProvider: WorkoutStatsProviding) {
        self.workout = workout
        self.ucs = ucs
        self.statsProvider = statsProvider
        self.repsForNextSet = workout.planning.repeatsPerSet
        self.stats = statsProvider.stats(for: workout)
        
        startDurationUpdatesIfNeeded()
    }

    // MARK: - Actions
    func startWorkout() {
        guard canStart else { return }
        do {
            let updated = try ucs.start.execute(workout: workout)
            workout = updated
            refreshStats()
            startDurationUpdatesIfNeeded()
        } catch { /* TODO: показать ошибку */ }
    }

    func performSet() {
        guard canDoSet else { return }
        let rest = workout.planning.restTime
        do {
            let updated = try ucs.addSet.execute(workout: workout, reps: repsForNextSet, restTime: rest)
            workout = updated
            refreshStats()
            startRestCountdown(seconds: Int(rest))
        } catch { /* TODO: показать ошибку */ }
    }

    func finishWorkout() {
        guard canFinish else { return }
        cancelRest()
        cancelDuration()
        do {
            let updated = try ucs.complete.execute(workout: workout)
            workout = updated
            refreshStats()
        } catch { /* TODO: показать ошибку */ }
    }

    func skipRest() {
        cancelRest()
        isResting = false
        restRemaining = 0
    }

    // MARK: - UI control
    var canStart: Bool { workout.status == .notStarted }
    var canDoSet: Bool { workout.status == .inProgress && !isResting && stats.totalSets < workout.planning.sets }
    var canFinish: Bool { workout.status != .completed && (workout.status == .inProgress || stats.totalSets > 0) }

    // MARK: - Private helpers
    private func refreshStats() {
        var base = statsProvider.stats(for: workout)
        if workout.status != .completed {
            base = base.withDuration(Date().timeIntervalSince(workout.startDate))
        }
        stats = base
    }

    private func startDurationUpdatesIfNeeded() {
        guard workout.status != .completed else { return }
        cancelDuration()
        
        durationTask = Task { [weak self] in
            guard let self else { return }
            while true {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                refreshStats()
                if Task.isCancelled { return }
            }
        }
    }

    private func cancelDuration() {
        durationTask?.cancel()
        durationTask = nil
    }

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

    deinit {
        restTask?.cancel()
        durationTask?.cancel()
    }
}
