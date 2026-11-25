//
//  ContentView.swift
//  base Watch App
//
//  Created by Manoel Pedro Prado Sa Teles on 13/08/26.
//

import SwiftUI

/// Minimal Watch screen: an "active session" indicator and a start/stop button.
/// Nothing else — the wearer shouldn't need to look at the wrist. Captures and
/// processes audio standalone, on the watch — no iPhone needed.
struct ContentView: View {
    @StateObject private var viewModel = WatchSessionViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(viewModel.isRunning ? Color.green : Color.gray)
                .frame(width: 12, height: 12)

            Text(viewModel.isRunning ? "Sessão ativa" : "Parado")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button(viewModel.isRunning ? "Parar" : "Começar") {
                viewModel.toggleSession()
            }
            .buttonStyle(.borderedProminent)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
