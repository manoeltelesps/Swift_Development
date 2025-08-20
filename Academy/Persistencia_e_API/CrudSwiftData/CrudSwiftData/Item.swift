//
//  Item.swift
//  CrudSwiftData
//
//  Created by Manoel Pedro Prado Sa Teles on 29/06/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
