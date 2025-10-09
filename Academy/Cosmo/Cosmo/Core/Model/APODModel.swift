//
//  APODModel.swift
//  Cosmo
//
//  Created by Manoel Pedro Prado Sa Teles on 03/07/25.
//

import Foundation

public struct APODModel: Codable {
    let title: String
    let explanation: String
    let date: String
    let url: String?
    let media_type: String
    let copyright: String?
}
