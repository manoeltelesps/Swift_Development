//
//  Shortcuts.swift
//  Coffee
//
//  Created by Manoel Pedro Prado Sa Teles on 26/10/25.
//

import AppIntents

struct CoffeShortcuts: AppShortcutsProvider{

    static var appShortcuts: [AppShortcut] = [
            AppShortcut(
                intent: OpenFavoritesIntents(),
                phrases: ["Open my favorites \(.applicationName)"],
                shortTitle: "Open Favorites",
                systemImageName: "heart.fill"
            ),
            
            AppShortcut(
                intent: ProductDetailIntent(),
                phrases: ["Open product detail in \(.applicationName)"],
                shortTitle: "Product Detail",
                systemImageName: "search.fill"
            )
        
        ]
}

