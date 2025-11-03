//
//  TasksControler.swift
//  MVCToDoList
//
//  Created by Manoel Pedro Prado Sa Teles on 02/11/25.
//

import Foundation
import Combine

// Controller: coordena ações e expõe estado para a View
final class MensagemViewModel: ObservableObject {
    // Estado que a View observa (não deixa a View alterar diretamente)
    @Published private(set) var ultimaMensagem: Mensagem?

    // Ação que a View chama; aqui criamos/atualizamos o Model
    func criarSaudacao() {
        let mensagem = NormalMensagem(title: "Oi", description: "Bom dia")
        ultimaMensagem = mensagem
        print("Titulo: \(mensagem.title)")
    }
}
