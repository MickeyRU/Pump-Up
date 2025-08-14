import Foundation

struct WorkoutID: Sendable, Hashable {
    let raw: UUID
    init(raw: UUID) { self.raw = raw }
}
