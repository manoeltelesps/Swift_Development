//
//  RbozinhoViewModel.swift
//  Cosmo
//
//  Created by Débora Cristina Silva Ferreira on 03/07/25.
//

import Foundation

@MainActor
class RoverViewModel: ObservableObject {
    //Mantém os dados da UI atualizados com a lista de resultados.
    @Published var completedRovers: [CompletedRover] = []
    //Indica se a requisição está em andamento, útil para exibir carregamento na UI.
    @Published var isLoading: Bool = false
    //Armazena mensagens de erro para exibição amigável na UI.
    @Published var errorMessage: String?

    //Cache simples para evitar requisições duplicadas à mesma URL.
    private var photoCache: [String: [CompletedRover]] = [:]
    
    let service = CuriosityService()

    //Função principal de carregamento, trata cache, loading, erro e atualização dos dados.
    //Utiliza `defer` para garantir que o estado de loading seja sempre atualizado.
    //Utiliza chave única para armazenar e reutilizar cache por combinação de filtros.
    func loadPhotos(sol: Int, page: Int, camera: String?, append: Bool = false) async {
        let cacheKey = "sol:\(sol)-page:\(page)-camera:\(camera ?? "all")"
        
        if let cached = photoCache[cacheKey] {
            if append {
                completedRovers.append(contentsOf: cached)
            } else {
                completedRovers = cached
            }
            print("Usando cache para \(cacheKey)")
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let photos = try await service.fetchPhotos(sol: sol, page: page, camera: camera)
            let mappedPhotos = photos.compactMap { completedRover(from: $0) }
            photoCache[cacheKey] = mappedPhotos
            
            if append {
                completedRovers.append(contentsOf: mappedPhotos)
            } else {
                completedRovers = mappedPhotos
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Erro: \(error.localizedDescription)")
        }
    }
}

func completedRover(from photo: Photo) -> CompletedRover? {
    guard
        let extra = roverExtraInfo[photo.rover.name],
        let imageUrl = URL(string: photo.imgSrc)
    else {
        return nil
    }
    
    return CompletedRover(
        id: photo.id,
        imageUrl: imageUrl,
        earthDate: photo.earthDate,
        cameraName: photo.camera.name,
        roverName: photo.rover.name,
        roverStatus: photo.rover.status,
        roverLaunchDate: photo.rover.launchDate,
        roverLandingDate: photo.rover.landingDate,
        roverDescription: extra.description,
    )
}
