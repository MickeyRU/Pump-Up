import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    let workout: Workout

    private var totalReps: Int {
        workout.sets.map { $0.reps }.reduce(0, +)
    }

    private var averageRepsPerSet: Double {
        guard !workout.sets.isEmpty else { return 0 }
        return Double(totalReps) / Double(workout.sets.count)
    }

    private var totalRestTime: TimeInterval {
        workout.sets.map { $0.restTime }.reduce(0, +)
    }

    private var duration: TimeInterval {
        guard let end = workout.endDate else { return 0 }
        return end.timeIntervalSince(workout.startDate)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                WorkoutHeader(workout: workout)
                WorkoutStatsGrid(
                    setsCount: workout.sets.count,
                    plannedSets: workout.planning.sets,
                    totalReps: totalReps,
                    averageReps: averageRepsPerSet,
                    duration: duration
                )
                
                if totalRestTime > 0 {
                    StatCard(
                        title: "Общее время отдыха",
                        value: totalRestTime.formattedDuration,
                        icon: "pause.circle.fill",
                        color: .gray
                    )
                    .padding(.horizontal)
                }

                WorkoutProgressSection(progress: 99.47)

                if !workout.sets.isEmpty {
                    WorkoutSetsDetail(sets: workout.sets)
                }
            }
            .padding()
        }
        .navigationTitle("Детали тренировки")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WorkoutHeader: View {
    let workout: Workout

    var body: some View {
        HStack {
            Image(systemName: workout.type.iconName)
                .font(.title)
                .foregroundColor(.orange)

            VStack(alignment: .leading) {
                Text(workout.type.displayName)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(workout.startDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            StatusBadge(status: workout.status)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WorkoutStatsGrid: View {
    let setsCount: Int
    let plannedSets: Int
    let totalReps: Int
    let averageReps: Double
    let duration: TimeInterval

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(title: "Подходы", value: "\(setsCount)/\(plannedSets)", icon: "number.circle.fill", color: .blue)
            StatCard(title: "Всего повторов", value: "\(totalReps)", icon: "figure.strengthtraining.traditional", color: .green)
            StatCard(title: "Среднее за подход", value: String(format: "%.1f", averageReps), icon: "chart.bar.fill", color: .orange)
            StatCard(title: "Время тренировки", value: duration.formattedDuration, icon: "clock.fill", color: .purple)
        }
    }
}

struct WorkoutProgressSection: View {
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Прогресс")
                .font(.headline)

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .orange))

            Text("\(Int(progress * 100))% завершено")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WorkoutSetsDetail: View {
    let sets: [WorkoutSetData]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Детали подходов")
                .font(.headline)

            ForEach(Array(sets.enumerated()), id: \.offset) { index, set in
                SetDetailRow(set: set, setNumber: index + 1)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct StatusBadge: View {
    let status: WorkoutStatus
    
    var body: some View {
        Text(status.displayName)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

struct SetDetailRow: View {
    let set: WorkoutSetData
    let setNumber: Int
    
    var body: some View {
        HStack {
            Text("Подход \(setNumber)")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("999999 повторов")
                    .font(.subheadline)
                
                Text("9494949 nhfnfnf")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

extension WorkoutStatus {
    var displayName: String {
        switch self {
        case .notStarted:
            return "Не начата"
        case .inProgress:
            return "В процессе"
        case .completed:
            return "Завершена"
        }
    }
    
    var color: Color {
        switch self {
        case .notStarted:
            return .gray
        case .inProgress:
            return .orange
        case .completed:
            return .green
        }
    }
}

extension TimeInterval {
    var formattedDuration: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "%dс", seconds)
        }
    }
}

#Preview {
    let plan = WorkoutPlanData(repeatsPerSet: 10, sets: 3, restTime: 60)
    let workout1 = Workout(type: .push_ups, planning: plan)
    
    WorkoutDetailView(workout: workout1)
}
