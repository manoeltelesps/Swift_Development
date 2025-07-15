import UIKit

for i in 1...10{
    print("Contando \(i)")
}

print()

var dias_da_semana: [String] = ["segunda", "terça", "quarta", "quinta", "sexta", "sábado", "domingo"]

for dia in dias_da_semana {
    print("Hoje é \(dia)")
}

var nomes = ["Joao", "Zezinho", "Jonas"]

print(nomes[0...2])

let dez_vezes = 1...10

for i in dez_vezes{
    print(i)
}

//MARK: -While

var contador = 0
var num: Int = 0

while num != 100 {
    num = Int.random(in: 1...1000)
    contador += 1
}

print("O codigo foi rodado \(contador) vezes")

//MARK: - Continue e Break

var divisiveis: Int = 0
let numero = 6
var range = Int.random(in: 1...100000)

for i in 1...range {
    if !i.isMultiple(of: numero){
        continue
    }
    
     divisiveis += 1
}

print("De 1 até \(range) existem \(divisiveis) número(s) divisível(is) por \(numero)")

//MARK: - Checkpoint 3

for i in 1...100{
    if i.isMultiple(of: 3) && i.isMultiple(of: 5){
        print("FizzBuzz")
    }
    else if i.isMultiple(of: 3){
        print("Fizz")
    }
    else if i.isMultiple(of: 5){
        print("Buzz")
    }
    else{
        print(i)
    }
    
}

//Se meu print(i) tivesse fora do ciclo faz sentido o continue
