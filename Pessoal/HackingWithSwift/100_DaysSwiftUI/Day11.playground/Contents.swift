import UIKit

enum errosTransacao: Error {
    case ntemovalor
    case negativo
}


struct Banco {
    
    private(set) var money: Double{
        didSet{
            print("Seu dinheiro: R$ \(money)")
        }
    }
    
    mutating func deposito(_ valor: Double){
        money += valor
    }
    
    mutating func saque(_ valor: Double)  throws {
        if money < valor {throw errosTransacao.ntemovalor}
        if valor < 0 {throw errosTransacao.negativo}
        
        money -= valor
    }
    
    init(money: Double) {
        self.money = money
    }
}

var minhaconta: Banco = .init(money: 10)

minhaconta.deposito(10000)

do{
    try minhaconta.saque(9)
} catch errosTransacao.ntemovalor{
    print("Error: Você não tem esse diheiro em conta")
} catch errosTransacao.negativo{
    print("Error: Não é possível sacar valores negativo")
} catch {
    print("Error")
}

//MARK: - Static

struct APP {
    static let versao: Double = 1
    static let nome: String = "meuAPP"
    
    static func versaoNome(_ nome: String){
        print("O app \(nome), versão \(versao)")
    }
}

print(APP.nome)


//MARK: - Checkpoint: 6

struct Carro{
    
    //Propiedades
    
    let marca: String
    let modelo: String
    let ano: String
    let assentos: Int
    
    var marchaAtual: Int {
        return marcha
    }
    
    private var marcha: Int {
        didSet{
            print("Marcha Anterior \(oldValue)")
        }
    }
    

   //Init
    
    init(marca: String, modelo: String, ano: String, assentos: Int, marcha: Int) {
        self.marca = marca
        self.modelo = modelo
        self.ano = ano
        self.assentos = assentos
        self.marcha = marcha
    }
    
    //Funções
    
    mutating func trocarMarchas (_ marchanv: Int){
        if marchanv > marcha {
            marcha = marchanv
            print("Subindo de marcha \(marcha)")
        }
        else if marchanv < marcha{
            marcha = marchanv
            print("Reduzindo a marcha \(marcha)")
        }
        else {
            print("Você já está na marcha: \(marcha)")
        }
    }
}

var hilux: Carro = .init(marca: "Toyota", modelo: "Hilux", ano: "2025", assentos: 6, marcha: 0)

print()
hilux.trocarMarchas(4)

print()
hilux.trocarMarchas(4)


