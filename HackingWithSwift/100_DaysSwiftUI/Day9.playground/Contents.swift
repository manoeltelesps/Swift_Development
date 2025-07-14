import Foundation
import SwiftUI

func multiplicarNumero(num1: Int, num2: Int) -> Int {
    
    return num1 * num2
}

multiplicarNumero(num1: 3, num2: 4)

var copiaMulti = multiplicarNumero

copiaMulti(3,4)

let dividirNumero = { (num1: Int, num2: Int) -> Int in
    return num1/num2
}

dividirNumero(10,2)


func capitaoPrimeiro (nome: String, nome2: String) -> Bool {
    
    if nome == "Manoel"{
        return true
    }
    else if nome2 == "Manoel"{
        return false
    }
    
    return nome > nome2
    
}

var nomes = ["Jose", "Maria", "Neymar", "Manoel"]

var captainFirst = nomes.sorted(by: capitaoPrimeiro)
// print(nomes.sorted(by: capitaoPrimeiro))


//var captainFirst = nomes.sorted(by: capitaoPrimeiro)
//print(captainFirst)

//print(nomes.sorted(by: capitaoPrimeiro))

var numeros = [1,2,3,4,5]


///Closure Completa
/*let quemvemPrimeiro =  numeros.sorted(by: { (num1: Int, num2: Int) -> Bool in
    if num1 == 3 {
        return true
    }
    else if num2 == 3 {
        return false
    }
    
    return num1 < num2
    
})*/


///Closure resumida com parâmetros
//let quemvemPrimeiro = numeros.sorted{ num1, num2 in
//    if num1 == 3 {
//        return true
//    }
//    else if num2 == 3 {
//        return false
//    }
//    
//    return num1 < num2
//}

///Closure resumida com $
let quemvemPrimeiro = numeros.sorted{
    if $0 == 3 {
        return true
    }
    else if $1 == 3 {
        return false
    }
    
    return $0 < $1
}

// print(quemvemPrimeiro)


/// CHECKPOINT 5

let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

var arrayPares: [Int] = []

let numerosPares = luckyNumbers.filter {
    let ehPar = $0.isMultiple(of: 2)
    
    if ehPar{
        arrayPares.append($0)
    }
    
    return ehPar
}

let esseNumeroSorte =  luckyNumbers.map{ num in
    
    var ehImpar = num.isMultiple(of: 2)
    
    luckyNumbers.filter(!ehImpar)
}

print(luckyNumbers.sorted())
print(arrayPares)



