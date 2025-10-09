import Foundation

//Serviço responsável por buscar dados do rover Curiosity da API da NASA.
//Encapsula a lógica de requisição e montagem de URL com parâmetros dinâmicos.
class CuriosityService {
    //Realiza a chamada à API do Curiosity com suporte a filtro por sol, página e câmera.
    //Utiliza `async/await` para código assíncrono mais legível.
    func fetchPhotos(sol: Int = 1000, page: Int = 1, camera: String? = nil) async throws -> [Photo] {
        var urlString = "https://mars-photos.herokuapp.com/api/v1/rovers/curiosity/photos?sol=\(sol)&page=\(page)"
        if let camera = camera {
            urlString += "&camera=\(camera)"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL) //Validacao da URL.
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        //Verifica se a resposta HTTP foi bem-sucedida (status 200). Caso contrário, lança um erro.
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder.withDateDecoding.decode(PhotoResponse.self, from: data)
        return decoded.photos
    }
}

//Configura um `JSONDecoder` com suporte ao formato de data esperado pela API.
extension JSONDecoder {
    static var withDateDecoding: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}
