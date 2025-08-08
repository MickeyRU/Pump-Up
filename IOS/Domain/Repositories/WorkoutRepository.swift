import Foundation

public protocol WorkoutRepository {
    func all() throws -> [Workout]
    func save(_ workout: Workout) throws
    func delete(_ workout: Workout) throws
}
