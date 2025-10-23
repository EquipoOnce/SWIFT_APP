import SwiftUI

struct PREV_login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var mostrarPassword = false
    
    @Environment(\.authController) var authenticationController
    @EnvironmentObject var sessionManager: SessionManager   // ✅ Usamos el SessionManager global

    @State private var goHome: Bool = false
    @State private var showContentView = false

    // MARK: - Login
    private func login() async {
        do {
            // Tu método devuelve true/false, pero debe devolver o permitir acceder al token
            // Supongamos que puedes obtener tokens del AuthController al hacer login
            let result = try await authenticationController.loginUser(email: email, password: password)

            if result == true {
                // 🔹 Aquí deberías obtener los tokens que devolvió tu API.
                // Ejemplo: authenticationController guarda el access y refresh token
                if let access = TokenStorage.get(.access),
                   let refresh = TokenStorage.get(.refresh) {
                    sessionManager.loginSucceeded(accessToken: access, refreshToken: refresh)
                } else {
                    // Si tu loginUser devuelve los tokens directamente, usa algo como:
                    // sessionManager.loginSucceeded(accessToken: result.access, refreshToken: result.refresh)
                }

                goHome = true
            }
        } catch {
            print("Error en login:", error.localizedDescription)
        }
    }

    // MARK: - UI
    var body: some View {
        ZStack {
            if showContentView {
                // 🔹 ContentView aparece desde la izquierda
                ContentView()
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.35), value: showContentView)
            } else {
                NavigationStack {
                    ZStack(alignment: .topLeading) {
                        
                        // 🔙 Botón Back con transición inversa
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showContentView = true
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#455a64"))
                            .padding(.leading, 20)
                            .padding(.top, 20)
                        }
                        
                        VStack(spacing: 20) {
                            Text("Bienvenido de Nuevo")
                                .font(Font.custom("Inter", size: 30).weight(.medium))
                                .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                .padding(.top, 60)
                            
                            VStack(spacing: 40) {
                                Text("Iniciar Sesión")
                                    .font(Font.custom("Inter", size: 24).weight(.semibold))
                                    .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                                
                                // 📨 Correo
                                HStack(spacing: 8) {
                                    Image(systemName: "envelope")
                                        .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                    TextField("", text: $email, prompt: Text("Correo electrónico").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                        .font(Font.custom("Roboto", size: 16))
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled(true)
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                
                                // 🔒 Contraseña
                                HStack(spacing: 8) {
                                    Image(systemName: "lock")
                                        .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                    
                                    if mostrarPassword {
                                        TextField("", text: $password, prompt: Text("Contraseña").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                            .font(Font.custom("Roboto", size: 16))
                                    } else {
                                        SecureField("", text: $password, prompt: Text("Contraseña").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                            .font(Font.custom("Roboto", size: 16))
                                    }
                                    
                                    Button(action: { withAnimation { mostrarPassword.toggle() } }) {
                                        Image(systemName: mostrarPassword ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                
                                // 🚪 Botón Entrar
                                Button {
                                    Task { await login() }
                                } label: {
                                    Text("Entrar")
                                        .font(Font.custom("Roboto", size: 16).weight(.semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                                        .cornerRadius(20)
                                }
                                
                                NavigationLink(destination: HomeView(), isActive: $goHome) {
                                    EmptyView()
                                }.hidden()
                                
                                // 🧭 Footer
                                HStack {
                                    Text("¿No tienes cuenta?")
                                        .font(Font.custom("Roboto", size: 16))
                                        .foregroundColor(.black.opacity(0.7))
                                    NavigationLink(destination: PREVIEW_Inicio()) {
                                        Text("Regístrate aquí")
                                            .font(Font.custom("Roboto", size: 14).weight(.semibold))
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.top, 5)
                            }
                            .padding()
                            .frame(width: 340)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                            
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .navigationBarHidden(true)
                }
                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 0.35), value: showContentView)
            }
        }
    }
}

// 🔸 Extensión para color HEX
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}


struct Prev_login_Previews: PreviewProvider {
    static var previews: some View {
        PREV_login()
    }
}
