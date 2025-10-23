import SwiftUI

struct ContentView2: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isLoggingOut = false
    @State private var logoutError: String? = nil
    @State private var goToLogin = false
    
    private let profileAPI = ProfileAPI()
    private let authAPI = AuthAPI()
    
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
                    Text("Perfil")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                    
                    // invisible spacer para balancear
                    Color.clear.frame(width: 60, height: 1)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
                
                Divider().background(Color.gray.opacity(0.5))
                
                ScrollView {
                    if isLoading {
                        ProgressView("Cargando Perfil...").padding(.top, 24)
                    } else if let errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding(.top, 24)
                    } else {
                        VStack(spacing: 32) {
                            // Avatar
                            Circle()
                                .fill(Color.green.opacity(0.46))
                                .frame(width: 100, height: 100)
                                .overlay(Image(systemName: "person")
                                    .foregroundColor(.white)
                                    .font(.system(size: 50)))
                            
                            VStack(spacing: 8) {
                                Text(name).font(.system(size: 24, weight: .medium))
                                Text(email).font(.system(size: 16)).foregroundColor(.blue)
                            }
                            
                            // Sección
                            Text("Opciones de la Cuenta")
                                .font(.system(size: 20, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 24)
                            
                            // Editar perfil
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
                            
                            // Cerrar sesión (acción real)
                            Button {
                                Task { await logout() }
                            } label: {
                                HStack {
                                    if isLoggingOut {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Cerrar Sesión")
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(16)
                            }
                            .padding(.horizontal)
                            .disabled(isLoggingOut)
                            
                            if let logoutError {
                                Text("No se pudo cerrar sesión: \(logoutError)")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                            
                            // Navegación programática a tu login
                            NavigationLink(destination: PREV_login(), isActive: $goToLogin) {
                                EmptyView()
                            }
                            .hidden()
                        }
                        .padding(.top, 40)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .task { await loadProfile() }
        }
    }
    
    // MARK: - Data
    private func loadProfile() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let me = try await profileAPI.fetchMe()
            self.name = me.name
            self.email = me.email
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Logout
    private func logout() async {
        logoutError = nil
        isLoggingOut = true
        defer { isLoggingOut = false }
        
        guard let access = TokenStorage.get(.access),
              let refresh = TokenStorage.get(.refresh) else {
            sessionManager.logout()
            return // <-- Importante: termina la función si no hay tokens
        }
        
        do {
            try await authAPI.logout(accessToken: access, refreshToken: refresh)
            sessionManager.logout()
        } catch {
            logoutError = error.localizedDescription
            // Si deseas forzar salida aún con error:
            // sessionManager.logout()
        }
    }
    
    
    struct ContentView_Previews2: PreviewProvider {
        static var previews: some View {
            ContentView2()
        }
    }
}
