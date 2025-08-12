import Foundation

extension WorkoutType {
    var displayName: String {
        switch self {
        case .push_ups: "Отжимания"
        case .pull_ups: "Подтягивания"
        }
    }
    
    var iconName: String {
        switch self {
        case .push_ups: "push_ups_icon"
        case .pull_ups: "pull_ups_icon"
        }
    }
}
