//
//  CrudCoreDataApp.swift
//  CrudCoreData
//
//  Created by Manoel Pedro Prado Sa Teles on 29/06/25.
//

import SwiftUI

@main
struct CrudCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
