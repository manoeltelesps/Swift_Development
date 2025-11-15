import UIKit

// MARK: - Singleton

// Nonisolated
class Logger{
    nonisolated(unsafe) static let shared = Logger()
    // static let shared = Logger
    private init() { }

    func log(message: String) {
        print(message)
    }
}

Logger.shared.log(message: "Hello World")

// Actor
actor Teste {
    static let shared = Teste()
    
    private init() { }
    
    func teste(message: String){
        print(message)
    }
}

Task {
    await Teste.shared.teste(message: "Hello World")
}



