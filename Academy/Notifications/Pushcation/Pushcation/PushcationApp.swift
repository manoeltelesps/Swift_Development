//
//  PushcationApp.swift
//  Pushcation
//
//  Created by Manoel Pedro Prado Sa Teles on 09/10/25.
//

import SwiftUI

@main
struct PushcationApp: App {
    
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    appDelegate.app = self
                }
        }
    }
}
