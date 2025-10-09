//
//  EditView.swift
//  Testeo2.0
//
//  Created by Iker on 04/10/25.
//

import SwiftUI

struct EditView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    
    @State private var original: PublicProfileDTO? = nil
    
    
    @State private var isLoading = true
    @State private var isSaving = false
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil
    
    private let api = ProfileAPI()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HStack {
                    NavigationLink(destination: ContentView2()) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Atrás").font(.system(size: 16, weight: .heavy))
                        }
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.27, green: 0.50, blue: 0.39).opacity(0.22))
                        .cornerRadius(20)
                    }
                    Spacer()
                    Text("Editar perfil")
                        .font(.system(size: 18, weight: .medium))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
                
                // Main Content
                ScrollView {
                    
                    if isLoading {
                        ProgressView("Cargando perfil...").padding(.top, 20)
                    } else{
                        if let errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding(.top, 8)
                        }
                        if let successMessage {
                            Text("\(successMessage)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.green)
                                .padding(.top, 8)
                        }
                        
                        
                        VStack(spacing: 32) {
                            // Main Title
                            Text("Edición de perfil")
                                .font(.system(size: 24, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.top, 40)
                            
                            // Nombre Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nombre")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                TextField("", text: $name)
                                    .font(.system(size: 16))
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(20)
                            }
                            .padding(.horizontal)
                            
                            // Correo Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Correo Electrónico")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                TextField("", text: $email)
                                    .font(.system(size: 16))
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(20)
                            }
                        }
                        .padding()
                        
                        Spacer()
                        
                        // Boton de guardar
                        Button{
                            Task { await saveChanges()}
                        } label: {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.27, green: 0.43, blue: 0.39))
                                    .cornerRadius(16)
                            } else {
                                Text("Editar")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
        .task{await loadProfile()}
    }
    
    private var hasChanges: Bool {
        guard let o = original else { return false }
        return name != o.name || email != o.email
    }
    
    private func loadProfile() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let me = try await api.fetchMe()
            self.original = me
            self.name = me.name
            self.email = me.email
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
        let namePatch: String?  = (name != original.name)  ? name : nil
        let emailPatch: String? = (email != original.email) ? email : nil
        
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
            self.name = me.name
            self.email = me.email
            self.successMessage = "Perfil actualizado correctamente."
        } catch {
            // Si fue 409 (email en uso) u otro error, el RequestExecutor lo mapea a error
            self.errorMessage = "No se pudo guardar. Revisa el correo o intenta más tarde. Detalle: \(error.localizedDescription)"
        }
    }
}
        


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
