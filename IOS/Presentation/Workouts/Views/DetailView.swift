import SwiftUI

struct DetailView: View {
    @StateObject private var vm: DetailViewModel

    init(
        workout: Workout,
        startUC: StartWorkoutUseCase,
        addSetUC: AddSetUseCase,
        completeUC: CompleteWorkoutUseCase
    ) {
        _vm = StateObject(wrappedValue: DetailViewModel(
            workout: workout,
            startUC: startUC,
            addSetUC: addSetUC,
            completeUC: completeUC
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Image(systemName: vm.workout.type.iconName)
                        .font(.title)
                        .foregroundColor(.orange)

                    VStack(alignment: .leading) {
                        Text(vm.workout.type.displayName)
                            .font(.title3).bold()
                        Text(vm.workout.startDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption).foregroundColor(.secondary)
                    }

                    Spacer()
                    StatusBadge(status: vm.workout.status)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Статистика
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    StatCard(title: "Подходы", value: "\(vm.completedSets)/\(vm.workout.planning.sets)", icon: "number.circle.fill", color: .blue)
                    StatCard(title: "Всего повторов", value: "\(vm.totalReps)", icon: "figure.strengthtraining.traditional", color: .green)
                    StatCard(title: "Среднее за подход", value: String(format: "%.1f", vm.averageReps), icon: "chart.bar.fill", color: .orange)
                    StatCard(title: "Время тренировки", value: vm.duration.formattedDuration, icon: "clock.fill", color: .purple)
                }

                if vm.totalRestTime > 0 {
                    StatCard(title: "Общее время отдыха",
                             value: vm.totalRestTime.formattedDuration,
                             icon: "pause.circle.fill",
                             color: .gray)
                        .padding(.horizontal)
                }

                // Прогресс
                VStack(alignment: .leading, spacing: 8) {
                    Text("Прогресс").font(.headline)
                    ProgressView(value: vm.progress)
                        .progressViewStyle(.linear)
                    Text("\(Int(vm.progress * 100))% завершено")
                        .font(.caption).foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Управление тренировкой
                controlSection

                // Детали подходов
                if !vm.workout.sets.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Детали подходов").font(.headline)
                        ForEach(Array(vm.workout.sets.enumerated()), id: \.offset) { idx, set in
                            HStack {
                                Text("Подход \(idx + 1)")
                                Spacer()
                                Text("\(set.reps) повторов")
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Детали тренировки")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var controlSection: some View {
        VStack(spacing: 12) {
            // состояние отдыха
            if vm.isResting {
                VStack(spacing: 6) {
                    Text("Отдых").font(.headline)
                    Text(vm.restRemainingString)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                    Button {
                        vm.skipRest()
                    } label: {
                        Label("Пропустить отдых", systemImage: "forward.fill")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            // управление подходом
            HStack(spacing: 12) {
                Stepper("Повторы: \(vm.repsForNextSet)", value: $vm.repsForNextSet, in: 1...200)
                Spacer()
                Button {
                    vm.performSet()
                } label: {
                    Label("Сделать подход", systemImage: "dumbbell.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!vm.canDoSet)
            }

            // старт/финиш
            HStack {
                Button {
                    vm.startWorkout()
                } label: {
                    Label("Начать", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!vm.canStart)

                Spacer()

                Button(role: .destructive) {
                    vm.finishWorkout()
                } label: {
                    Label("Завершить", systemImage: "stop.fill")
                }
                .buttonStyle(.bordered)
                .disabled(!vm.canFinish)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}


struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.title2).foregroundColor(color)
            Text(value).font(.title2).fontWeight(.bold)
            Text(title).font(.caption).foregroundColor(.secondary).multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

struct StatusBadge: View {
    let status: WorkoutStatus
    var body: some View {
        Text(status.displayName)
            .font(.caption).fontWeight(.medium)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

extension TimeInterval {
    var formattedDuration: String {
        let m = Int(self) / 60
        let s = Int(self) % 60
        return m > 0 ? String(format: "%d:%02d", m, s) : String(format: "%dс", s)
    }
}
