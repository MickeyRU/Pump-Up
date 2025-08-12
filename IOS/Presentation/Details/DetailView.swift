import SwiftUI

struct DetailView: View {
    @Environment(\.workoutDateMapper) private var dateMapper
    @Environment(\.workoutStatsProvider) private var statsProvider
    
    @StateObject private var vm: DetailViewModel

    init(workout: Workout, ucs: WorkoutUseCases,) {
        _vm = StateObject(
            wrappedValue: DetailViewModel(
                workout: workout,
                ucs: ucs,
                statsProvider: WorkoutStatsService()
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerSection
                controlSection
                statsSection
                setsSection
            }
            .padding()
        }
        .navigationTitle("Детали тренировки")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { /* vm уже стартует сам, если нужно — можно дернуть refresh */ }
    }

    // MARK: - Sections

    private var headerSection: some View {
        HStack(spacing: 12) {
            Image(vm.workout.type.iconName)
                .resizable().scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(vm.workout.type.displayName)
                    .font(.title3).bold().lineLimit(1)

                Text(headerDateText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            StatusBadge(status: vm.workout.status)
                .fixedSize()
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var controlSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Управление").font(.headline)
                Spacer()
            }

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
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            HStack(spacing: 12) {
                Stepper("Повторы: \(vm.repsForNextSet)", value: $vm.repsForNextSet, in: 1...500)
                Button {
                    vm.performSet()
                } label: {
                    Label("Подход", systemImage: "dumbbell.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!vm.canDoSet)
            }

            HStack {
                Button { vm.startWorkout() } label: {
                    Label("Начать", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!vm.canStart)

                Spacer(minLength: 12)

                Button(role: .destructive) { vm.finishWorkout() } label: {
                    Label("Завершить", systemImage: "stop.fill")
                }
                .buttonStyle(.bordered)
                .disabled(!vm.canFinish)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 1)
    }

    private var statsSection: some View {
        VStack(spacing: 10) {
            // одна строка
            Text("Подходы: \(vm.stats.totalSets) • Повторы: \(vm.stats.totalReps) • Время: \(vm.stats.duration.formattedHMS)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // прогресс
            VStack(spacing: 6) {
                ProgressView(value: vm.progress)
                    .progressViewStyle(.linear)
                Text("\(Int(vm.progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var setsSection: some View {
        Group {
            if vm.workout.sets.isEmpty {
                EmptyView()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Детали подходов").font(.headline)

                    ForEach(Array(vm.workout.sets.enumerated()), id: \.offset) { i, set in
                        HStack {
                            Text("Подход \(i + 1)")
                            Spacer()
                            Text("\(set.reps) повторов • отдых \(Int(set.restTime))с")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Helpers

    private var headerDateText: String {
        if vm.workout.status == .completed, let end = vm.workout.endDate {
            return dateMapper.format(end)
        } else {
            return dateMapper.format(vm.workout.startDate)
        }
    }
}

private extension TimeInterval {
    var formattedHMS: String {
        let t = Int(self)
        let h = t / 3600
        let m = (t % 3600) / 60
        let s = t % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, s)
                     : String(format: "%d:%02d", m, s)
    }
}
