import SwiftUI

/// Root navigation for the phases built so far: ensaio session (Fase 2/4/5),
/// calibration (Fase 3), and reports (Fase 6).
struct RootTabView: View {
    var body: some View {
        TabView {
            SessionView()
                .tabItem { Label("Sessão", systemImage: "waveform") }

            CalibrationView()
                .tabItem { Label("Calibração", systemImage: "tuningfork") }

            ReportListView()
                .tabItem { Label("Relatórios", systemImage: "chart.line.uptrend.xyaxis") }
        }
    }
}

#Preview {
    RootTabView()
}
