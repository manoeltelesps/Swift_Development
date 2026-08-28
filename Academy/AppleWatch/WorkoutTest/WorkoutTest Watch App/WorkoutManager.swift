//
//  WorkoutManager.swift
//  WorkoutTest Watch App
//

import Foundation
import HealthKit

@Observable
final class WorkoutManager: NSObject {
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    var heartRate: Double = 0
    var isRunning = false
    var errorMessage: String?

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "HealthKit não disponível neste dispositivo."
            return
        }

        let typesToShare: Set = [HKQuantityType.workoutType()]
        let typesToRead: Set = [HKQuantityType(.heartRate)]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { [weak self] success, error in
            if !success {
                DispatchQueue.main.async {
                    self?.errorMessage = error?.localizedDescription ?? "Autorização negada."
                }
            }
        }
    }

    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .walking
        configuration.locationType = .outdoor

        do {
            let session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            let builder = session.associatedWorkoutBuilder()
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            session.delegate = self
            builder.delegate = self

            self.session = session
            self.builder = builder

            let startDate = Date()
            session.startActivity(with: startDate)
            builder.beginCollection(withStart: startDate) { [weak self] success, error in
                DispatchQueue.main.async {
                    self?.isRunning = success
                    if let error {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func endWorkout() {
        session?.end()
        builder?.endCollection(withEnd: Date()) { [weak self] _, error in
            self?.builder?.finishWorkout { [weak self] _, error in
                DispatchQueue.main.async {
                    self?.isRunning = false
                    if let error {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {
        DispatchQueue.main.async {
            self.isRunning = toState == .running
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
        }
    }
}

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        let heartRateType = HKQuantityType(.heartRate)

        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType, quantityType == heartRateType else { continue }

            let statistics = workoutBuilder.statistics(for: quantityType)
            let value = statistics?.mostRecentQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) ?? 0

            DispatchQueue.main.async {
                self.heartRate = value
            }
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
}
