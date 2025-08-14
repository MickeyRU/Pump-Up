import Foundation

struct Workout: Sendable, Identifiable {
    let id: WorkoutID
    let type: WorkoutType
    private(set) var startDate: Date?
    private(set) var endDate: Date?
    private(set) var status: WorkoutStatus
    let planning: WorkoutPlanData
    private(set) var sets: [WorkoutSetData]
    
    init(id: WorkoutID = WorkoutID(raw: UUID()),
         type: WorkoutType,
         startDate: Date? = nil,
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
    
    mutating func start(at date: Date = .now) {
        guard status == .notStarted else { return }
        status = .inProgress
        startDate = date
    }
    
    mutating func addSet(_ set: WorkoutSetData) {
        guard status == .inProgress else { return }
        sets.append(set)
    }
    
    mutating func finish() {
        guard status == .inProgress else { return }
        status = .completed
        endDate = .now
    }
}
