import Foundation

struct DefaultWorkoutDateMapper: WorkoutDateMapper {
    func format(_ date: Date, now: Date, locale: Locale) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) {
            let time = date.formatted(.dateTime.hour().minute().locale(locale))
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
                    .locale(locale)
            )
        }
    }
}
