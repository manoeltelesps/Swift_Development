import UIKit


///Escopo
func somarNumero (num1: Int, num2: Int) -> Int {
    
    var x: Int
    
    x = num1 + num2
    
    return x
}

print(somarNumero(num1: 4, num2: 3))

func multiplicarNumero (_ num3: Int, _ num4: Int) -> Int {
    
    var y: Int
    
    y = num3 * num4
    
    return y
}

print(multiplicarNumero(4, 4))

///Retornos

func ePar (_ num: Int) -> Bool {
    if num % 2 == 0 {
        return true
    }
    else{
        return false
    }
}

print(ePar(6))

if ePar(4){
    print("O número é par")
}
else {
    print("Não é par")
}
