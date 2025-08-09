import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddWorkoutViewModel
    
    init(addWorkoutUseCase: AddWorkoutUseCase) {
        _viewModel = StateObject(wrappedValue: AddWorkoutViewModel(addWorkoutUseCase: addWorkoutUseCase))
    }

    var body: some View {
        Form {
            Section(header: Text("Тип тренировки")) {
                Picker("Тип", selection: $viewModel.workoutType) {
                    ForEach(WorkoutType.allCases, id: \.self) { type in
                        Text(type.displayName)
                    }
                }
            }
            
            Section(header: Text("Повторы и подходы")) {
                Stepper("Повторов: \(viewModel.reps)", value: $viewModel.reps, in: 1...50)
                Stepper("Подходов: \(viewModel.sets)", value: $viewModel.sets, in: 1...50)
            }
            
            Section(header: Text("Отдых между подходами")) {
                Stepper("Отдых: \(Int(viewModel.restTime)) сек", value: $viewModel.restTime, in: 10...600, step: 10)
            }
            
            Section {
                Button("Сохранить тренировку") {
                    viewModel.save()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .onChange(of: viewModel.didSave) { _, saved in
                if saved {
                    dismiss()
                }
            }
        }
        .navigationTitle("Новая тренировка")
    }
}
