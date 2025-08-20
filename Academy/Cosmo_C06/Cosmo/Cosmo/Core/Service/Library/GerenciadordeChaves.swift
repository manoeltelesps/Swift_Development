import Foundation

struct GerenciadorDeChaves {
    // Função que busca a chave dentro do arquivo .plist
    static func obterChaveDaAPI() -> String {
        guard let url = Bundle.main.url(forResource: "APIKeys", withExtension: "plist"),
              let dados = try? Data(contentsOf: url),
              let resultado = try? PropertyListSerialization.propertyList(from: dados, options: [], format: nil) as? [String: Any],
              let chave = resultado["Nasa_API_KEY"] as? String else {
            
            // Se não encontrar o arquivo ou a chave, o app vai parar,
            // indicando um erro de configuração do desenvolvedor.
            fatalError("Não foi possível encontrar a chave 'NASA_API_KEY' no arquivo APIKeys.plist")
        }
        return chave
    }
}

