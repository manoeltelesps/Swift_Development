//
//  ContentView.swift
//  StoreKitEstudo
//
//  Created by Manoel Pedro Prado Sa Teles on 15/10/25.
//

import SwiftUI
import StoreKit

//Essa classe verificada se o botão foi clicado e guarda os ids que deram certo no onInAppPurchaseCompletion a partir desses ids que posso mostrar novas coisas com minha variável instaciada dela, como foi na linha 29.
@Observable
class StoreManager{
    var isShowingSubs = false
    var purchasedSubscription: Set<String> = []
}


struct ContentView: View {
    
    @State var vm = StoreManager()
    
    var body: some View {
        VStack {
            Button("Inscrições"){
                vm.isShowingSubs.toggle()
            }
            
            //Essa lista pega os ids que assinaram e que estam salvos no meu Set, entao tipo o id 1 esta dentro do meu set após ter sido inserido na linha 45, eu vou mostrar ele aqui, obvio que pode ter outras funções coisas que eu posso usar com ele com esse variavel.purchasedSubscription
            List(Array(vm.purchasedSubscription), id: \.self){
                Text($0)
            }
        }
        .padding()
        .sheet(isPresented: $vm.isShowingSubs){
            
            // Forma padrão do Store Kit de demonstrar as opções de assinaturas, ele pega o ID do meu grupo de Assinaturas para demonstrar as opções
            SubscriptionStoreView(groupID: "BA70103F")
        }
        //A compra é registrada no Apple ID do usuário, é idenpendente do codigo
        .onInAppPurchaseCompletion { product, purchaseResult in
            guard case .success(let verificationResult) = purchaseResult,
                  case .success(_) = verificationResult else {
                //TODO: Errors Handle
                return
            }
            
            vm.purchasedSubscription.insert(product.id)
            vm.isShowingSubs.toggle()
        }
        
    }
}

#Preview {
    ContentView()
}
