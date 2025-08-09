import SwiftUI
import SwiftData

@MainActor
final class AppDIContainer: ObservableObject {
    let modelContainer: ModelContainer
    let workoutsDI: WorkoutsDIContainer

    init() {
        let schema = Schema([WorkoutEntity.self])
        do {
            modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Не удалось создать ModelContainer: \(error)")
        }
        
        let workoutRepo = WorkoutRepositoryImpl(context: modelContainer.mainContext)
        self.workoutsDI = WorkoutsDIContainer(repo: workoutRepo)
    }
}
