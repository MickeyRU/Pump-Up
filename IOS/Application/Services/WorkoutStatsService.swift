import Foundation

public struct WorkoutStatsService: WorkoutStatsProviding, Sendable {
    public init() {}

    public func stats(for w: Workout) -> WorkoutStats {
        let totalSets = w.sets.count
        let totalReps = w.sets.reduce(0) { $0 + $1.reps }
        let planned   = w.planning.sets
        let progress  = planned > 0 ? Double(totalSets) / Double(planned) : 0

        // фиксированная длительность только для завершённых
        let duration: TimeInterval = {
            if let end = w.endDate { return end.timeIntervalSince(w.startDate) }
            return 0
        }()

        return WorkoutStats(
            totalReps: totalReps,
            totalSets: totalSets,
            plannedSets: planned,
            duration: duration,
            progress: progress
        )
    }

    public func aggregate(for workouts: [Workout]) -> WorkoutStats {
        var reps = 0, sets = 0, planned = 0
        var duration: TimeInterval = 0

        for w in workouts {
            reps += w.sets.reduce(0) { $0 + $1.reps }
            sets += w.sets.count
            planned += w.planning.sets
            if let end = w.endDate { duration += end.timeIntervalSince(w.startDate) }
        }
        let progress = planned > 0 ? Double(sets) / Double(planned) : 0

        return WorkoutStats(
            totalReps: reps,
            totalSets: sets,
            plannedSets: planned,
            duration: duration,
            progress: progress
        )
    }

    public func periodStats(for workouts: [Workout],
                            period: WorkoutStatsPeriod,
                            now: Date,
                            calendar: Calendar) -> WorkoutPeriodStats {
        let range = dateRange(for: period, now: now, calendar: calendar)
        let filtered = workouts.filter { $0.startDate >= range.lowerBound && $0.startDate <= range.upperBound }

        let agg = aggregate(for: filtered)
        let totalWorkouts = filtered.count
        let averageRepsPerWorkout = totalWorkouts > 0 ? Double(agg.totalReps) / Double(totalWorkouts) : 0

        return WorkoutPeriodStats(
            period: period,
            totalWorkouts: totalWorkouts,
            totalReps: agg.totalReps,
            totalDuration: agg.duration,
            averageRepsPerWorkout: averageRepsPerWorkout
        )
    }

    public func typeStats(for workouts: [Workout]) -> [WorkoutTypeStats] {
        var dict: [WorkoutType: (count: Int, reps: Int)] = [:]
        for w in workouts {
            let reps = w.sets.reduce(0) { $0 + $1.reps }
            let prev = dict[w.type] ?? (0, 0)
            dict[w.type] = (prev.count + 1, prev.reps + reps)
        }
        return dict.map { (type, agg) in
            WorkoutTypeStats(type: type, totalWorkouts: agg.count, totalReps: agg.reps)
        }
        .sorted { $0.type.rawValue < $1.type.rawValue }
    }

    public func workoutsPerLastDays(_ days: Int,
                                    workouts: [Workout],
                                    now: Date,
                                    calendar: Calendar) -> [(date: Date, count: Int)] {
        precondition(days > 0)

        var buckets: [Date: Int] = [:]
        for i in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: now) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            buckets[dayStart] = 0
        }

        for w in workouts {
            let day = calendar.startOfDay(for: w.startDate)
            if buckets[day] != nil { buckets[day]! += 1 }
        }

        return buckets.keys.sorted().map { ($0, buckets[$0] ?? 0) }
    }

    public func statsAsync(for w: Workout) async -> WorkoutStats {
        await Task.detached(priority: .utility) { stats(for: w) }.value
    }

    public func aggregateAsync(for workouts: [Workout]) async -> WorkoutStats {
        await Task.detached(priority: .utility) { aggregate(for: workouts) }.value
    }

    public func typeStatsAsync(for workouts: [Workout]) async -> [WorkoutTypeStats] {
        await Task.detached(priority: .utility) { typeStats(for: workouts) }.value
    }

    private func dateRange(for period: WorkoutStatsPeriod,
                           now: Date,
                           calendar: Calendar) -> ClosedRange<Date> {
        switch period {
        case .allTime:
            return Date.distantPast...Date.distantFuture
        case .week:
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let end = calendar.date(byAdding: .day, value: 7, to: start)!.addingTimeInterval(-1)
            return start...end
        case .month:
            let comps = calendar.dateComponents([.year, .month], from: now)
            let start = calendar.date(from: comps)!
            let end = calendar.date(byAdding: .month, value: 1, to: start)!.addingTimeInterval(-1)
            return start...end
        case .year:
            let comps = calendar.dateComponents([.year], from: now)
            let start = calendar.date(from: comps)!
            let end = calendar.date(byAdding: .year, value: 1, to: start)!.addingTimeInterval(-1)
            return start...end
        }
    }
}
