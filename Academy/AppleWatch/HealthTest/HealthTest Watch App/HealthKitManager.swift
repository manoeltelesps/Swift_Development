//
//  HealthKitManager.swift
//  HealthTest Watch App
//

import Foundation
import HealthKit

@Observable
final class HealthKitManager {
    private let healthStore = HKHealthStore()

    var stepCount: Double = 0
    var errorMessage: String?

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "HealthKit não disponível neste dispositivo."
            return
        }

        let stepType = HKQuantityType(.stepCount)

        healthStore.requestAuthorization(toShare: [], read: [stepType]) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.fetchTodaySteps()
                } else {
                    self?.errorMessage = error?.localizedDescription ?? "Autorização negada."
                }
            }
        }
    }

    func fetchTodaySteps() {
        let stepType = HKQuantityType(.stepCount)
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { [weak self] _, statistics, error in
            let sum = statistics?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                self?.stepCount = sum
                if let error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }

        healthStore.execute(query)
    }
}
