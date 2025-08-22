import SwiftUI

struct WorkoutStatItem: View {
    let progress: Double
    let title: String
    let valueText: String
    let tint: Color

    var body: some View {
        ProgressCircleView(
            progress: max(0, min(progress, 1)),
            title: title,
            valueText: valueText,
            progressColor: tint
        )
        .statCardStyle()
    }
}
