import SwiftUI

struct RowView: View {
    @Environment(\.workoutDateMapper) private var dateMapper
    let item: WorkoutRowItem
    
    var body: some View {
        HStack(alignment: .center,  spacing: 20) {
            HStack(spacing: 20) {
                Image(item.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(L10n.Workouts.sets(item.setsCompleted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    Text(L10n.Workouts.reps(item.totalReps))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)
            
            VStack(alignment: .trailing, spacing: 2) {
                StatusBadge(status: item.status)
                
                if item.status == .completed, let endDate = item.endDate {
                    Text(dateMapper.formatDate(endDate))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .multilineTextAlignment(.trailing)
            .layoutPriority(2)
        }
        .padding(.vertical, 5)
    }
}
