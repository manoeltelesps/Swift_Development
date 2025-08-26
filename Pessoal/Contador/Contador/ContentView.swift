//
//  ContentView.swift
//  Contador
//
//  Created by Manoel Pedro Prado Sa Teles on 23/08/25.
//

import SwiftUI



struct ContentView: View {
    
    @State private var tentativas = 0
    let salvarChave = "tentativasKey"
    
    var body: some View {
        
        ZStack{
            Image("Image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("Tentativas \(tentativas)")
                    .padding()
                    .font(.title)
                    .background()
                    .cornerRadius(10)
                
                Button("Mortes"){
                    tentativas += 1
                    UserDefaults.standard.set(tentativas, forKey: salvarChave)
                }
                .font(.title)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)

                Button("Zerar") {
                    tentativas = 0
                    UserDefaults.standard.set(tentativas, forKey: salvarChave)
                }
                .font(.title2)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .onAppear {
                tentativas = UserDefaults.standard.integer(forKey: salvarChave)
            }
        }
        
        
    }
}




#Preview {
    ContentView()
}
