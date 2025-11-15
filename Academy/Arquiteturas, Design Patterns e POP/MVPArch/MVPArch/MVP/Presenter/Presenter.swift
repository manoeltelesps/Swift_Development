//
//  Presenter.swift
//  MVPArch
//
//  Created by Manoel Pedro Prado Sa Teles on 05/11/25.
//

import Foundation
import UIKit

// https://jsonplaceholder.typicode.com/users

// O Presenter não sabe quem é a View Concreta dele, ele só sabe que "alguém" que sabe mostrar os usuarios segue o protocolo UserPresenterDelegate

//  Em MVP, o Presenter não conhece a View concreta. Ele conhece uma interface, que descreve o que a View sabe fazer.
protocol UserPresenterDelegate: AnyObject {
    func presentUsers(users: [User])
    func presentAlert(title: String, message: String)
}

typealias PresenterDelegate = UserPresenterDelegate & UIViewController

class UserPresenter {
    
    // Essa view que sabe mostra os usuários é guardada dentro da variável
    weak var delegate: PresenterDelegate?
    
    // Monta a URL de API, faz uma requisaçõa HTTP, decodifica o JSON
    public func getUsers(){
        
        // Tenta criar uma URL válida
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        // Esse bloco é assincrono e só roda quando a resposta chegar, criando uma thread separada para fazer essa requisição e quando essa requisição é concluida o task.resume() é responsavel por rodar esse bloco
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            // Verifica se veio data
            guard let data = data, error == nil else {
                return
            }
            
            // Bloco do catch para decodificar o JSON para um array de User, se de certo chama o delegate.
            do{
                let users = try JSONDecoder().decode([User].self, from: data)
                self?.delegate?.presentUsers(users: users)
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
    
    public func setViewDelegate(delegate: PresenterDelegate){
        self.delegate = delegate
    }
}
