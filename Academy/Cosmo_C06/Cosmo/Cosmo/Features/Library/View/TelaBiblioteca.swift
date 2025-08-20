import SwiftUI

struct TelaBiblioteca: View {
    
    // A tela cria e observa o seu gerenciador.
    @StateObject private var gerenciador = GerenciadorDaTelaBiblioteca()
    
    var body: some View {
        NavigationView {
            
            // Se estiver carregando, mostre uma animação.
            if gerenciador.estaCarregando {
                ProgressView("Carregando o cosmos...")
                    .navigationTitle("Biblioteca")
            }
            // Se deu erro, mostre a mensagem.
            else if let mensagem = gerenciador.mensagemDeErro {
                Text(mensagem)
                    .navigationTitle("Biblioteca")
            }
            // Se tudo deu certo, mostre o conteúdo.
            else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        CarrosselDeDestaques(itens: gerenciador.itensDeDestaque)
                        
                        ListaDeRecomendacoes(itens: gerenciador.recomendacoesFiltradas)
                    }
                }
                .navigationTitle("Biblioteca")
                .searchable(text: $gerenciador.textoDeBusca, prompt: "Buscar por título")
            }
        }
        // Quando a tela aparecer pela primeira vez, pede para o gerenciador para buscar os dados.
        .onAppear {
            if gerenciador.itensDeDestaque.isEmpty {
                 gerenciador.buscarDadosDaTela()
            }
        }
    }
}

// MARK: - Componentes Visuais da Tela

struct CarrosselDeDestaques: View {
    let itens: [ItemDaNasa]
    
    var body: some View {
        TabView {
            ForEach(itens) { item in
            
                NavigationLink(destination: TelaDeDetalhesView(item: item)) {
                    AsyncImage(url: item.urlDaImagemPreview) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(.gray.opacity(0.3)) // Cor enquanto carrega
                    }
                    .overlay(Image(systemName: item.tipoDeMidia == "video" ? "video.fill" : "photo.fill").foregroundColor(.white).font(.title))
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .padding(.horizontal)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 220)
    }
}

struct ListaDeRecomendacoes: View {
    let itens: [ItemDaNasa]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recomendações")
                .font(.title2.bold())
                .padding(.horizontal)

            LazyVStack(spacing: 20) {
                ForEach(itens) { item in
                   LinhaDaRecomendacao(item: item)
                }
            }
        }
    }
}

struct LinhaDaRecomendacao: View {
    let item: ItemDaNasa
    
    var body: some View {
       
        NavigationLink(destination: TelaDeDetalhesView(item: item)) {
            HStack(spacing: 16) {
                AsyncImage(url: item.urlDaImagemPreview) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(.gray.opacity(0.3))
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    Image(systemName: item.tipoDeMidia == "video" ? "video.fill" : "photo.fill")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .padding(5)
                        .background(Color.black.opacity(0.5).clipShape(Circle()))
                        .padding(5),
                    alignment: .bottomTrailing
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.titulo)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary) // Garante que o texto não fique azul
                    
                    Text(item.descricao)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TelaBiblioteca()
}
