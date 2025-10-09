//
//  todayImageView.swift
//  Cosmo
//
//  Created by Manoel Pedro Prado Sa Teles on 02/07/25.
//

import SwiftUI

struct todayImageView: View {
    @StateObject private var viewModel = TodayImageViewModel()
    @State private var isFlipped: Bool = false
    
    var body: some View {
        VStack {
           
            HStack {
                Text("Today's Cosmos")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Botão de refresh
                Button(action: {
                    Task {
                        await viewModel.refreshImage()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .disabled(viewModel.isRefreshing)
                .rotationEffect(.degrees(viewModel.isRefreshing ? 360 : 0))
                .animation(viewModel.isRefreshing ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: viewModel.isRefreshing)
            }
            .padding([.top, .leading, .trailing])
            
            // Indicador de loading apenas na primeira vez
            if viewModel.isLoading && viewModel.apod == nil {
                Spacer()
                ProgressView("Carregando imagem do dia...")
                    .font(.headline)
                Spacer()
            } else {
                Spacer()
                
                ZStack {
                    if !isFlipped {
                        cardFront
                    } else {
                        cardBack
                    }
                }
                .frame(width: 300, height: 450)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.spring(), value: isFlipped)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isFlipped.toggle()
                    }
                }
                
                Spacer()
            }
            
            // Mensagem de erro
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .task {
            // Usar loadImageIfNeeded para aproveitar cache
            await viewModel.loadImageIfNeeded()
        }
    }
    
    // Face frente
    private var cardFront: some View {
        ZStack(alignment: .bottomLeading) {
            if let urlString = viewModel.apod?.url,
               let url = URL(string: urlString),
               viewModel.apod?.media_type == "image" {
                
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 350, height: 550)
                .clipped()
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.55))
                )

            } else {
                Color.gray
                    .frame(width: 350, height: 550)
                    .cornerRadius(16)
            }
            Text(viewModel.apod?.title ?? "Carregando...")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .bottom], 16)
                .shadow(radius: 10)
        }
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
    
    // Face fundo
    private var cardBack: some View {
        ZStack(alignment: .bottomLeading) {
            if let urlString = viewModel.apod?.url,
               let url = URL(string: urlString),
               viewModel.apod?.media_type == "image" {
                
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 350, height: 550)
                .clipped()
                .cornerRadius(16)
                .opacity(0.4)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.55))
                )

            } else {
                Color.gray
                    .frame(width: 350, height: 550)
                    .cornerRadius(16)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.apod?.title ?? "Carregando...")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(viewModel.apod?.date ?? "Carregando...")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                Text(viewModel.apod?.explanation ?? "Carregando...")
                    .font(.body)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                Spacer()
                Text(viewModel.apod?.copyright ?? "Sem informações")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(16)
        }
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

#Preview {
    todayImageView()
}
