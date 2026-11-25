import Charts
import SwiftUI

/// Fase 6 report detail: rate over time against baseline, alert markers, and the
/// pause-density stat called out deliberately — the spec's point that a nervous
/// speaker often stops pausing rather than speeding up, so speed alone can hide
/// the real problem.
struct SessionDetailView: View {
    let session: Session

    private var sortedSamples: [SessionRateSample] {
        session.rateSamples.sorted { $0.elapsedSec < $1.elapsedSec }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                pauseDensityHighlight
                statsRow
                chartSection
            }
            .padding(.vertical)
        }
        .navigationTitle(session.startedAt.formatted(date: .abbreviated, time: .shortened))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var pauseDensityHighlight: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Densidade de pausas")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(String(format: "%.0f%%", session.pauseDensity * 100))
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .monospacedDigit()
            Text("% do tempo em silêncio")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var statsRow: some View {
        HStack {
            stat("Duração", String(format: "%.0fs", session.durationSec))
            Spacer()
            stat("Taxa média", String(format: "%.1f síl/s", session.averageArticulationRate))
            Spacer()
            stat("Alertas", "\(session.alertMarkers.count)")
        }
        .padding(.horizontal)
    }

    private func stat(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
                .monospacedDigit()
        }
    }

    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Taxa de articulação (síl/s)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            legend

            Chart {
                ForEach(sortedSamples, id: \.elapsedSec) { sample in
                    LineMark(
                        x: .value("Tempo (s)", sample.elapsedSec),
                        y: .value("Sílabas/s", sample.articulationRate)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .foregroundStyle(.blue)
                    .interpolationMethod(.monotone)
                }

                RuleMark(y: .value("Baseline", session.baselineSyllablesPerSecond))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .foregroundStyle(.secondary)

                ForEach(session.alertMarkers, id: \.elapsedSec) { marker in
                    RuleMark(x: .value("Alerta", marker.elapsedSec))
                        .lineStyle(StrokeStyle(lineWidth: 1.5))
                        .foregroundStyle(.red)
                }
            }
            .frame(height: 220)
            .padding(.horizontal)
        }
    }

    private var legend: some View {
        HStack(spacing: 16) {
            legendItem(color: .blue, label: "Taxa", isLine: true)
            legendItem(color: .secondary, label: "Baseline", isLine: true, dashed: true)
            if !session.alertMarkers.isEmpty {
                legendItem(color: .red, label: "Alerta", isLine: false)
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
    }

    private func legendItem(color: Color, label: String, isLine: Bool, dashed: Bool = false) -> some View {
        HStack(spacing: 4) {
            if isLine {
                Rectangle()
                    .fill(color)
                    .frame(width: 14, height: dashed ? 1 : 2)
            } else {
                Rectangle()
                    .fill(color)
                    .frame(width: 2, height: 12)
            }
            Text(label)
        }
    }
}
