//
//  prueba.swift
//  Testeo2.0
//
//  Created by Usuario on 08/10/25.
//

import Foundation

import SwiftUI

struct ContentView100: View {
    @State private var nombre: String = ""
    @State private var correo: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    private let api = ProfileAPI()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    NavigationLink(destination: HomeView()) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Atrás").font(.system(size: 16, weight: .heavy))
                        }
                        .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.27, green: 0.50, blue: 0.39).opacity(0.22))
                        .cornerRadius(20)
                    }
                    Spacer()
                    Text("Perfil").font(.system(size: 20, weight: .medium))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)

                Divider().background(Color.gray.opacity(0.5))

                ScrollView {
                    if isLoading {
                        ProgressView("Cargando perfil…").padding(.top, 24)
                    } else if let errorMessage {
                        Text("Error: \(errorMessage)").foregroundColor(.red).padding(.top, 24)
                    } else {
                        VStack(spacing: 12) {
                            Text(nombre)
                                .font(.system(size: 24, weight: .medium))
                            Text(correo)
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 20)
                    }

                    // Botón Editar
                    NavigationLink(destination: EditView()) {
                        HStack {
                            Image(systemName: "pencil").foregroundColor(.white)
                            Text("Editar perfil")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.27, green: 0.43, blue: 0.39))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
        .task { await loadProfile() }
    }

    private func loadProfile() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let me = try await api.fetchMe()
            self.nombre = me.name
            self.correo = me.email
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
