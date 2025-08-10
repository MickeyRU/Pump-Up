import Foundation

public struct WorkoutPeriodStats: Sendable {
    public let period: WorkoutStatsPeriod // .week, .month, .year, .allTime
    public let totalWorkouts: Int
    public let totalReps: Int
    public let totalDuration: TimeInterval
    public let averageRepsPerWorkout: Double
}
