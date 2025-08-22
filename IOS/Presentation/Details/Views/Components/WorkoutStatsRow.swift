import SwiftUI

struct WorkoutStatsRow: View {
    @Environment(\.workoutDateMapper) private var dateMapper

    let stats: WorkoutStats
    var plannedDuration: TimeInterval? = nil

    var body: some View {
        HStack(spacing: 12) {
            ForEach(items, id: \.title) { item in
                WorkoutStatItem(
                    progress: item.progress,
                    title: item.title,
                    valueText: item.valueText,
                    tint: item.tint
                )
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var items: [StatItem] {
        let sets = StatItem(
            progress: stats.setsProgress,
            title: L10n.Workouts.sets(stats.totalSets),
            valueText: "\(stats.totalSets)/\(stats.plannedSets)",
            tint: .green
        )
        let reps = StatItem(
            progress: stats.repsProgress,
            title: L10n.Workouts.reps(stats.totalReps),
            valueText: "\(stats.totalReps)/\(stats.plannedReps)",
            tint: .orange
        )
        let time: StatItem = {
            guard let plan = plannedDuration, plan > 0 else {
                return StatItem(progress: 0, title: L10n.Workouts.time,
                                valueText: dateMapper.formatDuration(stats.currentDuration),
                                tint: .blue)
            }
            return StatItem(progress: stats.currentDuration / plan,
                            title: L10n.Workouts.time,
                            valueText: dateMapper.formatDuration(stats.currentDuration),
                            tint: .blue)
        }()
        return [sets, reps, time]
    }
}

private struct StatItem: Hashable {
    let progress: Double
    let title: String
    let valueText: String
    let tint: Color
}
