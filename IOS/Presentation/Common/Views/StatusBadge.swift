import SwiftUI

struct StatusBadge: View {
    let status: WorkoutStatus

    var body: some View {
        Text(status.displayName)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
