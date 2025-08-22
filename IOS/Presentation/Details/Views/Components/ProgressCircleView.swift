import SwiftUI

struct ProgressCircleView: View {
    var progress: Double
    var title: String
    var valueText: String
    var progressColor: Color

    private let size: CGFloat = 80
    private let lineWidth: CGFloat = 8
    private let trackColor: Color = .gray.opacity(0.15)

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().stroke(trackColor, lineWidth: lineWidth)
                Circle()
                    .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                    .stroke(progressColor, style: .init(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.25), value: progress)
                Text(valueText).font(.headline).foregroundStyle(.primary)
            }
            .frame(width: size, height: size)

            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .padding()
    }
}
