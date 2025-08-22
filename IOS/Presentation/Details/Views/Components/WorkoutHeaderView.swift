import SwiftUI

struct WorkoutHeaderView: View {
    @Environment(\.workoutDateMapper) private var dateMapper
    let item: WorkoutHeaderItem
    
    var body: some View {
        HStack {
            HStack(spacing: 20) {
                Image(item.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    if item.status == .completed, let endDate = item.endDate {
                        Text(dateMapper.formatDate(endDate))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            StatusBadge(status: item.status)
        }
        .padding()
        .statCardStyle()
    }
}
