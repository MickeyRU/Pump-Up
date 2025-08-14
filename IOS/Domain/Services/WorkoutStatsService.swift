import Foundation

protocol WorkoutStatsProviding: Sendable {
    func getStats(for w: Workout) -> WorkoutStats
}

struct WorkoutStatsService: WorkoutStatsProviding, Sendable {
    func getStats(for w: Workout) -> WorkoutStats {
        let tReps = w.sets.reduce(0) { $0 + $1.reps }
        let tSets = w.sets.count
        let pReps = w.planning.sets * w.planning.repeatsPerSet
        let pSets = w.planning.sets
        
        let endOrNow = w.endDate ?? Date()
        let start = w.startDate ?? endOrNow
        let cDuration = max(0, endOrNow.timeIntervalSince(start))
        
        let repsProgress = pReps > 0 ? Double(tReps) / Double(pReps) : 0
        let setsProgress = pSets > 0 ? Double(tSets) / Double(pSets) : 0
        
        return WorkoutStats(
            totalReps: tReps,
            totalSets: tSets,
            plannedReps: pReps,
            plannedSets: pSets,
            currentDuration: cDuration,
            repsProgress: repsProgress,
            setsProgress: setsProgress
        )
    }
}
