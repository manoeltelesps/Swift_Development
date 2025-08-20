// Ficheiro: View/TelaDeDetalhesView.swift

import SwiftUI
import AVKit

struct TelaDeDetalhesView: View {
    
    let item: ItemDaNasa
    @StateObject private var gerenciador = GerenciadorDaTelaDetalhes()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Área de Mídia
                ZStack {
                    if item.tipoDeMidia == "video" {
                        if let urlDoVideo = gerenciador.urlDoVideo {
                            // Sucesso: Mostra o player com o tamanho correto
                            AVKitPlayerView(videoURL: urlDoVideo)
                                .aspectRatio(16/9, contentMode: .fit)
                        } else {
                            // Enquanto carrega ou se der erro, mostra a thumbnail
                            ZStack {
                                AsyncImage(url: item.urlDaImagemPreview) { image in
                                    image.resizable().aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Rectangle().fill(.gray.opacity(0.1)).aspectRatio(16/9, contentMode: .fit)
                                }
                                
                                if gerenciador.estaCarregando {
                                    ProgressView().controlSize(.large)
                                } else if let mensagemDeErro = gerenciador.erroAoCarregar {
                                    // Mostra a mensagem de erro ao utilizador
                                    VStack(spacing: 8) {
                                        Image(systemName: "video.slash.fill")
                                            .font(.largeTitle)
                                        Text(mensagemDeErro)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(.black.opacity(0.5))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    } else {
                        // Se for uma imagem, o comportamento é o mesmo
                        AsyncImage(url: item.urlDaImagemPreview) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.2), radius: 5, y: 5)

                // MARK: - Informações
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.titulo)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(item.descricao)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(item.titulo)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if item.tipoDeMidia == "video" {
                gerenciador.buscarUrlDoVideo(para: item)
            }
        }
    }
}
