//
//  OpenFavoritesIntents.swift
//  Coffee
//
//  Created by Manoel Pedro Prado Sa Teles on 25/10/25.
//

import AppIntents

struct OpenFavoritesIntents: AppIntent {
    
    static var title: LocalizedStringResource = "Open Favorites"
    static var description = IntentDescription("Opens the Favorites screen in the coffe shop app.")
    static var openAppWhenRun: Bool = true
    
    @Dependency
    var model: Model
    
    @MainActor
    func perform() async throws -> some IntentResult {
        model.selectedTab = .favorites
        return .result()
    }
}
