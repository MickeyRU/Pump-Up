import SwiftUI
import SwiftData

struct StatisticsView: View {
//    @Query private var workouts: [Workout]
//    @State private var selectedTimeRange: TimeRange = .week
//    
//    enum TimeRange: String, CaseIterable {
//        case week = "Неделя"
//        case month = "Месяц"
//        case year = "Год"
//        case all = "Все время"
//        
//        var days: Int {
//            switch self {
//            case .week: return 7
//            case .month: return 30
//            case .year: return 365
//            case .all: return Int.max
//            }
//        }
//    }
//    
//    var filteredWorkouts: [Workout] {
//        let cutoffDate = Calendar.current.date(byAdding: .day, value: -selectedTimeRange.days, to: Date()) ?? Date()
//        return workouts.filter { workout in
//            selectedTimeRange == .all || workout.startDate >= cutoffDate
//        }
//    }
   
    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Фильтр по времени
//                    Picker("Период", selection: $selectedTimeRange) {
//                        ForEach(TimeRange.allCases, id: \.self) { range in
//                            Text(range.rawValue).tag(range)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    .padding(.horizontal)
//                    
//                    // Общая статистика
//                    LazyVGrid(columns: [
//                        GridItem(.flexible()),
//                        GridItem(.flexible())
//                    ], spacing: 16) {
//                        StatCard(
//                            title: "Тренировок",
//                            value: "\(filteredWorkouts.count)",
//                            icon: "figure.strengthtraining.traditional",
//                            color: .blue
//                        )
//                        
//                        StatCard(
//                            title: "Всего повторов",
//                            value: "58888",
//                            icon: "number.circle.fill",
//                            color: .green
//                        )
//                        
//                        StatCard(
//                            title: "Время тренировок",
//                            value: "65555",
//                            icon: "clock.fill",
//                            color: .orange
//                        )
//                        
//                        StatCard(
//                            title: "Среднее за тренировку",
//                            value: "72",
//                            icon: "chart.bar.fill",
//                            color: .purple
//                        )
//                    }
//                    .padding(.horizontal)
//                    
//                    // Статистика по типам
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("По типам тренировок")
//                            .font(.headline)
//                            .padding(.horizontal)
//                        
//                        ForEach(WorkoutType.allCases, id: \.self) { type in
//                            WorkoutTypeStatRow(
//                                type: type,
//                                workouts: filteredWorkouts.filter { $0.type == type }
//                            )
//                        }
//                    }
//                    
//                    // График активности
//                    if !filteredWorkouts.isEmpty {
//                        VStack(alignment: .leading, spacing: 12) {
//                            Text("Активность")
//                                .font(.headline)
//                                .padding(.horizontal)
//                            
//                            ActivityChart(workouts: filteredWorkouts)
//                                .frame(height: 200)
//                                .padding(.horizontal)
//                        }
//                    }
//                    
//                    // Последние тренировки
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Последние тренировки")
//                            .font(.headline)
//                            .padding(.horizontal)
//                        
//                        ForEach(Array(filteredWorkouts.prefix(5).enumerated()), id: \.offset) { index, workout in
//                            NavigationLink {
//                                WorkoutDetailView(workout: workout)
//                            } label: {
//                                RecentWorkoutRow(workout: workout)
//                            }
//                            .buttonStyle(.plain)
//                        }
//                    }
//                }
//                .padding(.vertical)
//            }
//            .navigationTitle("Статистика")
//        }
    }
    
//    private var averageRepsPerWorkout: Double {
//        guard !filteredWorkouts.isEmpty else { return 0 }
//        let totalReps = 130
//        return Double(totalReps) / Double(filteredWorkouts.count)
//    }
}

//struct WorkoutTypeStatRow: View {
//    let type: WorkoutType
//    let workouts: [Workout]
//    
//    var body: some View {
//        HStack {
//            Image(systemName: type.iconName)
//                .foregroundColor(.orange)
//                .frame(width: 30)
//            
//            VStack(alignment: .leading) {
//                Text(type.displayName)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                
//                Text("\(workouts.count) тренировок")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//            
//            VStack(alignment: .trailing) {
//                Text("158")
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                
//                Text("повторов")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//        .background(Color(.systemGray6))
//        .cornerRadius(8)
//        .padding(.horizontal)
//    }
//}
//
//struct RecentWorkoutRow: View {
//    let workout: Workout
//    
//    var body: some View {
//        HStack {
//            Image(systemName: workout.type.iconName)
//                .foregroundColor(.orange)
//                .frame(width: 30)
//            
//            VStack(alignment: .leading) {
//                Text(workout.type.displayName)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                
//                Text(workout.startDate.formatted(date: .abbreviated, time: .shortened))
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//            
//            VStack(alignment: .trailing) {
//                Text("1977")
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                
//                Text("повторов")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//        .background(Color(.systemGray6))
//        .cornerRadius(8)
//        .padding(.horizontal)
//    }
//}
//
//struct ActivityChart: View {
//    let workouts: [Workout]
//    
//    var body: some View {
//        // Простая визуализация активности
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Тренировки за последние 7 дней")
//                .font(.caption)
//                .foregroundColor(.secondary)
//            
//            HStack(alignment: .bottom, spacing: 4) {
//                ForEach(0..<7, id: \.self) { dayOffset in
//                    let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
//                    let dayWorkouts = workouts.filter { workout in
//                        Calendar.current.isDate(workout.startDate, inSameDayAs: date)
//                    }
//                    
//                    VStack {
//                        Text("\(dayWorkouts.count)")
//                            .font(.caption2)
//                            .fontWeight(.medium)
//                        
//                        Rectangle()
//                            .fill(dayWorkouts.isEmpty ? Color.gray.opacity(0.3) : Color.orange)
//                            .frame(height: CGFloat(dayWorkouts.count) * 10 + 10)
//                            .cornerRadius(2)
//                        
//                        Text(dayLabel(for: date))
//                            .font(.caption2)
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(radius: 2)
//    }
//    
//    private func dayLabel(for date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "E"
//        formatter.locale = Locale(identifier: "ru_RU")
//        return formatter.string(from: date).prefix(2).uppercased()
//    }
//}

#Preview {
    StatisticsView()
        .modelContainer(for: [WorkoutEntity.self], inMemory: true)
}
