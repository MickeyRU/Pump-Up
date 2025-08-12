import Foundation

protocol WorkoutDateMapper: Sendable {
    func format(_ date: Date, now: Date, locale: Locale) -> String
}

extension WorkoutDateMapper {
    func format(_ date: Date) -> String {
        format(date, now: .now, locale: .current)
    }
}
