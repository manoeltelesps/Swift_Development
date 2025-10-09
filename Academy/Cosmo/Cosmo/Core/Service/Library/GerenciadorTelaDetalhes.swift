// Ficheiro: ViewModel/GerenciadorDaTelaDetalhes.swift

import Foundation
import Combine

class GerenciadorDaTelaDetalhes: ObservableObject {
    
    @Published var urlDoVideo: URL?
    @Published var estaCarregando = false
    @Published var erroAoCarregar: String? // Verifique se esta linha está exatamente assim
    
    private let servico = ServicoDaNasa()
    private var cancellables = Set<AnyCancellable>()
    
    func buscarUrlDoVideo(para item: ItemDaNasa) {
        guard item.tipoDeMidia == "video", let manifestURL = item.urlDoManifesto else { return }
        
        self.estaCarregando = true
        self.urlDoVideo = nil
        self.erroAoCarregar = nil
        
        servico.buscarUrlDoVideo(aPartirDeManifestoUrl: manifestURL)
            .sink(receiveCompletion: { [weak self] completion in
                self?.estaCarregando = false
                
                if case .failure = completion {
                    self?.erroAoCarregar = "Não foi possível carregar este vídeo."
                }
            }, receiveValue: { [weak self] urlFinalDoVideo in
                self?.urlDoVideo = urlFinalDoVideo
            })
            .store(in: &cancellables)
    }
}
