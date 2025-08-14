import Foundation

protocol WorkoutDateMapper: Sendable {
    func formatDate(_ date: Date) -> String
    func formatDuration(_ duration: TimeInterval) -> String
}
