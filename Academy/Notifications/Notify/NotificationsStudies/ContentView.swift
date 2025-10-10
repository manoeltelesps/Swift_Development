//
//  ContentView.swift
//  NotificationsStudies
//
//  Created by Manoel Pedro Prado Sa Teles on 08/10/25.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @State private var scheduledAt: Date = Date()
    
    var body: some View {
        VStack {
            
            //Escolher Horario
            DatePicker("Horario", selection: $scheduledAt, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
            
            // Crio um botão para testar as notificações
            Button("Agendar Notificação"){
                
                // Aqui eu inicializo o MutableNotificationContent dentro de um content
                let content = UNMutableNotificationContent()
                
                //Personalizo minha notificação
                content.title = "Isso é uma notificação local"
                content.subtitle = "Tá funcionando direitinho"
                content.sound = UNNotificationSound.default
                
                
                //Tentando colocar definir um horario especifico notificacao
                let comps = Calendar.current.dateComponents([.hour, .minute], from: scheduledAt)
                
                
                // Crio um trigger que vai notificar com base no horário marcado no Datepicker la em cima, uma vez que o meu dateMaching depende do meu comps que usa o scheeduleAt
                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                
                //Crio o request para pedir o sistema para gerencias minhas notificações
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                //Creio que aqui o centro de comando da notificação atualize o momento atual para a condição presente no request.
                UNUserNotificationCenter.current().add(request)
            }
            Button ("Desativar Notificações"){
                let cancelar = UNUserNotificationCenter.current()
                
                cancelar.removeAllPendingNotificationRequests()
            }
        //Uso do Task porque a solicitação de permissão é assincrona, nisso o aplicativo solicita a permissão quando é aberto
        }.task {
            //Nesse to eu uso um try para tentar o solicitar o a permissão ao usuário, faz sentido colocar ele no como um .task porque ele carrega quando a view é carregada.
            do {
                
                //Indica se o usuário permitiu ou não a notificação
                let granted = try await UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound])
                
                if granted {
                    print("Permissão concedida!")
                } else {
                    print("Permissão negada.")
                }
                
                //Para caso deu erro na solicitação da notificação
            } catch {
                print("Erro ao solicitar permissão: \(error)")
            }
        }
    }
}


#Preview {
    ContentView()
}
