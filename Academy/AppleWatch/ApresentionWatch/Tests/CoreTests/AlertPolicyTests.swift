import XCTest
@testable import Core

final class AlertPolicyTests: XCTestCase {
    private func fire(_ policy: inout AlertPolicy, rate: Double, through end: TimeInterval, step: TimeInterval = 0.5) -> [TimeInterval] {
        var fireTimes: [TimeInterval] = []
        var t: TimeInterval = 0
        while t <= end {
            if policy.evaluate(articulationRate: rate, at: t) { fireTimes.append(t) }
            t += step
        }
        return fireTimes
    }

    func testTenSecondsOfFastTalkFiresExactlyOneAlert() {
        var policy = AlertPolicy(baselineSyllablesPerSecond: 5.0)
        let fastRate = policy.ceiling + 1.0
        let fireTimes = fire(&policy, rate: fastRate, through: 10)
        XCTAssertEqual(fireTimes.count, 1)
        XCTAssertEqual(fireTimes.first ?? -1, 8.0, accuracy: 0.001)
    }

    func testTwoToThreeSecondSpikesFireNothing() {
        var policy = AlertPolicy(baselineSyllablesPerSecond: 5.0)
        let fastRate = policy.ceiling + 1.0
        let calmRate = policy.ceiling - 1.0

        var fired = false
        for spikeStart in stride(from: 0.0, through: 20.0, by: 5.0) {
            var t = spikeStart
            while t < spikeStart + 3 {
                if policy.evaluate(articulationRate: fastRate, at: t) { fired = true }
                t += 0.5
            }
            if policy.evaluate(articulationRate: calmRate, at: t) { fired = true }
        }

        XCTAssertFalse(fired)
    }

    func testCooldownBlocksRepeatAlertsWithinFortySeconds() {
        var policy = AlertPolicy(baselineSyllablesPerSecond: 5.0)
        let fastRate = policy.ceiling + 1.0
        let fireTimes = fire(&policy, rate: fastRate, through: 50)

        XCTAssertEqual(fireTimes.count, 2)
        XCTAssertEqual(fireTimes[0], 8.0, accuracy: 0.001)
        XCTAssertEqual(fireTimes[1], 48.0, accuracy: 0.001)
    }

    func testDroppingBelowCeilingResetsSustainedBreachTimer() {
        var policy = AlertPolicy(baselineSyllablesPerSecond: 5.0)
        let fastRate = policy.ceiling + 1.0
        let calmRate = policy.ceiling - 1.0

        XCTAssertFalse(policy.evaluate(articulationRate: fastRate, at: 0))
        XCTAssertFalse(policy.evaluate(articulationRate: fastRate, at: 3))
        XCTAssertFalse(policy.evaluate(articulationRate: calmRate, at: 3.5))
        XCTAssertFalse(policy.evaluate(articulationRate: fastRate, at: 4))
        // Breach restarted at t=4, needs another 8s — not sustained yet by t=10.
        XCTAssertFalse(policy.evaluate(articulationRate: fastRate, at: 10))
        XCTAssertTrue(policy.evaluate(articulationRate: fastRate, at: 12))
    }
}
