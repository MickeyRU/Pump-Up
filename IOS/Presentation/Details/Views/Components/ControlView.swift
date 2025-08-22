import SwiftUI

struct WorkoutControlView: View {
    @ObservedObject var vm: DetailViewModel

    var body: some View {
        VStack(spacing: 14) {
            // 1) Большая кнопка "Начать"
            if vm.workout.status == .notStarted {
                PrimaryActionButton(
                    title: "Начать тренировку",
                    systemImage: "play.fill",
                    action: { withAnimation(.spring) { vm.startWorkout() } }
                )
            }

            // 2) Карточка управления подходом
            ControlCard {
                HStack(spacing: 14) {
                    RepsDial(
                        title: "Повторы",
                        value: vm.repsForNextSet,
                        onMinus: vm.decrementReps,
                        onPlus: vm.incrementReps
                    )

                    AddSetBlock(
                        title: "Подход",
                        action: {
                            let rest = Int(vm.workout.planning.restTime)
                            withAnimation(.easeInOut) {
                                vm.addSetAndStartRest(seconds: rest)
                            }
                            haptic(.medium)
                        },
                        disabled: vm.workout.status != .inProgress || vm.isResting
                    )
                }
            }

            // 3) Капсула отдыха
            if vm.isResting {
                RestCapsule(
                    remaining: vm.restRemaining,
                    stopEarly: {
                        withAnimation(.easeInOut) { vm.stopRestEarly() }
                        haptic(.light)
                    }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // 4) Завершить тренировку
            Button(role: .destructive) {
                withAnimation(.spring) { vm.finishWorkout() }
                haptic(.soft)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "flag.checkered")
                    Text("Завершить")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.bordered)
            .disabled(vm.workout.status != .inProgress)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .animation(.easeInOut(duration: 0.2), value: vm.isResting)
    }

    // Лёгкие тактильные отклики
    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: style).impactOccurred()
        #endif
    }
}

// MARK: - Вспомогательные сабвью

/// Карточка с мягким фоном
private struct ControlCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(14)
        .statCardStyle()
    }
}

/// Крупная основная кнопка
private struct PrimaryActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                Text(title).fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

/// Циферблат повторов с круглыми кнопками
private struct RepsDial: View {
    let title: String
    let value: Int
    let onMinus: () -> Void
    let onPlus:  () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)

            HStack(spacing: 6) {
                RoundIconButton(systemName: "minus", action: onMinus)
                Text("\(value)")
                    .font(.title2.weight(.bold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(minWidth: 44)
                RoundIconButton(systemName: "plus", action: onPlus)
            }
        }
    }
}

private struct AddSetBlock: View {
    let title: String
    let action: () -> Void
    let disabled: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)

            Button {
                action()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Добавить сет")
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            .disabled(disabled)
        }
        .frame(maxWidth: .infinity)
    }
}

/// Круглая кнопка с иконкой (для +/-)
private struct RoundIconButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.headline)
                .frame(width: 44, height: 44)
                .background(Color(UIColor.tertiarySystemFill))
                .clipShape(Circle())
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

/// Компактная капсула отдыха
private struct RestCapsule: View {
    let remaining: Int
    let stopEarly: () -> Void

    private var timeText: String {
        let m = remaining / 60, s = remaining % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "timer")
                .imageScale(.large)

            VStack(alignment: .leading, spacing: 2) {
                Text("Отдых")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(timeText)
                    .font(.title3.weight(.bold))
                    .monospacedDigit()
            }

            Spacer(minLength: 8)

            Button("Закончить") { stopEarly() }
                .buttonStyle(.borderedProminent)
        }
        .padding(14)
        .statCardStyle()
    }
}
