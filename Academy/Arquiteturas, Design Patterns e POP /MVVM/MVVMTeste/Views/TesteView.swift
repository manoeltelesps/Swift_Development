//
//  TaskView.swift
//  MVCToDoList
//
//  Created by Manoel Pedro Prado Sa Teles on 02/11/25.
//

import SwiftUI

struct TesteView: View {

    // Controller: a View observa mudanças aqui
    @StateObject private var controller = MensagemViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            Text("View")

            // Se já houver uma mensagem, mostra na tela
            if let mensagem = controller.ultimaMensagem {
                Text("Última: \(mensagem.title)")
                Text(mensagem.description)
            }
            
            Button("Aperte") {
                controller.criarSaudacao()
            }
        }
        .padding()
    }
}

#Preview {
    TesteView()
}
