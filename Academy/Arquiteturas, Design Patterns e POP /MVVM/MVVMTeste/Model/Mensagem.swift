//
//  Tasks.swift
//  MVCToDoList
//
//  Created by Manoel Pedro Prado Sa Teles on 02/11/25.
//

import Foundation

protocol Mensagem{
    var title: String { get }
    var description: String { get }
}


class NormalMensagem: Identifiable, Mensagem{
    
    var title: String = ""
    var description: String = ""
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
