//
//  TabView.swift
//  Intent
//
//  Created by Manoel Pedro Prado Sa Teles on 26/10/25.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        
        TabView {
            
            ContentView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            
             Favoritos()
                .tabItem{
                    Image(systemName: "star")
                    Text("Favoritos")
                }
        }
    }
}

#Preview {
    RootTabView()
}
