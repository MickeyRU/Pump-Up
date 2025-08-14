import SwiftUI
import SwiftData

@main
struct PumpUpApp: App {
    private var appDI = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            WorkoutsRootView()
                .environmentObject(appDI.workoutsDI)
                .environment(\.workoutDateMapper, DefaultWorkoutDateMapper())
                .environment(\.workoutStatsProvider, appDI.workoutsDI.stats)
        }.modelContainer(appDI.modelContainer)
    }
}
