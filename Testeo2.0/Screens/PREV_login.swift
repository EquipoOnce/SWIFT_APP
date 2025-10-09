import SwiftUI

struct PREV_login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @Environment(\.authController) var authenticationController
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    @State private var goHome: Bool = false
    
    private func login() async {
        do{
            isLoggedIn = try await
                authenticationController.loginUser(email:email, password: password)
            print("Usuario login exitoso  \(isLoggedIn)")
            if isLoggedIn{
                goHome = true
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    
                    // Título superior
                    Text("Bienvenido de Nuevo")
                        .font(Font.custom("Inter", size: 30).weight(.medium))
                        .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                        .padding(.top, 60)
                    
                    // Tarjeta
                    VStack(spacing: 40) {
                        
                        Text("Iniciar Sesión")
                            .font(Font.custom("Inter", size: 24).weight(.semibold))
                            .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                        
                        // Correo
                        HStack(spacing: 8) {
                            Image(systemName: "envelope")
                                .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                            TextField("", text: $email, prompt: Text("Correo electrónico")
                                .font(Font.custom("Roboto", size: 16))
                                .foregroundColor(Color.gray.opacity(0.8)))
                                .font(Font.custom("Roboto", size: 16))
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                        
                        // Contraseña
                        HStack(spacing: 8) {
                            Image(systemName: "lock")
                                .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                            SecureField("", text: $password, prompt: Text("Contraseña")
                                .font(Font.custom("Roboto", size: 16))
                                .foregroundColor(Color.gray.opacity(0.8)))
                                .font(Font.custom("Roboto", size: 16))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                        
                        // Botón Entrar
                        Button {
                            Task { await login()}
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
                        
                        // Footer: texto + botón registrarse
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
    }
}

struct Prev_login_Previews: PreviewProvider {
    static var previews: some View {
        PREV_login()
    }
}
