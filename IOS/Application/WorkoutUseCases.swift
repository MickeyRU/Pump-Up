import Foundation

public struct WorkoutUseCases {
    public let add: AddNewWorkoutUseCase
    public let start: StartWorkoutUseCase
    public let addSet: AddSetUseCase
    public let complete: CompleteWorkoutUseCase

    public init(add: AddNewWorkoutUseCase,
                start: StartWorkoutUseCase,
                addSet: AddSetUseCase,
                complete: CompleteWorkoutUseCase) {
        self.add = add
        self.start = start
        self.addSet = addSet
        self.complete = complete
    }
}
