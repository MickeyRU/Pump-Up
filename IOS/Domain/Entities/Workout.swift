import Foundation

public struct WorkoutID: Hashable, Codable {
    public let raw: UUID
    public init(raw: UUID) { self.raw = raw }
}

public struct Workout {
    public var id: WorkoutID
    public var type: WorkoutType
    public var startDate: Date
    public var endDate: Date?
    public var status: WorkoutStatus
    public var planning: WorkoutPlanData
    public var sets: [WorkoutSetData]
    
    public init(id: WorkoutID = WorkoutID(raw: UUID()),
                type: WorkoutType,
                startDate: Date = .now,
                status: WorkoutStatus = .notStarted,
                planning: WorkoutPlanData,
                endDate: Date? = nil,
                sets: [WorkoutSetData] = []) {
        self.id = id
        self.type = type
        self.startDate = startDate
        self.status = status
        self.planning = planning
        self.endDate = endDate
        self.sets = sets
    }
    
    public mutating func addSet(_ set: WorkoutSetData) { sets.append(set) }
    public mutating func updateStatus(_ newStatus: WorkoutStatus) {
        status = newStatus
        if newStatus == .completed { endDate = .now }
    }
}

public struct WorkoutPlanData: Codable {
    public var repeatsPerSet: Int
    public var sets: Int
    public var restTime: TimeInterval
}

public struct WorkoutSetData: Codable {
    public var reps: Int
    public var restTime: TimeInterval
}

public enum WorkoutStatus: String, Codable { case notStarted, inProgress, completed }

public enum WorkoutType: String, Codable, CaseIterable { case push_ups, pull_ups }
