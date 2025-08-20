import Foundation

// Um gerenciador de cache para guardar os dados das respostas da API.
// NSCache porque ele gerencia a memória automaticamente.
class Caching {
    
    // instância única (Singleton) para ser usada em todo o app.
    static let instance = Caching()
    private init() {} // Garante que ninguém mais possa criar uma instância.
    
    private var cacheDeDados: NSCache<NSString, NSData> = NSCache()
    
    func salvar(dados: Data, paraUrl url: URL) {
        let chave = url.absoluteString as NSString
        let objeto = dados as NSData
        self.cacheDeDados.setObject(objeto, forKey: chave)
        print("Dados salvos no cache para a URL: \(url)")
    }
    
    func buscar(paraUrl url: URL) -> Data? {
        let chave = url.absoluteString as NSString
        print("Buscando dados no cache para a URL: \(url)")
        return self.cacheDeDados.object(forKey: chave) as Data?
    }
}
