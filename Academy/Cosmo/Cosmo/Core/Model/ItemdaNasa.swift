import Foundation

// A resposta completa da API
struct RespostaDaAPI: Codable {
    let collection: ColecaoDeItens
}


struct ColecaoDeItens: Codable {
    let items: [ItemDaNasa]
}

// Molde para os Itens
struct ItemDaNasa: Codable, Identifiable {
    // Propriedades  do JSON da API
    
    private let href: String
    
    private let data: [DadosDoItem]
    private let links: [LinkDoItem]?
    
    
    var urlDoManifesto: URL? {
          return URL(string: href)
      }

   // ID Nasa
    var id: String {
        return data.first?.nasaID ?? ""
    }


    var titulo: String {
        return data.first?.title ?? "Sem título"
    }

    var descricao: String {
           // Pega a string original que pode conter HTML
           guard let htmlString = data.first?.description else { return "Sem descrição" }
           
           // Converte a string HTML para um objeto de dados
           guard let data = htmlString.data(using: .utf8) else {
               return htmlString.trimmingCharacters(in: .whitespacesAndNewlines)
           }
           
           // Tenta criar um "NSAttributedString", que entende HTML, e extrai o texto puro dele.
           do {
               let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
               let textoPuro = attributedString.string
               return textoPuro.trimmingCharacters(in: .whitespacesAndNewlines)
           } catch {
               // Se a conversão falhar, retorna a string original, apenas com uma limpeza básica.
               return htmlString.trimmingCharacters(in: .whitespacesAndNewlines)
           }
       }

    var tipoDeMidia: String {
        return data.first?.mediaType ?? "desconhecido"
    }

    var urlDaImagemPreview: URL? {
        guard let urlString = links?.first?.href else { return nil }
        return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
}

// Estruturas auxiliares que ajudam a organizar os dados que vêm da API.
struct DadosDoItem: Codable {
    let nasaID: String
    let title: String
    let description: String?
    let mediaType: String

    enum CodingKeys: String, CodingKey {
        case nasaID = "nasa_id"
        case title, description
        case mediaType = "media_type"
    }
}

struct LinkDoItem: Codable {
    let href: String
}
