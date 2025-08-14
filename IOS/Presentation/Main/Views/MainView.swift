import SwiftUI

struct MainView: View {
    @Environment(\.workoutStatsProvider) private var stats
    @StateObject private var vm: MainViewModel
    @State private var showAddWorkoutSheet = false
    
    private let ucs: WorkoutUseCases
    
    init(repository: WorkoutRepository, ucs: WorkoutUseCases) {
        _vm = StateObject(wrappedValue: MainViewModel(repository: repository))
        self.ucs = ucs
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach(vm.rows) { row in
                        NavigationLink(value: row.id) {
                            RowView(item: row)
                                .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
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
                .navigationDestination(for: WorkoutID.self) { workoutID in
                    if let workout = vm.workout(by: workoutID) {
                        DetailView(workout: workout, ucs: ucs)
                    } else {
                        Text("Тренировка не найдена")
                    }
                }
                .task { vm.start(with: stats) }
                .onDisappear { vm.stop() }
                
            }
            .tabItem {
                Image("workout_icon")
                Text("Тренировки")
            }
        }
        .sheet(isPresented: $showAddWorkoutSheet) {
            AddWorkoutView(addWorkoutUseCase: ucs.addNew)
        }
    }
}
