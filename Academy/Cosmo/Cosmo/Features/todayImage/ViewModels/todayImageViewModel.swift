//
//  todayImageViewModel.swift
//  Cosmo
//
//  Created by Manoel Pedro Prado Sa Teles on 03/07/25.
//

import Foundation

@MainActor
final class TodayImageViewModel: ObservableObject {
    @Published var apod: APODModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRefreshing = false

    private let service: APODServiceProtocol

    init(service: APODServiceProtocol = APODService()) {
        self.service = service
    }

    func fetchImage() async {
        isLoading = true
        errorMessage = nil
        do {
            apod = try await service.fetchTodayImage()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // Método para refresh manual (força nova requisição)
    func refreshImage() async {
        isRefreshing = true
        errorMessage = nil
        
        // Limpar cache para forçar nova requisição
        if let apodService = service as? APODService {
            APODService.clearCache()
        }
        
        do {
            apod = try await service.fetchTodayImage()
        } catch {
            errorMessage = error.localizedDescription
        }
        isRefreshing = false
    }
    
    // Método para carregar dados sem mostrar loading se já tiver dados
    func loadImageIfNeeded() async {
        if apod == nil {
            await fetchImage()
        }
    }
}
