import Foundation

protocol WorkoutRepository: Sendable {
    func loadAll() async throws -> [Workout]
    func load(_ id: WorkoutID) async throws -> Workout
    func observeAll() -> AsyncStream<[Workout]>
    func save(_ workout: Workout) async throws
    func delete(_ id: WorkoutID) async throws
    func update(_ id: WorkoutID, mutate: (inout Workout) throws -> Void) async throws -> Workout
}

extension WorkoutRepository {
    func update(_ id: WorkoutID, mutate: (inout Workout) throws -> Void) async throws -> Workout {
        var w = try await load(id)
        try mutate(&w)
        try await save(w)
        return w
    }
}
