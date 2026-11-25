import SwiftUI

/// Baseline manual: sílabas/segundo ajustável na mão, com uma média boa como
/// padrão (5.5, PT-BR) — faixa típica citada na spec é 4-7 síl/s.
struct CalibrationView: View {
    @StateObject private var viewModel = CalibrationViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 4) {
                Text(String(format: "%.1f", viewModel.baselineSyllablesPerSecond))
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Text("sílabas / segundo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Slider(value: $viewModel.baselineSyllablesPerSecond, in: 3.0...8.0, step: 0.1) { editing in
                if !editing { viewModel.save() }
            }
            .padding(.horizontal)

            Text("Esse é o ritmo confortável de fala usado como referência. O alerta dispara quando você fica bem acima disso por tempo suficiente.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    CalibrationView()
}
