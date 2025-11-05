import Foundation

// MARK: - Propiedades

protocol A{
    var id: Int { get }
}

protocol B{
    var id: Int { get set }
}

struct Alfabeto: A, B {
    var id = 1
}

var s: Alfabeto = Alfabeto()

s.id = 2
print(s.id)

// MARK: - Metodos

protocol C{
    func falar()
}

protocol D{
    func falar()
}

extension C {
    func falar(){
        print("Oi")
    }
    
    func lol(){
        print("Lolzin")
    }
}

extension D {
    func falar(){
        print("Olá")
    }
}

struct Contato: C, D {
    func falar(){
        print("Olá")
    }
}

var d = Contato()
d.falar()

// MARK: - Genericos

func teste <T> (a: T, b: T){
    print("Eu sou a: \(a) e eu sou b: \(b)")
}

teste(a: 2, b: 3)
teste(a: "Oi", b: "Olá")
teste(a: true, b: false)

protocol Veiculo{
    var nome: String { get }
    var rodas: Int { get set}
}

func dirigir <T: Veiculo> (veiculo: T){
    print("O \(veiculo.nome) com essas \(veiculo.rodas) está dirigindo")
}

struct Moto: Veiculo{
    var nome: String
    var rodas: Int
}

struct Carro: Veiculo{
    var nome: String
    var rodas: Int
}

var bross: Moto = Moto(nome: "Honda", rodas: 2)
var carro: Carro = Carro(nome: "Fiat", rodas: 4)

dirigir(veiculo: bross)
dirigir(veiculo: carro)

// MARK: - Genericos em Protocolos

protocol Idade{
    associatedtype idade
    var idade: idade { get }
    
    func apresentar(idade: idade)
}

extension Idade{
    func apresentar(idade: Int){
        print("Tenhho \(idade) anos")
    }
}

struct Manoel{
    typealias idade = Int
    var idade = 21
}

struct Jesus{
    typealias idade = String
    var idade = "2025"
}
