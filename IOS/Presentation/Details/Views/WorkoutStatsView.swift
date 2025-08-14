import SwiftUI

struct WorkoutStatsView: View {
    @Environment(\.workoutDateMapper) private var dateMapper
    
    let stats: WorkoutStats
    var plannedDuration: TimeInterval? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            ProgressCircleView(
                progress: stats.setsProgress,
                title: L10n.Workouts.sets(stats.totalSets),
                valueText: "\(stats.totalSets)/\(stats.plannedSets)",
                progressColor: .green
            )
            
            ProgressCircleView(
                progress: stats.repsProgress,
                title: L10n.Workouts.reps(stats.totalReps),
                valueText: "\(stats.totalReps)/\(stats.plannedReps)",
                progressColor: .orange
            )
            
            ProgressCircleView(
                progress: {
                    guard let plan = plannedDuration, plan > 0 else { return 0 }
                    return stats.currentDuration / plan
                }(),
                title: L10n.Workouts.time,
                valueText: dateMapper.formatDuration(stats.currentDuration),
                progressColor: .blue
            )
        }
    }
}
