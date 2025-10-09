//
//  File.swift
//  Testeo2.0
//
//  Created by Usuario on 08/10/25.
//

import Foundation

import SwiftUI

struct EditView2: View {
    // Campos visibles
    @State private var nombre: String = ""
    @State private var correo: String = ""

    // Copia para diffs
    @State private var original: PublicProfileDTO? = nil

    // Estados UI
    @State private var isLoading = true
    @State private var isSaving  = false
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil

    private let api = ProfileAPI()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    NavigationLink(destination: ContentView2()) {
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
                    Text("Editar perfil").font(.system(size: 18, weight: .medium))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)

                ScrollView {
                    if isLoading {
                        ProgressView("Cargando perfil…").padding(.top, 20)
                    } else {
                        if let errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding(.top, 8)
                        }
                        if let successMessage {
                            Text(successMessage)
                                .foregroundColor(.green)
                                .padding(.top, 8)
                        }

                        // Nombre
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nombre").font(.system(size: 14))
                            TextField("Nombre", text: $nombre)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled(true)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(.white)
                                .cornerRadius(20)
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)

                        // Correo
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Correo").font(.system(size: 14))
                            TextField("Correo", text: $correo)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(.white)
                                .cornerRadius(20)
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)

                        // Guardar
                        Button {
                            Task { await saveChanges() }
                        } label: {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.27, green: 0.43, blue: 0.39))
                                    .cornerRadius(16)
                            } else {
                                Text("Guardar cambios")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.27, green: 0.43, blue: 0.39))
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 28)
                        .disabled(!hasChanges || isSaving)
                        .opacity(!hasChanges ? 0.5 : 1.0)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
        .task { await loadProfile() }
    }

    private var hasChanges: Bool {
        guard let o = original else { return false }
        return nombre != o.name || correo != o.email
    }

    private func loadProfile() async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        defer { isLoading = false }
        do {
            let me = try await api.fetchMe()
            self.original = me
            self.nombre = me.name
            self.correo = me.email
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    private func saveChanges() async {
        guard let original = original else { return }
        isSaving = true
        errorMessage = nil
        successMessage = nil
        defer { isSaving = false }

        // Calcula patch parcial
        let namePatch: String?  = (nombre != original.name)  ? nombre : nil
        let emailPatch: String? = (correo != original.email) ? correo : nil

        // Evita llamada vacía (tu back tiraría "Nada que actualizar")
        guard namePatch != nil || emailPatch != nil else {
            successMessage = "No hay cambios por guardar."
            return
        }

        do {
            // PATCH sin body de respuesta
            try await api.updateProfile(name: namePatch, email: emailPatch)

            // Refresca para mostrar lo que quedó persistido en DB
            let me = try await api.fetchMe()
            self.original = me
            self.nombre = me.name
            self.correo = me.email
            self.successMessage = "Perfil actualizado correctamente."
        } catch {
            // Si fue 409 (email en uso) u otro error, el RequestExecutor lo mapea a error
            self.errorMessage = "No se pudo guardar. Revisa el correo o intenta más tarde. Detalle: \(error.localizedDescription)"
        }
    }
}
