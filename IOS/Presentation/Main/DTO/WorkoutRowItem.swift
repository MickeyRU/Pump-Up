import Foundation

// DTO
struct WorkoutRowItem: Identifiable {
    let id: WorkoutID
    let iconName: String
    let title: String
    let setsCompleted: Int
    let totalReps: Int
    let setsPlanned: Int      
    let endDate: Date?
    let status: WorkoutStatus
}
