import Foundation

public struct WorkoutStats: Sendable {
    public let totalReps: Int
    public let totalSets: Int
    public let plannedSets: Int
    public let totalRestTime: TimeInterval
    public let duration: TimeInterval
    public let progress: Double
}
