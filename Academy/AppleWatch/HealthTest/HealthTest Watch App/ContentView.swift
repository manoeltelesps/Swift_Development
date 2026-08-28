//
//  ContentView.swift
//  HealthTest Watch App
//
//  Created by Manoel Pedro Prado Sa Teles on 28/08/26.
//

import SwiftUI

struct ContentView: View {
    @State private var manager = HealthKitManager()

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "figure.walk")
                .font(.largeTitle)
                .foregroundStyle(.tint)

            Text("\(Int(manager.stepCount))")
                .font(.title2.bold())
            Text("passos hoje")
                .font(.caption)
                .foregroundStyle(.secondary)

            if let errorMessage = manager.errorMessage {
                Text(errorMessage)
                    .font(.caption2)
                    .foregroundStyle(.red)
            }

            Button("Atualizar") {
                manager.fetchTodaySteps()
            }
        }
        .padding()
        .onAppear {
            manager.requestAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
