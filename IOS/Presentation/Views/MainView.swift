import SwiftUI

struct MainView: View {
    @StateObject private var vm: MainViewModel
    private let addWorkoutUseCase: AddWorkoutUseCase
    @State private var showAddWorkoutSheet = false
    
    init(repository: WorkoutRepository, addWorkoutUseCase: AddWorkoutUseCase) {
          _vm = StateObject(wrappedValue: MainViewModel(repository: repository))
          self.addWorkoutUseCase = addWorkoutUseCase
    }
    
    var body: some View {
        TabView {
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
                .task {
                    vm.start()
                }
                .onDisappear {
                    vm.stop()
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
            AddWorkoutView(addWorkoutUseCase: addWorkoutUseCase)
        }
    }
}
