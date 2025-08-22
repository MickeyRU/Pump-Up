import SwiftData
import Foundation

enum WorkoutRepoError: LocalizedError {
    case notFound
    var errorDescription: String? {
        switch self { case .notFound: return "Workout not found" }
    }
}

@MainActor
final class WorkoutRepositoryImpl: WorkoutRepository {
    private let context: ModelContext
    private var observers: [UUID: AsyncStream<[Workout]>.Continuation] = [:]
    
    init(context: ModelContext) {
        self.context = context
        
        // Любые сохранения контекста (включая CloudKit-мерджи) — пушим новое состояние стримам
        NotificationCenter.default.addObserver(
            forName: ModelContext.didSave,
            object: context,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.notifyObservers()
            }
        }
    }
    
    // MARK: CRUD
    
    func loadAll() async throws -> [Workout] {
        try context.fetch(FetchDescriptor<WorkoutEntity>()).map { $0.toDomain() }
    }
    
    func load(_ id: WorkoutID) async throws -> Workout {
        let all = try context.fetch(FetchDescriptor<WorkoutEntity>())
        guard let entity = all.first(where: { $0.id == id.raw }) else {
            throw WorkoutRepoError.notFound
        }
        return entity.toDomain()
    }
    
    nonisolated func observeAll() -> AsyncStream<[Workout]> {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            Task { @MainActor [weak self] in
                guard let self else { return }
                
                let key = UUID()
                self.observers[key] = continuation
                
                continuation.onTermination = { [weak self] _ in
                    Task { @MainActor in
                        self?.observers.removeValue(forKey: key)
                    }
                }
                
                // стартовый снапшот
                continuation.yield((try? await self.loadAll()) ?? [])
            }
        }
    }
    
    func save(_ workout: Workout) async throws {
        let all = try context.fetch(FetchDescriptor<WorkoutEntity>())
        if let existing = all.first(where: { $0.id == workout.id.raw }) {
            existing.typeRaw       = workout.type.rawValue
            existing.startDate     = workout.startDate
            existing.statusRaw     = workout.status.rawValue
            existing.repeatsPerSet = workout.planning.repeatsPerSet
            existing.plannedSets   = workout.planning.sets
            existing.restTime      = workout.planning.restTime
            existing.endDate       = workout.endDate
            existing.sets          = workout.sets.map { WorkoutSetRecord(id: $0.id, reps: $0.reps, restTime: $0.restTime, performedAt: $0.performedAt) }
        } else {
            context.insert(WorkoutEntity(from: workout))
        }
        try context.save()
        notifyObservers()
    }
    
    func delete(_ id: WorkoutID) async throws {
        let all = try context.fetch(FetchDescriptor<WorkoutEntity>())
        if let entity = all.first(where: { $0.id == id.raw }) {
            context.delete(entity)
            try context.save()
            notifyObservers()
        } else {
            throw WorkoutRepoError.notFound
        }
    }
    
    private func notifyObservers() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let items = (try? await self.loadAll()) ?? []
            for c in observers.values { c.yield(items) }
        }
    }
}
