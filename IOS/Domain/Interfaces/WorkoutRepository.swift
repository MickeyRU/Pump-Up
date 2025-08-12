import Foundation

@MainActor
public protocol WorkoutRepository {
    func all() throws -> [Workout]
    func observeAll() -> AsyncStream<[Workout]>
    func save(_ workout: Workout) throws
    func delete(_ workout: Workout) throws
}
