import UIKit

var name:String = "José Teixeira"

print(name.count)
print(name.uppercased())

print(name.hasPrefix("José "))
print(name.hasPrefix("J"))

print("\n")

print(name.hasSuffix("Teixeira"))
print(name.hasSuffix("a"))

let numero = 963

print("\n\(numero.isMultiple(of: 3))")


let tempC: Double = 23.4

var temF = (tempC * 9)/5 + 32


///Checkpoint 1
print("\nEm Celsius a temperatura é de \(tempC)ºC em Fahrenheit é de \(temF)ºF")
