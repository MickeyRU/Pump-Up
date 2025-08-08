import SwiftUI

struct MainView: View {
    @StateObject private var vm: WorkoutListViewModel
    @State private var showAddWorkoutSheet = false
    
    init(repository: WorkoutRepository) {
        _vm = StateObject(wrappedValue: WorkoutListViewModel(repository: repository))
    }
    
    var body: some View {
        TabView {
            // Вкладка тренировок
            NavigationStack {
                List {
                    ForEach(vm.workouts, id: \.id.raw) { workout in
                        NavigationLink {
                            WorkoutDetailView(workout: workout)
                        } label: {
                            WorkoutRowView(workout: workout)
                        }
                    }
                    .onDelete(perform: vm.delete)
                }
                .navigationTitle("Тренировки")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { showAddWorkoutSheet = true } label: { Image(systemName: "plus") }
                    }
                }
                .task { await vm.load() }
            }
            .tabItem {
                Image(systemName: "figure.strengthtraining.traditional")
                Text("Тренировки")
            }
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Статистика")
                }
        }
        .sheet(isPresented: $showAddWorkoutSheet) {
            AddWorkoutView()
        }
    }
}

#Preview {
    struct MockRepo: WorkoutRepository {
        func all() throws -> [Workout] {
            [
                Workout(type: .push_ups, planning: .init(repeatsPerSet: 10, sets: 3, restTime: 60)),
                Workout(type: .pull_ups, planning: .init(repeatsPerSet: 8, sets: 4, restTime: 90))
            ]
        }
        func save(_ workout: Workout) throws {}
        func delete(_ workout: Workout) throws {}
    }

    return MainView(repository: MockRepo())
}
