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
    print("A sua senha é: \(result)")
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
