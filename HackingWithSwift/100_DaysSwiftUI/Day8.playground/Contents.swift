import Foundation

enum ErrodeSenha: Error{
    case pequena
    case obvia
    
    var mensagem: String {
        switch self{
        case .pequena:
                return "Senha Pequena"
        case .obvia:
                return "1234? Sério"
        }
    }
}

func testarSenha(_ senh: String) throws -> String{
    
    if senh.count < 5 {throw ErrodeSenha.pequena}
    if senh == "1234"{throw ErrodeSenha.obvia}
    
    if senh.count < 8 {
        return("Ok")
    }
    else if senh.count < 10 {
        return("Boa")
    }
    else{
        return("Excelente")
    }
}

var senha = "123456"

do{
    let result = try testarSenha(senha)
//    print("A sua senha é: \(result)")
}
catch ErrodeSenha.obvia{
    print("1234? Sério")
}
catch ErrodeSenha.pequena{
    print("Muito pequena")
}
catch{
    print("Erro")
}


// MARK: - Checkpoint 4

enum SemPossibilidade: Error {
    case foraDoLimite
    case semRaiz
}

func raizQuadrada(_ num: Int) throws -> Int {
    if num < 1 || num > 10000 {
        throw SemPossibilidade.foraDoLimite
    }

    for i in 1...num/2 {
        if i * i == num {
            return i
        }
    }

    throw SemPossibilidade.semRaiz
}

do {
    let resultado = try raizQuadrada(10000)
    print("A raiz é \(resultado)")
} catch SemPossibilidade.foraDoLimite {
    print("Erro: número fora dos limites")
} catch SemPossibilidade.semRaiz {
    print("Erro: sem raiz exata")
} catch {
    print("Erro desconhecido")
}
