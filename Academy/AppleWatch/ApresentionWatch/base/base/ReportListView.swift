import SwiftData
import SwiftUI

struct ReportListView: View {
    @Query(sort: \Session.startedAt, order: .reverse) private var sessions: [Session]

    var body: some View {
        NavigationStack {
            Group {
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma sessão ainda",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Termine uma sessão de ensaio pra ver o relatório aqui.")
                    )
                } else {
                    List(sessions) { session in
                        NavigationLink(value: session) {
                            SessionRow(session: session)
                        }
                    }
                }
            }
            .navigationTitle("Relatórios")
            .navigationDestination(for: Session.self) { session in
                SessionDetailView(session: session)
            }
        }
    }
}

private struct SessionRow: View {
    let session: Session

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(session.startedAt.formatted(date: .abbreviated, time: .shortened))
                .font(.body)

            HStack(spacing: 6) {
                Text(String(format: "%.0fs", session.durationSec))
                Text("·")
                Text(String(format: "%.1f síl/s", session.averageArticulationRate))
                Text("·")
                Text(String(format: "%.0f%% pausa", session.pauseDensity * 100))
                if !session.alertMarkers.isEmpty {
                    Text("·")
                    Text("\(session.alertMarkers.count) alerta(s)")
                }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }
}
