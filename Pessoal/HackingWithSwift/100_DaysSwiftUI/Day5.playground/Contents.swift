import UIKit

// MARK: - If e Else

var idade: Int = 18

if idade >= 18 {
    print("Você é maior de idade.")
}


var temp: Double = 25

if temp > 20 && temp < 30 {
    print("Bom Clima")
}

enum opcaoTransporte {
    case aviao, helicopteto, carro, bicicleta ,moto
}

var transporte: opcaoTransporte = .aviao

if transporte == .aviao || transporte == .helicopteto {
    print("Voe")
}

var time: String = "flu"

if time == "Vasco"{
    print("Boa Pessoa")
}
else if time == "Flamengo" {
    print("Má Pessoa")
}
else {
    print("Time irrelevante")
}

// MARK: - Switch

enum diasSemana {
    case segunda, terça, quarta, quinta, sexta, sábado, domingo
}

var hoje: diasSemana = .terça

switch hoje{
    
case .segunda:
    print("É segunda")
case .terça:
    print("É terça")
case .quarta:
    print("É quarta")
case .quinta:
    print ("É quinta")
case .sexta:
    print("É sexta")
case .sábado:
    print("É sábado")
case .domingo:
    print("É domingo")
}

let numero = 0

switch numero {
case 5:
    print("Mariana conta 5")
    fallthrough
case 4:
    print("Mariana conta 4")
    fallthrough
case 3:
    print("Mariana conta 3")
    fallthrough
case 2:
    print("Mariana conta 2")
    fallthrough
case 1:
    print("Mariana conta 1")
default:
    print("Mariana não conta")
}

// MARK: - Ternário

var nome = "Manoel"

var eManoel = nome == "Manoel" ? "Sim, é o Manoel" : "Não, é um estranho"

print(eManoel)
