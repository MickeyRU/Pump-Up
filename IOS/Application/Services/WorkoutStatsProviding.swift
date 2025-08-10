import Foundation

public protocol WorkoutStatsProviding: Sendable {
    // По одной тренировке
    func stats(for workout: Workout) -> WorkoutStats

    // Агрегации по массиву тренировок
    func aggregate(for workouts: [Workout]) -> WorkoutStats          // сводка по набору (напр., экран "итоги дня")
    func periodStats(for workouts: [Workout],
                     period: WorkoutStatsPeriod,
                     now: Date,
                     calendar: Calendar) -> WorkoutPeriodStats

    func typeStats(for workouts: [Workout]) -> [WorkoutTypeStats]

    /// Кол-во тренировок по дням за последние `days` (включая сегодня).
    /// Ключ — полночь дня в текущем календаре.
    func workoutsPerLastDays(_ days: Int,
                             workouts: [Workout],
                             now: Date,
                             calendar: Calendar) -> [(date: Date, count: Int)]

    // Async/helpers (параллельная агрегация больших наборов)
    func statsAsync(for workout: Workout) async -> WorkoutStats
    func aggregateAsync(for workouts: [Workout]) async -> WorkoutStats
    func typeStatsAsync(for workouts: [Workout]) async -> [WorkoutTypeStats]
}
