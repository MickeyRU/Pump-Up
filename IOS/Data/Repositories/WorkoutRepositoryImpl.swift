import SwiftData
import Foundation

@MainActor
final class WorkoutRepositoryImpl: WorkoutRepository {
    private let context: ModelContext
    private var observers: [UUID: AsyncStream<[Workout]>.Continuation] = [:]
    
    init(context: ModelContext) { self.context = context }
    
    func all() throws -> [Workout] {
        let entities = try context.fetch(FetchDescriptor<WorkoutEntity>())
        return entities.map { $0.toDomain() }
    }
    
    func observeAll() -> AsyncStream<[Workout]> {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            Task { @MainActor in
                let id = UUID()
                observers[id] = continuation

                let current = (try? all()) ?? []
                continuation.yield(current)

                continuation.onTermination = { [weak self] _ in
                    Task { @MainActor in
                        self?.observers.removeValue(forKey: id)
                    }
                }
            }
        }
    }
    
    func save(_ workout: Workout) throws {
        let all = try context.fetch(FetchDescriptor<WorkoutEntity>())
        if let existing = all.first(where: { $0.id == workout.id.raw }) {
            existing.typeRaw       = workout.type.rawValue
            existing.startDate     = workout.startDate
            existing.statusRaw     = workout.status.rawValue
            existing.repeatsPerSet = workout.planning.repeatsPerSet
            existing.plannedSets   = workout.planning.sets
            existing.restTime      = workout.planning.restTime
            existing.endDate       = workout.endDate
            existing.sets          = workout.sets.map { WorkoutSetRecord(reps: $0.reps, restTime: $0.restTime) }
        } else {
            context.insert(WorkoutEntity(from: workout))
        }
        try context.save()
        notifyObservers()
    }
    
    func delete(_ workout: Workout) throws {
        let all = try context.fetch(FetchDescriptor<WorkoutEntity>())
        if let entity = all.first(where: { $0.id == workout.id.raw }) {
            context.delete(entity)
            try context.save()
            notifyObservers()
        }
    }
    
    private func notifyObservers() {
        let items = (try? all()) ?? []
        for c in observers.values { c.yield(items) }
    }
}
