//
//  ContentView.swift
//  AppleWatchBuy
//
//  Created by Manoel Pedro Prado Sa Teles on 17/10/25.
//

import StoreKit
import SwiftUI
import Combine

@MainActor
class ViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    func fetchProducts() {
        Task {
            do {
                let ids = ["manoel.com.br.WatchApple.AppleWatchBuy"]
                let result = try await Product.products(for: ids)
                self.products = result
            } catch {
                print("erro ao carregar products: \(error)")
            }
        }
    }
    
    func buy(_ product: Product) {
        Task {
            do {
                let res = try await product.purchase()
                print(res) // TODO: tratar success/cancel/verification
            } catch {
                print("erro na compra: \(error)")
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var vm = ViewModel()

    var body: some View {
        VStack {
            Image(systemName: "applelogo")
                .resizable().scaledToFit().frame(width: 70).padding()

            Text("Apple Store").font(.largeTitle).padding()

            Image("Watch")
                .resizable().scaledToFit().frame(width: 300, height: 300).padding()

            // mostra o primeiro product so para exemplo
            if let p = vm.products.first {
                Button {
                    vm.buy(p)
                } label: {
                    Text("Comprar \(p.displayPrice)")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            } else {
                Button("Carregar produtos") { vm.fetchProducts() }
                    .padding()
            }
        }
        .padding()
        .task { vm.fetchProducts() } // carrega ao abrir a tela
    }
}

#Preview {
    ContentView()
}
