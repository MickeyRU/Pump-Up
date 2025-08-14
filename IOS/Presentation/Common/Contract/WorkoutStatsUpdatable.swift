import Foundation

@MainActor
protocol WorkoutStatsUpdatable: AnyObject {
    func start(with provider: WorkoutStatsProviding)
    func stop()
}
