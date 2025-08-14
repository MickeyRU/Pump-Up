import Foundation

enum L10n {
    enum Workouts {
        static func sets(_ count: Int) -> String {
            String.localizedStringWithFormat(
                String(localized: "%lld sets", table: "Workouts", comment: "Количество подходов"),
                count
            )
        }
        
        static func reps(_ count: Int) -> String {
            String.localizedStringWithFormat(
                String(localized: "%lld reps", table: "Workouts", comment: "Количество повторений"),
                count
            )
        }
        
        static var today: String {
            String(localized: "workout.date.today", table: "Workouts", comment: "Сегодня")
        }
        
        static var time: String {
            String(localized: "workout.time", table: "Workouts", comment: "Время")
        }
    }
}
