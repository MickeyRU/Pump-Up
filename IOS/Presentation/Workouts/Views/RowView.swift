import SwiftUI

struct RowView: View {
    let workout: Workout

    var body: some View {
        HStack(spacing: 20) {
            Image(workout.type.iconName)
                .resizable()
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.type.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack {
                    Text("\(workout.sets.count)/\(workout.planning.sets) подходы")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                StatusBadge(status: workout.status)

                if let endDate = workout.endDate {
                    Text(endDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let plan = WorkoutPlanData(repeatsPerSet: 10, sets: 3, restTime: 60)

    let workout1 = Workout(type: .push_ups, planning: plan)
    let workout2 = Workout(type: .pull_ups, planning: plan)

    List {
        RowView(workout: workout1)
        RowView(workout: workout2)
    }
}
