import SwiftUI

struct RowView: View {
    let item: WorkoutRowItem
    
    var body: some View {
        HStack(alignment: .center,  spacing: 20) {
            Image(item.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text("\(item.setsCompleted) подходов")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text("\(item.totalReps) повторений")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .layoutPriority(1)
            
            Spacer()
                                    
            VStack(alignment: .trailing) {
                StatusBadge(status: item.status)
                
                if item.status == .completed, let endDate = item.endDate {
                    Text(formatDate(endDate))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 5)
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "Сегодня HH:mm"
            return timeFormatter.string(from: date)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d.MM.yy HH:mm"
            dateFormatter.locale = Locale(identifier: "ru_RU")
            return dateFormatter.string(from: date)
        }
    }
}

#Preview {
    List {
        RowView(item: WorkoutRowItem(
            id: WorkoutID(raw: UUID()),
            iconName: "push_ups_icon",
            title: "Отжимания",
            setsCompleted: 0,
            totalReps: 0,
            setsPlanned: 40,
            endDate: nil,
            status: .notStarted
        ))
        let fiveHoursAgo = Date().addingTimeInterval(-5 * 60 * 60)
        
        RowView(item: WorkoutRowItem(
            id: WorkoutID(raw: UUID()),
            iconName: "pull_ups_icon",
            title: "Подтягивания",
            setsCompleted: 5,
            totalReps: 50,
            setsPlanned: 20,
            endDate: Date().addingTimeInterval(-5 * 60 * 60),
            status: .completed
        ))
        
        RowView(item: WorkoutRowItem(
            id: WorkoutID(raw: UUID()),
            iconName: "pull_ups_icon",
            title: "Подтягивания",
            setsCompleted: 5,
            totalReps: 50,
            setsPlanned: 20,
            endDate: Date(),
            status: .completed
        ))
    }
}
