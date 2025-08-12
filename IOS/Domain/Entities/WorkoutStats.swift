import Foundation

public struct WorkoutStats: Sendable {
    public let totalReps: Int
    public let totalSets: Int
    public let plannedSets: Int
    public let duration: TimeInterval // длительность ТОЛЬКО завершённых
    public let progress: Double
}


public extension WorkoutStats {
    func withDuration(_ duration: TimeInterval) -> WorkoutStats {
        .init(
            totalReps: totalReps,
            totalSets: totalSets,
            plannedSets: plannedSets,
            duration: duration,
            progress: progress
        )
    }
}
