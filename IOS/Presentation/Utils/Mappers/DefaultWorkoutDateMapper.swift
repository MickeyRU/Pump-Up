import Foundation

struct DefaultWorkoutDateMapper: WorkoutDateMapper {
    func formatDate(_ date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) {
            let time = date.formatted(.dateTime.hour().minute().locale(.current))
            let today = L10n.Workouts.today
            return "\(today) \(time)"
        } else {
            return date.formatted(
                .dateTime
                    .day(.twoDigits)
                    .month(.twoDigits)
                    .year(.twoDigits)
                    .hour()
                    .minute()
                    .locale(.current)
            )
        }
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = duration >= 3600 ? [.hour, .minute] : [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.unitsStyle = .positional
        return formatter.string(from: max(0, duration)) ?? "0:00"
    }
}
