import SwiftData
import Foundation

@Model
final class WorkoutEntity {
    @Attribute(.unique) var id: UUID
    var typeRaw: String
    var startDate: Date?
    var statusRaw: String
    var repeatsPerSet: Int
    var plannedSets: Int
    var restTime: TimeInterval
    var endDate: Date?
    var sets: [WorkoutSetRecord]

    init(from domain: Workout) {
        self.id = domain.id.raw
        self.typeRaw = domain.type.rawValue
        self.startDate = domain.startDate
        self.statusRaw = domain.status.rawValue
        self.repeatsPerSet = domain.planning.repeatsPerSet
        self.plannedSets = domain.planning.sets
        self.restTime = domain.planning.restTime
        self.endDate = domain.endDate
        self.sets = domain.sets.map {
            WorkoutSetRecord(
                id: $0.id,
                reps: $0.reps,
                restTime: $0.restTime,
                performedAt: $0.performedAt
            )
        }
    }
}

struct WorkoutSetRecord: Codable {
    var id: UUID
    var reps: Int
    var restTime: TimeInterval
    var performedAt: Date

    init(id: UUID, reps: Int, restTime: TimeInterval, performedAt: Date) {
        self.id = id
        self.reps = reps
        self.restTime = restTime
        self.performedAt = performedAt
    }
}
