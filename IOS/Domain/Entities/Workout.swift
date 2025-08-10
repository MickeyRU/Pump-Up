import Foundation

public struct WorkoutID: Sendable, Hashable {
    public let raw: UUID
    public init(raw: UUID) { self.raw = raw }
}

public struct Workout: Sendable, Identifiable {
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
