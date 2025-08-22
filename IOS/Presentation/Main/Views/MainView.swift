import SwiftUI

struct MainView: View {
    @Environment(\.workoutStatsProvider) private var stats
    @StateObject private var vm: MainViewModel
    @State private var showAddWorkoutSheet = false
    @State private var selected: WorkoutID?
    
    private let ucs: WorkoutUseCases
    
    init(repository: WorkoutRepository, ucs: WorkoutUseCases) {
        _vm = StateObject(wrappedValue: MainViewModel(repository: repository))
        self.ucs = ucs
    }
    
    var body: some View {
        TabView {
            // TAB 1 — Тренировки
            NavigationStack {
                List {
                    ForEach(vm.rows) { row in
                        Button { selected = row.id } label: {
                            RowView(item: row)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: vm.delete)
                }
                .listStyle(.plain)
                .navigationTitle("Тренировки")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddWorkoutSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                .navigationDestination(item: $selected) { workoutID in
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
