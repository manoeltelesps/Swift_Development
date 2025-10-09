//
//  ContentView.swift
//  Requisicao
//
//  Created by Manoel Pedro Prado Sa Teles on 29/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PostViewModel()

    var body: some View {
        List(viewModel.posts) { post in
            Text(post.title)
        }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
}

#Preview {
    ContentView()
}
