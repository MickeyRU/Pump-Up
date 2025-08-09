import SwiftUI
import SwiftData

@main
struct PumpUpApp: App {
    private let container = ModelContainer.make()
    private let repo: WorkoutRepository
    private let addWorkoutUC: AddWorkoutUseCase

    init() {
        repo = WorkoutRepositoryImpl(context: container.mainContext)
        addWorkoutUC = AddWorkoutUseCaseImpl(repository: repo)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(repository: repo, addWorkoutUseCase: addWorkoutUC)
        }.modelContainer(container)
    }
}

extension ModelContainer {
    fileprivate static func make(fileManager: FileManager = .default) -> ModelContainer {
        let schema = Schema([WorkoutEntity.self])
        let config = ModelConfiguration(for: WorkoutEntity.self)
        
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
