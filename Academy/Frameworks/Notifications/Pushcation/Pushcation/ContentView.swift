//
//  ContentView.swift
//  Pushcation
//
//  Created by Manoel Pedro Prado Sa Teles on 09/10/25.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    let notificationCenter = UNUserNotificationCenter .current()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .task {
            //Tenta fazer a solicitação da permissão de envio de notificações
            do{
                //Confere se aceitou ou não
                let garantia = try await notificationCenter.requestAuthorization(options: [.badge, .sound, .alert])
                
                if garantia {
                    print("Autorizado")
                }
                else {
                    print("Não autorizado")
                }
                //Se de error na solicitaçã0
            } catch {
                print("Error de autorização: \(error)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
