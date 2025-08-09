import SwiftUI
import SwiftData

@main
struct PumpUpApp: App {
    @StateObject private var appDI = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            WorkoutsRootView()
                .environmentObject(appDI.workoutsDI)
            
        }.modelContainer(appDI.modelContainer)
    }
}
