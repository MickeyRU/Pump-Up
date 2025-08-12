import SwiftUI

struct WorkoutsRootView: View {
    @EnvironmentObject private var di: WorkoutsDIContainer

    var body: some View {
        MainView(repository: di.repo, ucs: di.ucs)
            .environment(\.workoutStatsProvider, di.stats)
    }
}
