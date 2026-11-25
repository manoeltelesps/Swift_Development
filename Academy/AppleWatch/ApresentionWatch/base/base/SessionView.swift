import SwiftData
import SwiftUI

/// Fase 2's minimal screen — a live number and a start/stop button — plus, per
/// Fase 6, saving the finished session into SwiftData when one completes.
struct SessionView: View {
    @StateObject private var viewModel = SessionViewModel(audioCapture: AudioCaptureService())
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(viewModel.isRunning ? "\(Int(viewModel.wordsPerMinute.rounded()))" : "--")
                .font(.system(size: 96, weight: .bold, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.default, value: viewModel.wordsPerMinute)

            Text("palavras / min")
                .font(.title3)
                .foregroundStyle(.secondary)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            Button(viewModel.isRunning ? "Parar" : "Começar") {
                viewModel.toggleSession()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .font(.title2)
        }
        .padding()
        .onChange(of: viewModel.lastRecording) { _, newValue in
            guard let newValue else { return }
            modelContext.insert(Session(recording: newValue))
            try? modelContext.save()
        }
    }
}

#Preview {
    SessionView()
}
