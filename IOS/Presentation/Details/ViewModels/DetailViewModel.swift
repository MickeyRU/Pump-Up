import Foundation

@MainActor
final class DetailViewModel: WorkoutStatsUpdatable, ObservableObject {
    @Published private(set) var workout: Workout
    @Published private(set) var stats: WorkoutStats?
    @Published private(set) var rowItem: WorkoutHeaderItem
    @Published private(set) var recentSetRows: [SetsHistoryRow] = []
    
    @Published var isResting = false
    @Published var restRemaining: Int = 0
    @Published var repsForNextSet: Int
    
    private let ucs: WorkoutUseCases
    private var statsProvider: WorkoutStatsProviding?
    private var tickerTask: Task<Void, Never>?
    private var restTask: Task<Void, Never>?
    
    private var lastSetsCount: Int
    
    init(workout: Workout, ucs: WorkoutUseCases) {
        self.workout = workout
        self.ucs = ucs
        self.statsProvider = nil
        self.stats = nil
        self.rowItem = WorkoutHeaderItem(
            iconName: workout.type.iconName,
            title: workout.type.displayName,
            endDate: workout.endDate,
            status: workout.status
        )
        self.repsForNextSet = workout.planning.repeatsPerSet
        self.lastSetsCount  = workout.sets.count
        self.rebuildRecentRowsFastIfNeeded(from: workout.sets, forceFullRebuild: true)
    }
    
    func start(with provider: WorkoutStatsProviding) {
        statsProvider = provider
        recalcStats()
        
        tickerTask?.cancel()
        guard workout.endDate == nil else { return }
        
        tickerTask = Task {
            while !Task.isCancelled {
                recalcStats()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
    
    func stop() {
        tickerTask?.cancel(); tickerTask = nil
        restTask?.cancel();   restTask   = nil
        statsProvider = nil
    }
    
    func incrementReps() { repsForNextSet = min(repsForNextSet + 1, 999) }
    func decrementReps() { repsForNextSet = max(repsForNextSet - 1, 1) }
    
    func addSetAndStartRest(seconds: Int) {
        guard workout.status == .inProgress else { return }
        let set = WorkoutSetData(reps: repsForNextSet, restTime: TimeInterval(seconds))
        Task { @MainActor [ucs, id = workout.id] in
            do {
                let updated = try await ucs.addSet.execute(id: id, set: set)
                apply(updated)
                startRest(seconds: seconds)
            } catch {
                print("Failed to add set: \(error)")
            }
        }
    }
    
    func startWorkout() {
        guard workout.status == .notStarted else { return }
        Task { @MainActor [ucs, id = workout.id] in
            do {
                let updated = try await ucs.start.execute(id: id, now: .now)
                apply(updated)
            } catch {
                print("Failed to start workout: \(error)")
            }
        }
    }
    
    func finishWorkout() {
        guard workout.status == .inProgress else { return }
        stopRestEarly()
        Task { @MainActor [ucs, id = workout.id] in
            do {
                let updated = try await ucs.finish.execute(id: id, now: .now)
                apply(updated)
            } catch {
                print("Failed to finish workout: \(error)")
            }
        }
    }
    
    func stopRestEarly() {
        restTask?.cancel()
        restTask = nil
        isResting = false
        restRemaining = 0
    }
    
    private func startRest(seconds: Int) {
        restTask?.cancel()
        isResting = true
        restRemaining = max(0, seconds)
        
        restTask = Task { @MainActor in
            while !Task.isCancelled && restRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                restRemaining -= 1
            }
            if !Task.isCancelled {
                isResting = false
            }
        }
    }
    
    private func recalcStats() {
        guard let statsProvider else { return }
        stats = statsProvider.getStats(for: workout)
        
        rowItem = WorkoutHeaderItem(
            iconName: workout.type.iconName,
            title: workout.type.displayName,
            endDate: workout.endDate,
            status: workout.status
        )
        
        rebuildRecentRowsFastIfNeeded(from: workout.sets)

        if workout.endDate != nil { stop() }
    }
    
    private func apply(_ updated: Workout) {
        workout = updated
        rebuildRecentRowsFastIfNeeded(from: workout.sets)
        recalcStats()
    }
    
    private func rebuildRecentRowsFastIfNeeded(from sets: [WorkoutSetData], forceFullRebuild: Bool = false) {
        if forceFullRebuild || recentSetRows.isEmpty {
            let rows = sets.enumerated().map { (idx, s) in
                SetsHistoryRow(id: s.id, date: s.performedAt, reps: s.reps, index: idx + 1)
            }
            recentSetRows = Array(rows.reversed())
            lastSetsCount = sets.count
            return
        }
        
        guard sets.count > lastSetsCount else { return }
        
        let delta = sets.count - lastSetsCount
        let newSlice = sets.suffix(delta)
        var toPrepend: [SetsHistoryRow] = []
        toPrepend.reserveCapacity(delta)
        
        var nextIndex = lastSetsCount + 1
        for s in newSlice {
            toPrepend.append(SetsHistoryRow(id: s.id, date: s.performedAt, reps: s.reps, index: nextIndex))
            nextIndex += 1
        }
        
        recentSetRows.insert(contentsOf: toPrepend.reversed(), at: 0)
        lastSetsCount = sets.count
    }
}
