import Foundation

var nome: String? = nil

if let nome{
    print("Olá, \(nome)")
}

//MARK: - Guard Let

///Exemplo

var num: Int = 8

func aoQuadrado(_ numero: Int?){
    guard let numero = numero else {
        print("Error: Optional vazio")
        return
    }
    
    print("\(numero) ao quadrado é \(numero * numero)")
}

aoQuadrado(num)
print()

///Exemplo maior
enum Problemas: Error {
    case semNumero
    case zero
}

func divisao(dividir num1: Int?, por num2: Int?) throws -> Int {
    guard let num1 = num1 else {
        throw Problemas.semNumero
    }
    
    guard let num2 = num2 else {
        throw Problemas.semNumero
    }
    
    if num2 == 0 { Problemas.zero}
    
    return num1/num2
}

var num1: Int?
var num2: Int? = 0

do{
    let resultado = try divisao(dividir: 8 , por: num1)
    print(resultado)
} catch Problemas.semNumero {
    print("Erro: optional vazio")
} catch Problemas.zero {
    print("Erro: Não é possível dividir por zero")
} catch {
    print("Error")
}

//Checkpoint

var arrayOptinal: [Int]?

func sorteioOptinal(_ array: [Int]?) -> Int{
    guard let array = array else {
        return Int.random(in: 1...100)
    }
    
    return array.randomElement() ?? 0
}

sorteioOptinal(arrayOptinal)
