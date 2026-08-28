//
//  ContentView.swift
//  WorkoutTest Watch App
//
//  Created by Manoel Pedro Prado Sa Teles on 28/08/26.
//

import SwiftUI

struct ContentView: View {
    @State private var manager = WorkoutManager()

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundStyle(.red)

            Text("\(Int(manager.heartRate)) bpm")
                .font(.title2.bold())

            if let errorMessage = manager.errorMessage {
                Text(errorMessage)
                    .font(.caption2)
                    .foregroundStyle(.red)
            }

            Button(manager.isRunning ? "Parar treino" : "Iniciar treino") {
                if manager.isRunning {
                    manager.endWorkout()
                } else {
                    manager.startWorkout()
                }
            }
            .tint(manager.isRunning ? .red : .green)
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
