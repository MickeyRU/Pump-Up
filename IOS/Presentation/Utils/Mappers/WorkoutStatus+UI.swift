import SwiftUI

extension WorkoutStatus {
    var displayName: String {
        switch self {
        case .notStarted: "Не начата"
        case .inProgress: "В процессе"
        case .completed: "Завершена"
        }
    }
    
    var color: Color {
        switch self {
        case .notStarted: .gray
        case .inProgress: .orange
        case .completed: .green
        }
    }
}
