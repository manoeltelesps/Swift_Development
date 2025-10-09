import Foundation
import Combine

class ServicoDaNasa {

    // Chamando o Arquivo .plist (API Key)
    private let apiKey = GerenciadorDeChaves.obterChaveDaAPI()

    func buscarItens(comTermoDeBusca termo: String, tipoDeMidia: String) -> AnyPublisher<[ItemDaNasa], Error> {
        
        var componentes = URLComponents(string: "https://images-api.nasa.gov/search")!
        
        // Adicionei a chave da API aos parâmetros da busca.
        // Muitas APIs da NASA usam o parâmetro "api_key".
        componentes.queryItems = [
            URLQueryItem(name: "q", value: termo),
            URLQueryItem(name: "media_type", value: tipoDeMidia),
            // A linha abaixo não é realmente necessária para esta API específica,
            // mas é uma boa prática incluí-la para outras APIs da NASA.
            // URLQueryItem(name: "api_key", value: self.apiKey)
        ]

        guard let url = componentes.url else {
            fatalError("URL inválida.")
        }
        
        if let dadosDoCache = Caching.instance.buscar(paraUrl: url) {
               print("Cache HIT! Usando dados do cache.")
               // Caso encontrado, decodifica e retorna os dados imediatamente.
               return Just(dadosDoCache)
                   .decode(type: RespostaDaAPI.self, decoder: JSONDecoder())
                   .map { $0.collection.items }
                   .mapError { _ in URLError(.badServerResponse) } // Apenas para o tipo de erro bater
                   .receive(on: DispatchQueue.main)
                   .eraseToAnyPublisher()
           }
        
            print("Cache MISS! Buscando dados da rede...")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: RespostaDaAPI.self, decoder: JSONDecoder())
            .map { respostaDecodificada in
                return respostaDecodificada.collection.items
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func buscarUrlDoVideo(aPartirDeManifestoUrl url: URL) -> AnyPublisher<URL, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [String].self, decoder: JSONDecoder())
            .tryMap { urls -> URL in
                
                // TORNANDO A BUSCA MAIS ROBUSTA
                let urlString = urls.first(where: { $0.hasSuffix("~mobile.mp4") })
                             ?? urls.first(where: { $0.hasSuffix("~small.mp4") })
                             ?? urls.first(where: { $0.hasSuffix("~medium.mp4") })
                             // CORREÇÃO: Vamos aceitar qualquer .mp4 como uma opção válida
                             ?? urls.first(where: { $0.hasSuffix(".mp4") })

                guard let finalUrlString = urlString,
                      let videoUrl = URL(string: finalUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                    
                    // Se mesmo assim não encontrarmos nada, lançamos um erro claro.
                    throw URLError(.cannotFindHost, userInfo: ["description": "Nenhuma URL de vídeo .mp4 válida foi encontrada."])
                }
                
                return videoUrl
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    }

