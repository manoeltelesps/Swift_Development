//
//  Intent.swift
//  Intent
//
//  Created by Manoel Pedro Prado Sa Teles on 26/10/25.
//

import AppIntents

struct OpenFavorties: AppIntent{
    
    var tabView = RootTabView()
    
    static let title = LocalizedStringResource("Teste")
    static let description = IntentDescription("Abrir outra view")
    
    func perform() async throws -> some IntentResult {
    
    }
}
