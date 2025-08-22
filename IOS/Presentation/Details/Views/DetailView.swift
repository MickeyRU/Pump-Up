import SwiftUI

struct DetailView: View {
    @Environment(\.workoutStatsProvider) private var stats
    @StateObject private var vm: DetailViewModel
    
    init(workout: Workout, ucs: WorkoutUseCases) {
        _vm = StateObject(wrappedValue: DetailViewModel(workout: workout, ucs: ucs))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                WorkoutHeaderView(item: vm.rowItem)
                if let stats = vm.stats {
                    WorkoutStatsRow(stats: stats)
                }
                WorkoutControlView(vm: vm)
                SetsHistoryView(sets: vm.recentSetRows)
            }
            .padding()
            .task { vm.start(with: stats) }
            .onDisappear{ vm.stop() }
        }
        .navigationTitle("Детали тренировки")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .scrollIndicators(.hidden)
    }
}
