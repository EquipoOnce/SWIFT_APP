import SwiftUI

private enum Field: Hashable {
    case name
    case email
    case password
    case confirmPassword
}

struct PREVIEW_Inicio: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    @FocusState private var focusedField: Field?
    @State private var mostrarPassword = false
    @State private var mostrarConfirmPassword = false
    
    // 🔹 Controla la transición manual
    @State private var showContentView = false
    
    // Función para mostrar mensajes de error
    private func errorText(error: String?, yOffset: CGFloat) -> some View {
        Text(error ?? "")
            .font(.caption)
            .foregroundColor(.red)
            .frame(width: 320, alignment: .leading)
            .offset(x: 0, y: yOffset)
    }
    
    var body: some View {
        ZStack {
            if showContentView {
                // 🔹 ContentView entra desde la izquierda
                ContentView()
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.35), value: showContentView)
            } else {
                NavigationStack {
                    ZStack(alignment: .topLeading) {
                        Color.white.ignoresSafeArea()
                        
                        VStack(alignment: .leading, spacing: 0) {
                            // 🔙 Botón Back con animación inversa
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    showContentView = true
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .foregroundColor(Color(hex: "#455a64"))
                                .font(.system(size: 16, weight: .semibold))
                            }
                            .padding(.leading, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                            
                            ScrollView {
                                VStack(spacing: 20) {
                                    Text("Crear cuenta")
                                        .font(Font.custom("Inter", size: 20).weight(.medium))
                                        .lineSpacing(28)
                                        .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                    
                                    Text("Únete a FraudX")
                                        .font(Font.custom("Inter", size: 30).weight(.semibold))
                                        .lineSpacing(36)
                                        .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                                    
                                    VStack(spacing: 20) {
                                        
                                        // Nombre
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Nombre de usuario")
                                                .font(Font.custom("Roboto", size: 14))
                                                .lineSpacing(20)
                                                .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                            
                                            TextField("", text: $viewModel.name, prompt: Text("Tu nombre").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                                .focused($focusedField, equals: .name)
                                                .font(Font.custom("Roboto", size: 16))
                                                .padding(.horizontal, 16)
                                                .frame(height: 40)
                                                .background(.white)
                                                .cornerRadius(20)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                                )
                                            
                                            if viewModel.nameTouched, let error = viewModel.errorName {
                                                Text(error)
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        
                                        // Correo
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Correo electrónico")
                                                .font(Font.custom("Roboto", size: 14))
                                                .lineSpacing(20)
                                                .foregroundColor(Color.gray)
                                            
                                            TextField("", text: $viewModel.email, prompt: Text("nombre@ejemplo.com").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                                .focused($focusedField, equals: .email)
                                                .keyboardType(.emailAddress)
                                                .autocapitalization(.none)
                                                .font(Font.custom("Roboto", size: 16))
                                                .padding(.horizontal, 16)
                                                .frame(height: 40)
                                                .background(.white)
                                                .cornerRadius(20)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                                )
                                            
                                            if viewModel.emailTouched, let error = viewModel.errorEmail {
                                                Text(error)
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        
                                        // Contraseña
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Contraseña")
                                                .font(Font.custom("Roboto", size: 14))
                                                .lineSpacing(20)
                                                .foregroundColor(Color.gray)
                                            
                                            HStack {
                                                if mostrarPassword {
                                                    TextField("", text: $viewModel.password, prompt: Text("Ingresa tu contraseña").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                                        .focused($focusedField, equals: .password)
                                                } else {
                                                    SecureField("", text: $viewModel.password, prompt: Text("Ingresa tu contraseña").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                                        .focused($focusedField, equals: .password)
                                                }
                                                
                                                Button(action: { withAnimation { mostrarPassword.toggle() } }) {
                                                    Image(systemName: mostrarPassword ? "eye.slash.fill" : "eye.fill")
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .font(Font.custom("Roboto", size: 16))
                                            .padding(.horizontal, 16)
                                            .frame(height: 40)
                                            .background(.white)
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                            )
                                            
                                            if viewModel.passwordTouched, let error = viewModel.errorPassword {
                                                Text(error)
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        
                                        // Confirmar contraseña
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Confirmar contraseña")
                                                .font(Font.custom("Roboto", size: 14))
                                                .lineSpacing(20)
                                                .foregroundColor(Color.gray)
                                            
                                            HStack {
                                                if mostrarConfirmPassword {
                                                    TextField("", text: $viewModel.confirmPassword, prompt: Text("Repite tu contraseña").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                                        .focused($focusedField, equals: .confirmPassword)
                                                } else {
                                                    SecureField("", text: $viewModel.confirmPassword, prompt: Text("Repite tu contraseña").font(Font.custom("Roboto", size: 16)).foregroundColor(Color.gray.opacity(0.8)))
                                                        .focused($focusedField, equals: .confirmPassword)
                                                }
                                                
                                                Button(action: { withAnimation { mostrarConfirmPassword.toggle() } }) {
                                                    Image(systemName: mostrarConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .font(Font.custom("Roboto", size: 16))
                                            .padding(.horizontal, 16)
                                            .frame(height: 40)
                                            .background(.white)
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                            )
                                            
                                            if viewModel.confirmPasswordTouched, let error = viewModel.errorConfirmPassword {
                                                Text(error)
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    // Checkbox y términos
                                    HStack(spacing: 8) {
                                        Button {
                                            viewModel.acepto.toggle()
                                        } label: {
                                            Image(systemName: viewModel.acepto ? "checkmark.square.fill" : "square")
                                                .foregroundColor(viewModel.acepto ? .blue : Color.gray)
                                        }
                                        .buttonStyle(.plain)
                                        
                                        HStack {
                                            Text("Acepto los")
                                                .font(Font.custom("Roboto", size: 16))
                                                .foregroundColor(.black.opacity(0.7))
                                            NavigationLink(destination: TermsView()) {
                                                Text("términos y condiciones")
                                                    .font(Font.custom("Roboto", size: 14).weight(.semibold))
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 20)
                                    
                                    // Botón de registro
                                    NavigationLink(destination: PREV_login()) {
                                        Text("Registrarse")
                                            .font(Font.custom("Roboto", size: 16).weight(.semibold))
                                            .lineSpacing(22)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 40)
                                            .background(viewModel.puedeRegistrar ? Color(red: 0.27, green: 0.35, blue: 0.39) : Color.gray)
                                            .cornerRadius(20)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(!viewModel.puedeRegistrar)
                                    .simultaneousGesture(TapGesture().onEnded {
                                        viewModel.registrarUsuario()
                                    })
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                }
                            }
                        }
                        .navigationBarHidden(true)
                    }
                    .transition(.move(edge: .trailing)) // 🔹 Sale hacia la derecha
                    .animation(.easeInOut(duration: 0.35), value: showContentView)
                }
            }
        }
        .onChange(of: focusedField) { _, newValue in
            if let newField = newValue {
                switch newField {
                case .name: viewModel.nameTouched = true
                case .email: viewModel.emailTouched = true
                case .password: viewModel.passwordTouched = true
                case .confirmPassword: viewModel.confirmPasswordTouched = true
                }
                viewModel.validarTodosLosCampos()
            }
        }
        .onChange(of: viewModel.name) { _ in viewModel.validarTodosLosCampos() }
        .onChange(of: viewModel.email) { _ in viewModel.validarTodosLosCampos() }
    }
}




struct TermsView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20)
            { Text("Términos y Conduiciones")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Última actualización: Octubre 2025")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("Bienvenido a FraudsX. Al crear una cuenta y navegar dentro de la aplicación, usted acepta cumplir con los presentes Términos y Condiciones. Le recomendamos leerlos detenidamente antes de continuar. 1.- USO DEL SERVICIO: FraudsX ofrece una plataforma para detectar y reportar sitios web fraudulentos. Usted se compromete a utilizar el servicio únicamente con fines legítimos y conforme a las leyes aplicables. 2.- CUENTA DE USUARIO : Usted es responsable de mantener la confidencialidad de sus credenciales y de toda actividad que ocurra bajo su cuenta. En caso de algun uso irregular en su cuenta, favor de avisar a soporte. 3.- PRIVACIDAD : Los datos personales que proporcione serán tratados con nuestra política de seguridad, nos comprometemos a no compartir sus datos con terceros salvo en temas legales. 4.- MODIFICACIONES: Nos reservamos el derecho de modificar estos términos en cualquier momento. Cualquier cambio será notificado. 5.- Para dudas o comentarios sobre estos términos, puede contactar a soporte al correo: soporte@fraudsx.com. o al teléfono: 011 15 4955 1111.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Text("Al continuar con su registro, usted acepta plenamente estos Términos y Condiciones")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("Términos y Condiciones - FraudsX")
    }
}


//Preview
struct ContentView_Previews_Inicio: PreviewProvider {
    static var previews: some View {
        PREVIEW_Inicio()
    }
}
