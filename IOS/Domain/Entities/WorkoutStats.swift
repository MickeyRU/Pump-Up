import Foundation

struct WorkoutStats: Sendable {
    let totalReps: Int
    let totalSets: Int
    let plannedReps: Int
    let plannedSets: Int
    let currentDuration: TimeInterval
    let repsProgress: Double
    let setsProgress: Double
}
