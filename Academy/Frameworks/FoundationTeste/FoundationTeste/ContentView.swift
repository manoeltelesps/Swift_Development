//
//  ContentView.swift
//  FoundationTeste
//
//  Created by Manoel Pedro Prado Sa Teles on 26/10/25.
//

import SwiftUI
import FoundationModels


@available(iOS 26.0, *)
struct ContentView: View {
    @State var question = "" //para receber o prompt do usuario
    @State var reply = ""
    
//criando uma sessao fora do botao para cada sessao manter o historico e o contexto, antes estava no clique com botao o que pode desperdiçar recurso e sempre reinicia conversa
    @State private var session = LanguageModelSession(
        instructions : Instructions{
                """
              Voce é um confeiteiro e diz uma receita baseada no gosto do usuário retorne com, motivo daquela receita ser boa.
                            
              """
        }
    )
    
    var body: some View {
        Form{
            Section("Oh-Device LLM")//Modelo de Linguagem no Dispositivo.
            {
                TextField("Question", text: $question)
                
                Button("Ask Question"){
    
                        Task {
                            do {//metodo que faz o modelo gerar uma resposta a partir do prompt do usuário e guarda com o await e tambem seguindo as instruções
                                let response = try await session.respond(to: question)
                                reply = response.content
                                //Guarda o texto da resposta no estado reply, que é exibido na tela com o Text(reply).
                            } catch {
                                print(error)
                            }
                        }
                }
                Text(reply)
                
            }
        }
    }
}
#Preview {
    if #available(iOS 26.0, *) {
        ContentView()
    } else {
        // Fallback on earlier versions
    }
}
