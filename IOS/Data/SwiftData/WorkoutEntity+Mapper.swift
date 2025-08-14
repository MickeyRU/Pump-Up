import Foundation

extension WorkoutEntity {
    func toDomain() -> Workout {
        Workout(
            id: .init(raw: id),
            type: WorkoutType(rawValue: typeRaw) ?? .push_ups,
            startDate: startDate,
            status: WorkoutStatus(rawValue: statusRaw) ?? .notStarted,
            planning: .init(repeatsPerSet: repeatsPerSet, sets: plannedSets, restTime: restTime),
            endDate: endDate,
            sets: sets.map { .init(reps: $0.reps, restTime: $0.restTime) }
        )
    }
}
