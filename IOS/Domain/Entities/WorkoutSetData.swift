import Foundation

struct WorkoutSetData: Sendable, Identifiable {
    let id: UUID
    let reps: Int
    let restTime: TimeInterval
    let performedAt: Date
}

extension WorkoutSetData {
    init(reps: Int, restTime: TimeInterval, performedAt: Date = .now, id: UUID = .init()) {
        self.id = id
        self.reps = reps
        self.restTime = restTime
        self.performedAt = performedAt
    }
}
