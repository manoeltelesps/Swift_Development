//
//  Robozinho.swift
//  Cosmo
//
//  Created by Débora Cristina Silva Ferreira on 03/07/25.
//

import Foundation

struct PhotoResponse: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: RoverAPIResponse
    
    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

struct Camera: Codable {
    let id: Int
    let name: String
    let roverId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roverId = "rover_id"    }
}

struct RoverAPIResponse: Codable {
    let id: Int
    let name: String
    let landingDate: Date
    let launchDate: Date
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case landingDate = "landing_date"
        case launchDate = "launch_date"
    }
}

struct RoverExtra {
    let description: String
}

struct CompletedRover: Identifiable {
    let id: Int
    let imageUrl: URL
    let earthDate: String
    let cameraName: String
    let roverName: String
    let roverStatus: String
    let roverLaunchDate: Date
    let roverLandingDate: Date
    let roverDescription: String
}

let roverExtraInfo: [String: RoverExtra] = [
    "Curiosity": RoverExtra(
        description: "O Curiosity é um rover espacial da NASA projetado para explorar a cratera Gale em Marte. Ele foi lançado em 2011 e pousou em Marte em 2012, com o objetivo de investigar o clima, a geologia e a possibilidade de vida no planeta vermelho, além de preparar o caminho para futuras missões humanas. O veículo, do tamanho de um SUV, está equipado com câmeras, instrumentos científicos e um sistema inovador de pouso chamado “sky crane”. Desde então, o Curiosity segue operacional, fornecendo importantes dados sobre Marte.",
    )
]
