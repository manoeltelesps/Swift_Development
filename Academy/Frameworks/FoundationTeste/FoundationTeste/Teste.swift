//
//  Teste.swift
//  FoundationTeste
//
//  Created by Manoel Pedro Prado Sa Teles on 26/10/25.
//

import Playgrounds
import FoundationModels

#Playground {
    if #available(iOS 26.0, *) {
        let session = LanguageModelSession()
        
        let instrucion = "Creata a intinary to Paris for 3-days"
        
        let response = try await session.respond(to: instrucion)
    }
}
