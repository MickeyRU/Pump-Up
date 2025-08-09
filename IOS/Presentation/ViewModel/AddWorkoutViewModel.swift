import Foundation

@MainActor
final class AddWorkoutViewModel: ObservableObject {
    private let addWorkout: AddWorkoutUseCase
    
    @Published var workoutType: WorkoutType = .pull_ups
    @Published var reps: Int = 5
    @Published var sets: Int = 10
    @Published var restTime: TimeInterval = 120
    @Published var didSave: Bool = false
    
    init(addWorkoutUseCase: AddWorkoutUseCase) {
        self.addWorkout = addWorkoutUseCase
    }
    
    func save() {
        let plan = WorkoutPlanData(repeatsPerSet: reps, sets: sets, restTime: restTime)
        let workout = Workout(type: workoutType, planning: plan)
        do {
            try addWorkout.execute(workout: workout)
            didSave = true
        } catch {
            print("Error saving workout: \(error)")
        }
    }
}

