import SwiftUI

struct MainView: View {
    @StateObject private var vm: MainViewModel
    @State private var showAddWorkoutSheet = false
    @State private var selectedWorkoutID: WorkoutID?
    
    private let ucs: WorkoutUseCases
    
    init(repository: WorkoutRepository, ucs: WorkoutUseCases, stats: WorkoutStatsProviding) {
        _vm = StateObject(wrappedValue: MainViewModel(repository: repository, stats: stats))
        self.ucs = ucs
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach(vm.rows) { row in
                        RowView(item: row)
                            .onTapGesture { selectedWorkoutID = row.id }
                            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))

                    }
                    .onDelete(perform: vm.delete)
                }
                .navigationTitle("Тренировки")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { showAddWorkoutSheet = true } label: { Image(systemName: "plus") }
                    }
                }
                .task {
                    vm.start()
                }
                .onDisappear {
                    vm.stop()
                }
                .navigationDestination(item: $selectedWorkoutID) { workoutID in
                    if let workout = vm.workout(by: workoutID) {
                        DetailView(
                            workout: workout,
                            startUC: ucs.start,
                            addSetUC: ucs.addSet,
                            completeUC: ucs.complete
                        )
                    } else {
                        Text("Тренировка не найдена")
                    }
                }
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
            AddWorkoutView(addWorkoutUseCase: ucs.add)
        }
    }
}
