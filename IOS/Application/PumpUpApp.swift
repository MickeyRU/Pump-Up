import SwiftUI
import SwiftData

@main
struct PumpUpApp: App {
    private let modelContainer: ModelContainer
    private let workoutRepository: WorkoutRepository
    
    init() {
            self.modelContainer = ModelContainer.make()
            let context = modelContainer.mainContext
            self.workoutRepository = WorkoutRepositoryImpl(context: context)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(repository: workoutRepository)
        }
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
