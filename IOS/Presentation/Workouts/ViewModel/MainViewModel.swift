import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published private(set) var workouts: [Workout] = []
    private let repo: WorkoutRepository
    private var streamTask: Task<Void, Never>?
    
    init(repository: WorkoutRepository) {
        self.repo = repository
    }
    
    func start() {
        streamTask?.cancel()
        streamTask = Task { @MainActor in
            for await items in repo.observeAll() {
                self.workouts = items
            }
        }
    }
    
    func stop() {
        streamTask?.cancel()
    }
    
    func delete(at offsets: IndexSet) {
        for i in offsets {
            do {
               try repo.delete(workouts[i])
            } catch {
                print("Error deleting workout: \(error)")
            }
        }
    }
}
