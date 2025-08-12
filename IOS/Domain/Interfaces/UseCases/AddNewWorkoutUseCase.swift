import Foundation

@MainActor
public protocol AddNewWorkoutUseCase {
    func execute(workout: Workout) throws
}
