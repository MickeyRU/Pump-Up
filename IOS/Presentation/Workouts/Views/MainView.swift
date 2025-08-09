import SwiftUI

struct MainView: View {
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
                    ForEach(vm.workouts, id: \.id.raw) { workout in
                        NavigationLink {
                            DetailView(
                                workout: workout,
                                startUC: ucs.start,
                                addSetUC: ucs.addSet,
                                completeUC: ucs.complete
                            )
                        } label: {
                            RowView(workout: workout)
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
                .task { vm.start() }
                .onDisappear { vm.stop() }
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
