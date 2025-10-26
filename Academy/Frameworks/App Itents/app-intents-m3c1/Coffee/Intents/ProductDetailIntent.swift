//
//  ProductDetailIntent.swift
//  Coffee
//
//  Created by Manoel Pedro Prado Sa Teles on 26/10/25.
//

import AppIntents

// AppIntent representa uma acao que o app consegue executar via Atalhos/Siri.
// Esta intent retorna um Double? (preco) e nao abre o app quando executada.
struct ProductDetailIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Open Product Details"
    static var description = IntentDescription("Show the details of a product in the coffee shop.")
    static var openAppWhenRun: Bool = false
    
    // @Dependency injeta um servico/objeto do seu app configurado no AppDependencyManager
    // Evita singletons aqui e facilita testes
    @Dependency
    var model: Model
    
    // @Parameter define um campo de entrada vindo do Atalhos/Siri
    // Opcional para que possamos decidir quando pedir o valor via requestValue
    @Parameter(title: "Name", description: "Product name")
    var productName: String?
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Double?> {
        
        // Se o parametro nao veio preenchido pelo Atalhos, pedimos agora
        if productName == nil {
            // IMPORTANTE: usar $productName (binding) para abrir o prompt do sistema
            productName = try await $productName.requestValue("Which product?")
        }
        
        // Aqui garantimos que temos um valor para buscar no dominio do app
        if let productName {
            // Normalmente voce poderia normalizar a string (trim, lowercase, etc.)
            // Ex.: let name = productName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Busca no seu modelo de dados. Se achar, retorna o preco; senao, nil
            if let item = model.find(product: productName) {
                // .result(value:) expoe esse valor como saida encadeavel no Atalhos
                return .result(value: item.price)
            } else {
                // Nao encontrou o produto
                return .result(value: nil)
            }
        } else {
            // Usuario cancelou o prompt ou ficou sem valor valido
            return .result(value: nil)
        }
    }
}
