//
//  ContentView.swift
//  Cosmo
//
//  Created by Manoel Pedro Prado Sa Teles on 02/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            Tab ("Today's Cosmos", systemImage: "apple.image.playground.fill") {
                    todayImageView()
                }
            Tab ("Cosmic archive", systemImage: "book") {
                TelaBiblioteca()
            }
            Tab ("Mars in Focus", systemImage: "globe") {
                RoverView()
            }
        }
    }
}


#Preview {
    ContentView()
}
