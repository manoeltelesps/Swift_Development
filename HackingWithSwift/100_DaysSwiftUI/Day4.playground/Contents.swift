import UIKit

///Checkpoint 2
let jogos: [String] = [
    "Need For Speed",
    "God of War",
    "Valorant",
    "Celeste",
    "Celeste"
]

print("Tem \(jogos.count) os quais são \(jogos)")

let jogosUnicos = Set(jogos)

print("Unicos são \(jogosUnicos.count) os que são \(jogosUnicos)")
