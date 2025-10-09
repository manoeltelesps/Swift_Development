//
//  CuriosityView.swift
//
//
//  Created by Andreas Gomes Marchi on 04/07/25.
//

import SwiftUI

struct FilterView: View {
    
    @StateObject private var viewModel = RoverViewModel()
    
    @State private var sol: String = "1000"
    @State private var page: String = "1"
    @State private var selectedCamera: String = "Todos"

    let cameras = ["Todos", "FHAZ", "RHAZ", "MAST", "CHEMCAM", "NAVCAM"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Filtros de busca").font(.headline)) {
                    HStack {
                        Text("Dia marciano (Sol)")
                            .frame(width: 149, alignment: .leading)
                        TextField("Ex: 1000", text: $sol)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("Número da página")
                            .frame(width: 150, alignment: .leading)
                        TextField("Ex: 1", text: $page)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Picker("Câmera", selection: $selectedCamera) {
                        ForEach(cameras, id: \.self) { camera in
                            Text(camera).tag(camera)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section {
                    Button("Buscar Fotos") {
                        UIApplication.shared.hideKeyboard()
                        Task {
                            await viewModel.loadPhotos(
                                sol: Int(sol) ?? 1000,
                                page: Int(page) ?? 1,
                                camera: selectedCamera == "Todos" ? nil : selectedCamera
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Loading Indicador (boas práticas)
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Carregando fotos...")
                            .padding(.top, 4)
                        Spacer()
                    }
                }
                
                //Error message (boas práticas)
                if let error = viewModel.errorMessage {
                    Text("Erro: \(error)")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                        .multilineTextAlignment(.center)
                }
                
                Section(header: Text("Fotos encontradas")) {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.completedRovers, id: \.id) { rover in
                                AsyncImage(url: rover.imageUrl) { phase in
                                    if let image = phase.image {
                                        VStack(alignment: .leading, spacing: 10) {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 300, height: 200)
                                                .clipped()
                                                .cornerRadius(10)

                                            Text("Data: \(rover.earthDate)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .scrollDismissesKeyboard(.immediately)
                }
            }
            .navigationTitle("Curiosity Photos")
        }
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    FilterView()
}
