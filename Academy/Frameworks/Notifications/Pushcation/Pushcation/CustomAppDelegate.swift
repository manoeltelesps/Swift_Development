//
//  CustomAppDelegate.swift
//  Pushcation
//
//  Created by Manoel Pedro Prado Sa Teles on 10/10/25.
//

import SwiftUI
import UserNotifications

// O UIApplicationDelegate é uma protocolo responsável para ter acesso aos eventos de inicialização do app, é preciso usar isso em SwiftUI uma vez que o recurso do UIKit as APNs

//O NSObject traduz o Swift para o Objective C, uma vez que algumas funções usadas no Objective C são necessárias para o uso de Notificações
class CustomAppDelegate: NSObject, UIApplicationDelegate {
    
    // Isso dá acesso aos métodos do código do aplicativo principal dentro do Delegate do aplicativo
    var app: PushcationApp?
    
    func  application ( _  application : UIApplication , didFinishLaunchingWithOptions  launchOptions : [ UIApplication.LaunchOptionsKey : Any ]?  =  nil ) -> Bool {
            // É aqui que registramos este dispositivo para receber notificações push da Apple
            // Tudo o que esta função faz é registrar o dispositivo com APNs, ela não configura notificações push por si só
             application.registerForRemoteNotifications()
            
            // Configurando o delegado de notificação
            UNUserNotificationCenter.current ().delegate =  self
            
            return  true
         }
        
        func  application ( _  application : UIApplication ,
                           didRegisterForRemoteNotificationsWithDeviceToken  deviceToken : Data ) {
            // Assim que o dispositivo for registrado para notificações push, a Apple enviará o token para nosso aplicativo e ele estará disponível aqui.
            // É aqui também que encaminharemos o token para nosso servidor push
            // Se você quiser ver uma versão em string do seu token, pode usar o seguinte código para imprimi-lo
            let stringifiedToken = deviceToken.map { String (format: "%02.2hhx" , $0 ) }.joined()
            print ( "stringifiedToken:" , stringifiedToken)
        }
    }

    extension  CustomAppDelegate : UNUserNotificationCenterDelegate {
        // Esta função nos permite fazer algo quando o usuário interage com uma notificação
        // como registrar que ele clicou nela ou navegar para uma tela específica
        func  userNotificationCenter ( _  center : UNUserNotificationCenter , didReceive  response : UNNotificationResponse ) async {
                print ( "Título da notificação obtida: " , response.notification.request.content.title)
        }
        
        // Esta função nos permite visualizar notificações no aplicativo mesmo com ele em primeiro plano
        func  userNotificationCenter ( _  center : UNUserNotificationCenter , willPresent  notification : UNNotification ) async -> UNNotificationPresentationOptions {
            // Estas opções são as que serão usadas ao exibir uma notificação com o aplicativo em primeiro plano
            // por exemplo, poderemos exibir um emblema no aplicativo, um alerta de banner aparecerá e poderemos reproduzir um som
            return [.badge, .banner, .list, .sound]
        }
    }
