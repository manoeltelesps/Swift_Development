import UIKit

//MARK: - Propriedades e Métodos

struct ContadorPaginas {
    var paginasLidas: Int = 0

    mutating func lerPaginas(_ quantidade: Int) {
        paginasLidas += quantidade
    }
}

var meuLivro = ContadorPaginas(paginasLidas: 10)
print("Paginas lidas: \(meuLivro.paginasLidas)")

meuLivro.lerPaginas(20)
print("Paginas lidas: \(meuLivro.paginasLidas)")

//MARK: - Property Values

struct Livro {
    let titulo: String
    let autor: String
    let paginas: Int
    let anodeLancamento: Int
    var paginaLida: Int = 0
    
    func qualLivro(){
        print("O livro \(titulo), é do(a) \(autor), tem normalmente \(paginas) páginas e foi lançado pela primeira vez em \(anodeLancamento)")
    }
    
    var paginasLidas: Int{
        get{
            return paginaLida
        }
        set{
            paginaLida += newValue
        }
    }
    
    var porcentagem: Double {
        (Double(paginaLida) / Double(paginas)) * 100
    }
}

var sombraVento: Livro = .init(titulo: "A Sombra do Vento", autor: "Carlos Ruiz Zafón", paginas: 399, anodeLancamento: 2001)
var contoAia = Livro(titulo: "O Conto da Aia (The Handmaid’s Tale)", autor: "Margaret Atwood", paginas: 320, anodeLancamento: 1985)

print()
sombraVento.paginasLidas = 35
print(sombraVento.porcentagem)
print(sombraVento.paginaLida)

sombraVento.paginasLidas = 40
print(sombraVento.porcentagem)
print(sombraVento.paginaLida)

// MARK: - Property Observers

struct Pontuacao {
    var pontos: Int = 0 {
        willSet {
            print("Sua pontuação é de \(pontos)")
        }
    }
        
}

var kills: Pontuacao = .init(pontos: 10)

print()
kills.pontos = 20

struct Pontuacao2 {
    var pontos: Int = 0 {
        didSet {
            print("Sua pontuação é de \(pontos)")
        }
    }
        
}

var deaths: Pontuacao2 = .init(pontos: 10)

deaths.pontos = 5

//MARK: - Inits

struct Player {
    let name: String
    let number: Int

    init(nome: String) {
        name = nome
        number = Int.random(in: 1...99)
        
        print("Olá \(name), seu nuúmero é \(number)")
    }
}
print()

let player = Player(nome: "Megan R")
