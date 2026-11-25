import Combine
import Foundation

@MainActor
final class CalibrationViewModel: ObservableObject {
    @Published var baselineSyllablesPerSecond: Double

    init() {
        baselineSyllablesPerSecond = CalibrationStore.baselineSyllablesPerSecond
    }

    func save() {
        CalibrationStore.save(baselineSyllablesPerSecond: baselineSyllablesPerSecond)
    }
}
