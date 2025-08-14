import Foundation

@MainActor
final class AddWorkoutViewModel: ObservableObject {
    private let addWorkout: AddNewWorkoutUseCase
    
    @Published var workoutType: WorkoutType = .pull_ups
    @Published var reps: Int = 5
    @Published var sets: Int = 10
    @Published var restTime: TimeInterval = 120
    
    @Published var isSaving: Bool = false
    @Published var didSave: Bool = false
    @Published var errorMessage: String?
    
    @Published private(set) var createdWorkout: Workout?
    
    init(addWorkoutUseCase: AddNewWorkoutUseCase) {
        self.addWorkout = addWorkoutUseCase
    }
    
    func save(startImmediately: Bool = false) {
        isSaving = true
        errorMessage = nil
        
        let plan = WorkoutPlanData(repeatsPerSet: reps, sets: sets, restTime: restTime)
        let input = NewWorkoutInput(type: workoutType, planning: plan, startImmediately: startImmediately)
        
        Task { @MainActor [addWorkout] in
            do {
                let w = try await addWorkout.execute(input, now: .now)
                createdWorkout = w
                didSave = true
            } catch {
                errorMessage = "Не удалось сохранить тренировку: \(error)"
            }
            isSaving = false
        }
    }
}

