//
//  APODService.swift
//  Cosmo
//
//  Created by Manoel Pedro Prado Sa Teles on 03/07/25.
//

import Foundation

protocol APODServiceProtocol {
    func fetchTodayImage() async throws -> APODModel
}

struct APODService: APODServiceProtocol {
    private var apiKey: String {
        loadAPIKey()
    }

    private let baseURL = "https://api.nasa.gov/planetary/apod"
    
    // Configuração do URLCache para cache HTTP
    private let urlCache: URLCache
    private let session: URLSession
    
    // Cache local para dados decodificados
    private static var apodCache: [String: (APODModel, Date)] = [:]
    private static let cacheValidityDuration: TimeInterval = 3600 // 1 hora
    
    init() {
        // Configurar URLCache com capacidade de 50MB em memória e 100MB em disco
        self.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "apod_cache")
        
        // Configurar URLSession com cache personalizado
        let config = URLSessionConfiguration.default
        config.urlCache = self.urlCache
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    private func loadAPIKey() -> String {
        guard
            let url = Bundle.main.url(forResource: "APODKey", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = plist["APOD_Key"] as? String
        else {
            fatalError("Não foi possível carregar a API Key do APODKey.plist")
        }
        return key
    }
    
    private func getTodayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func isCacheValid(for date: String) -> Bool {
        guard let cachedData = Self.apodCache[date] else { return false }
        let timeSinceCached = Date().timeIntervalSince(cachedData.1)
        return timeSinceCached < Self.cacheValidityDuration
    }

    func fetchTodayImage() async throws -> APODModel {
        let todayDate = getTodayDateString()
        
        // Verificar cache local primeiro
        if isCacheValid(for: todayDate) {
            print("📱 APOD: Retornando dados do cache local para \(todayDate)")
            return Self.apodCache[todayDate]!.0
        }
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "date", value: todayDate)
        ]

        let request = URLRequest(url: components.url!, cachePolicy: .returnCacheDataElseLoad)
        
        print("🌐 APOD: Fazendo requisição para \(components.url?.absoluteString ?? "")")
        
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        switch httpResponse.statusCode {
        case 200:
            let apodModel = try JSONDecoder().decode(APODModel.self, from: data)
            
            // Salvar no cache local
            Self.apodCache[todayDate] = (apodModel, Date())
            print("💾 APOD: Dados salvos no cache local para \(todayDate)")
            
            return apodModel
        case 429:
            throw NSError(domain: "", code: 429, userInfo: [NSLocalizedDescriptionKey: "Muitas requisições. Tente mais tarde."])
        default:
            throw URLError(.badServerResponse)
        }
    }
    
    // Método para limpar cache (útil para testes ou quando necessário)
    static func clearCache() {
        apodCache.removeAll()
        print("🗑️ APOD: Cache local limpo")
    }
}
