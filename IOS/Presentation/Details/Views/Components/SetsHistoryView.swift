import SwiftUI

struct SetsHistoryView: View {
    @Environment(\.workoutDateMapper) private var dateMapper

    let sets: [SetsHistoryRow]

    var body: some View {
        if sets.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 12) {
                Text("История подходов")
                    .font(.headline)

                ScrollView(.vertical) {
                    LazyVStack(spacing: 8) {
                        ForEach(sets) { item in
                            row(item)
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .statCardStyle()
            }
        }
    }


    @ViewBuilder
    private func row(_ item: SetsHistoryRow) -> some View {
        HStack(spacing: 12) {
            Text("Подход \(item.index)")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)


            Text(L10n.Workouts.reps(item.reps))
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)

            
            Text(dateMapper.formatDate(item.date))
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)

        }
    }
}
