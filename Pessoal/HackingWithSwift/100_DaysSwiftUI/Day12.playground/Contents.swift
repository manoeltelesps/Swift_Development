import SwiftUI

//MARK: - Minha primeira Classe
class Banco {
    var dinheiro: Double{
        didSet{
            print("Você tem R$ \(dinheiro)")
        }
    }
    
    init(dinheiro: Double) {
        self.dinheiro = dinheiro
    }
}

var rico: Banco = .init(dinheiro: 100)

rico.dinheiro += 10
print()

//MARK: - Classes Filhas

class Animal{
    let nome: String
    let especie: String
    let som: String
    
    init(nome: String, especie: String, som: String) {
        self.nome = nome
        self.especie = especie
        self.som = som
    }
    
    func emitirSom(){
        print("O \(nome) faz \(som)")
    }
}

class Cachorro: Animal {
    let brinquedo_fav: String
    
    init(nome: String, brinquedo_fav: String) {
            self.brinquedo_fav = brinquedo_fav
            super.init(nome: nome, especie: "Cachorro", som: "Au au")
    }
    
    func brincadeira(){
        print("O \(nome), gosta de brincar, com a(o) sua(seu) \(brinquedo_fav)")
    }
}

let meuDog = Cachorro(nome: "Lampião", brinquedo_fav: "Bola")

meuDog.emitirSom()
print()

//MARK: - Copia

class User {
    var username: String
    
    init(username: String) {
        self.username = username
    }

    func copy() -> User {
        let user = User(username: self.username)
        user.username = username
        return user
    }
}

var user1 = User(username: "Job")
var user2 = user1.copy()

user2.username = "Aiaiaiai"

print(user1.username)
print(user2.username)
print()

//MARK: - Deinit

class Task {
    var idtarefa: String
    
    init(idtarefa: String) {
        self.idtarefa = idtarefa
        print("Tarefa Criada: \(idtarefa)")
    }
    
    deinit{
        print("Tarefa Concluída: \(idtarefa)")
    }
}


var tarefas: [String] = ["Acordar", "Academia", "Estudar", "Minecraft"]
var rotina = [Task]()

for tarefa in tarefas {
    let hoje = Task(idtarefa: tarefa)
    rotina.append(hoje)
}

print()
rotina.removeAll()

//MARK: - Checkpoint 7

class Animals {
    let legs: Int
    
    init(legs: Int) {
        self.legs = legs
    }
}

class Dog: Animals {
    
    init() {
        super.init(legs: 4)
    }
    
    func speak() {
        print("The dog barks!")
    }
}

class Cat: Animals {
    let isTame: Bool
    
    init(legs: Int, isTame: Bool) {
        self.isTame = isTame
        super.init(legs: legs)
    }
    
    func speak(){
        print("The cat meows!")
    }
}

final class Corgie: Dog {
    
    override func speak() {
        print("The Corgie yaps excitedly!")
    }
}

final class Poodle: Dog {
    
    override func speak() {
        print("The Poodle barks gracefully!")
    }
}

final class Persian: Cat {
    
    init(legs: Int) {
        super.init(legs: legs, isTame: true)
    }
    
    override func speak() {
        print("The Persian is tame: \(isTame), and meows softly.")
    }
}

final class Lion: Cat {
    
    init(legs: Int) {
        super.init(legs: legs, isTame: false)
    }
    
    override func speak() {
        print("The Lion is tame: \(isTame), and roars loudly.")
    }
}

print()

let alex = Lion(legs: 4)
alex.speak()

let mydog = Corgie()
mydog.speak()

let hisdog = Poodle()
hisdog.speak()

let hercat = Persian(legs: 3)
hercat.speak()

//MARK: - Extensões

extension [Int]{
    func organizar (_ array: [Int]) -> [Int]{
        array.sorted()
        print(array)
    }
}
    

var a = [3,4,5,6,1]

var b = organizar(a)


