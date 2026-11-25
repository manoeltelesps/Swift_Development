//
//  baseApp.swift
//  base
//
//  Created by Manoel Pedro Prado Sa Teles on 13/08/26.
//

import SwiftData
import SwiftUI

@main
struct baseApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: Session.self)
    }
}
