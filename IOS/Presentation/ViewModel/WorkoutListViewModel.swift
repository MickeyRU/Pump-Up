import Foundation

@MainActor
final class WorkoutListViewModel: ObservableObject {
    @Published private(set) var workouts: [Workout] = []
    private let repository: WorkoutRepository

    init(repository: WorkoutRepository) { self.repository = repository }

    func load() async {
        do { workouts = try repository.all() } catch { /* обработка */ }
    }

    func delete(at offsets: IndexSet) {
        for i in offsets {
            let w = workouts[i]
            do {
                try repository.delete(w)
            } catch { /* обработка */ }
        }
        // локально уберём элемент — либо перезагрузить из репозитория
        workouts.remove(atOffsets: offsets)
    }
}
