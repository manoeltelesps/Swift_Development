import UIKit

var times: [String] = ["Vasco", "Atlético", "Palmeiras"]

times.append("Cruzeiro")

print(times.count)

times.remove(at: 1)
print(times)

times.contains("Vasco")

print(times.sorted())

var timesInvertido = times.reversed()

print(timesInvertido)

var endereco: [String: String] = [
    "rua" : "",
    "numero" : "S/N",
    "complemento" : "Predio Azul"
]
print(endereco["numero", default: "Número Desconhecido"])

endereco["numeri"] = "32"
print(endereco["numeri", default: "Número Desconhecido"])

print(endereco)
endereco.removeValue(forKey: "numeri")
print(endereco)

let capitals = ["England": "London", "Wales": "Cardiff"]
let scotlandCapital = capitals["Scotland"]

var cantores = Set([
    "Gustavo Lima",
    "Marilia Mendonça",
    "Sabrina Carpenter"
])

print(cantores)

cantores.insert("Gustavo Lima")
print(cantores)
