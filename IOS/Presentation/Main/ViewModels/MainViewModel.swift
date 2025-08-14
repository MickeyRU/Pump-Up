import Foundation

@MainActor
final class MainViewModel: WorkoutStatsUpdatable, ObservableObject {
    @Published private(set) var workouts: [Workout] = []
    @Published private(set) var rows: [WorkoutRowItem] = []
    
    private let repo: WorkoutRepository
    private var streamTask: Task<Void, Never>?
    
    init(repository: WorkoutRepository) {
        self.repo = repository
    }
    
    func start(with stats: WorkoutStatsProviding) {
        stop()
        
        streamTask = Task {
            for await items in repo.observeAll() {
                self.workouts = items
                
                let statsById: [WorkoutID: WorkoutStats] = await withTaskGroup(
                    of: (WorkoutID, WorkoutStats).self,
                    returning: [WorkoutID: WorkoutStats].self
                ) { group in
                    for w in items {
                        group.addTask(priority: .utility) { (w.id, stats.getStats(for: w)) }
                    }
                    var res: [WorkoutID: WorkoutStats] = [:]
                    for await (id, st) in group { res[id] = st }
                    return res
                }
                
                self.rows = items.map { w in
                    let s = statsById[w.id]
                    return WorkoutRowItem(
                        id: w.id,
                        iconName: w.type.iconName,
                        title: w.type.displayName,
                        setsCompleted: w.sets.count,
                        totalReps: s?.totalReps ?? 0,
                        setsPlanned: w.planning.sets,
                        endDate: w.endDate,
                        status: w.status
                    )
                }
            }
        }
    }
    
    func stop() {
        streamTask?.cancel()
        streamTask = nil
    }
    
    func delete(at offsets: IndexSet) {
        for i in offsets {
            let row = rows[i]
            Task {
                try? await repo.delete(row.id)
            }
        }
    }
    
    func workout(by id: WorkoutID) -> Workout? {
        workouts.first { $0.id == id }
    }
}
