import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    // Внутренние доменные данные
    @Published private(set) var workouts: [Workout] = []
    
    // Паблишим только то, что нужно UI
    @Published private(set) var rows: [WorkoutRowItem] = []
    
    private let repo: WorkoutRepository
    private let statsService: WorkoutStatsProviding
    private var streamTask: Task<Void, Never>?
    
    init(repository: WorkoutRepository, stats: WorkoutStatsProviding) {
        self.repo = repository
        self.statsService = stats
    }
    
    func start() {
        streamTask?.cancel()
        streamTask = Task {
            for await items in repo.observeAll() {
                // 1) сохраним доменную модель
                self.workouts = items
                
                // 2) посчитаем статистику в фоне
                let statsById = await withTaskGroup(
                    of: (WorkoutID, WorkoutStats).self,
                    returning: [WorkoutID: WorkoutStats].self
                ) { group in
                    let service = statsService
                    for w in items {
                        group.addTask(priority: .utility) { (w.id, service.stats(for: w)) }
                    }
                    var res: [WorkoutID: WorkoutStats] = [:]
                    for await (id, st) in group { res[id] = st }
                    return res
                }
                
                // 3) соберём UI-DTO
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
    }
    
    func delete(at offsets: IndexSet) {
        for i in offsets {
            let row = rows[i]
            // найдём доменный объект по id и удалим
            if let workout = workouts.first(where: { $0.id == row.id }) {
                try? repo.delete(workout)
            }
        }
    }
    
    // Нужен для DetailView — получить актуальный Workout по id
    func workout(by id: WorkoutID) -> Workout? {
        workouts.first { $0.id == id }
    }
}
