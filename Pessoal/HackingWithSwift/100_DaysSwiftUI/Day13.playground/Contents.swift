import SwiftUI

protocol Classe {
    var nome: String { get }
    func atacar()
}

struct Mago: Classe {
    var nome: String

    func atacar(){
        print("Eu sou o mago \(nome), e te ataco com um bola de fogo")
    }
}

struct Guerreiro: Classe {
    var nome: String
    var equipamento: String
    
    func atacar(){
        print("Eu sou o guerreiro \(nome), e te ataco com \(equipamento)")
    }
}

var arthur = Guerreiro(nome: "Rei Arthur", equipamento: "Espada")
var merlin = Mago(nome: "Merlin")

var personagens: [Classe] = []

personagens.append(merlin)
personagens.append(arthur)

//MARK: - Extensions

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}

10.isEven

//MARK: - Protocolos com Extensions

protocol Veiculo {
    var nome: String { get}
    var som: String { get}
    func barulho()
}

extension Veiculo{
    func barulho () {
        print(" \(nome) faz esse som \(som)")
    }
}

struct Carro: Veiculo {
    var nome: String
    var som: String

}

let hilux = Carro(nome: "Hilux", som: "Vrumm")
hilux.barulho()

//MARK: - Checkpoint 5

protocol Construacao {
    var comodos: Int { get set}
    var preco: Int { get }
    var corretor: String { get }
    func informacoes()
}

struct House: Construacao{
    var comodos: Int
    var preco: Int
    var corretor: String
    
    func informacoes() {
        print("Essa é uma casa de \(comodos) comodos, pelo preço de R$ \(preco), contate \(corretor) para fazer uma visita.")
    }
}

struct Office: Construacao{
    var comodos: Int
    var preco: Int
    var corretor: String
    
    func informacoes() {
        print("Esse é um escritório de \(comodos) comodos, pelo preço de R$ \(preco), contate \(corretor) para fazer uma visita.")
    }
}

var minhacasa = House(comodos: 2, preco: 180000, corretor: "Manoel")
minhacasa.informacoes()

// MARK: Academy

protocol A{
    var id: Int { get }
}

protocol B{
    var id: Int { get }
}

struct Alfabeto: A, B {
    var id = 1
}
                       
