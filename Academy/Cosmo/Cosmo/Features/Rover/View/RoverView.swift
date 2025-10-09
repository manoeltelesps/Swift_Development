//
//  RoverView.swift
//  Cosmo
//
//  Created by Débora Cristina Silva Ferreira on 04/07/25.
//

import SwiftUI

struct RoverView: View {
    @StateObject private var viewModel = RoverViewModel()
    @State private var showingFullDescription = false
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    (
                        Text(roverExtraInfo[viewModel.completedRovers.first?.roverName ?? ""]?.description.prefix(150) ?? "")
                            .font(.callout)
                        + Text(" Mais" + " ... ").font(.callout).bold()
                    )
                    .font(.body)
                    .onTapGesture {
                        showingFullDescription = true
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Imagens mais recentes").font(.title2).bold()
                        ForEach(viewModel.completedRovers) { rover in
                            
                            AsyncImage(url: rover.imageUrl) { phase in
                                switch phase {
                                case .success(let image):
                                    HStack(alignment: .top, spacing: 12) {
                                        image
                                            .resizable()
                                            .frame(width: 170, height: 130)
                                            .cornerRadius(20)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Data terrestre: \(rover.earthDate)")
                                            Text("Câmera: \(rover.cameraName)")
                                            Text("Rover: \(rover.roverName)")
                                        }
                                        .font(.caption)
                                    }
                                    
                                case .empty:
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                    
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    Spacer(minLength: 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .task {
                    await viewModel.loadPhotos(sol: 4516, page: 1, camera: nil)
                }
            }
            .navigationTitle("Curiosity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: FilterView()) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(8)
                    }
                }
            }
        }
        
        .sheet(isPresented: $showingFullDescription) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Rover Curiosity")
                    .font(.title2)
                    .bold()
                    .padding()
                
                ScrollView {
                    Text(roverExtraInfo[viewModel.completedRovers.first?.roverName ?? ""]?.description ?? "")
                        .font(.body)
                        .padding()
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    RoverView()
}
