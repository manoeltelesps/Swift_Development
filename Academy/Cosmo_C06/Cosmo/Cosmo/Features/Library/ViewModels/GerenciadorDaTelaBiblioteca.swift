//
//  GerenciadorDaTelaBiblioteca 2.swift
//  Cosmo
//
//  Created by Matheus Silva on 02/07/25.
//


import Foundation
import Combine

class GerenciadorDaTelaBiblioteca: ObservableObject {
    
    @Published var itensDeDestaque: [ItemDaNasa] = []
    @Published var recomendacoes: [ItemDaNasa] = []
    
    //  Propriedade para guardar o texto da busca
    @Published var textoDeBusca: String = ""
    
    // Nova lista que se filtra sozinha
    var recomendacoesFiltradas: [ItemDaNasa] {
        if textoDeBusca.isEmpty {
            return recomendacoes // Se a busca estiver vazia, retorna tudo
        } else {
            // Se não, retorna apenas os itens cujo título contém o texto da busca
            return recomendacoes.filter { $0.titulo.localizedCaseInsensitiveContains(textoDeBusca) }
        }
    }
    
    @Published var estaCarregando = false
    @Published var mensagemDeErro: String? = nil
    
    private let servico = ServicoDaNasa()
    private var cancellables = Set<AnyCancellable>()

    func buscarDadosDaTela() {
            self.estaCarregando = true
            self.mensagemDeErro = nil
            
            let termoDestaques = "James Webb" // Um termo que retorna vídeos e fotos boas
            let termoRecomendacoes = "Galaxy"
            
            // Buscando IMAGENS E VÍDEOS para os destaques
            let publisherDestaques = servico.buscarItens(comTermoDeBusca: termoDestaques, tipoDeMidia: "image,video")
            
            // Buscando IMAGENS E VÍDEOS para as recomendações
            let publisherRecomendacoes = servico.buscarItens(comTermoDeBusca: termoRecomendacoes, tipoDeMidia: "image,video")
            
            Publishers.Zip(publisherDestaques, publisherRecomendacoes)
                .sink(receiveCompletion: { [weak self] completion in
                    self?.estaCarregando = false
                    if case .failure(let error) = completion {
                        self?.mensagemDeErro = "Falha ao buscar dados. Tente novamente."
                        print(error.localizedDescription)
                    }
                }, receiveValue: { [weak self] destaques, recomendacoes in
                   
                    self?.itensDeDestaque = Array(destaques.shuffled().prefix(10))
                    self?.recomendacoes = Array(recomendacoes.shuffled().prefix(50))
                })
                .store(in: &cancellables)
        }
}
