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
    // Función de ayuda para los mensajes de error
    private func errorText(error: String?, yOffset: CGFloat) -> some View {
        Text(error ?? "") // Si es nil, se muestra vacío
            .font(.caption)
            .foregroundColor(.red)
            .frame(width: 320, alignment: .leading)
            .offset(x: 0, y: yOffset)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    Text("Crear cuenta")
                        .font(Font.custom("Inter", size: 20).weight(.medium))
                        .lineSpacing(28)
                        .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                        .offset(x: 0, y: -372.50)
                    
                    Text("Únete a FraudX")
                        .font(Font.custom("Inter", size: 30).weight(.semibold))
                        .lineSpacing(36)
                        .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                        .offset(x: 0, y: -280)
                    
                    
                    Text("Nombre de usuario")
                        .font(Font.custom("Roboto", size: 14))
                        .lineSpacing(20)
                        .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                        .frame(width: 320, alignment: .leading)
                        .offset(x: 0, y: -230)
                    
                    TextField("", text: $viewModel.name, prompt: Text("Tu nombre").font(Font.custom("Roboto", size: 16)).foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43).opacity(0.8))).focused($focusedField, equals: .name)
                        .font(Font.custom("Roboto", size: 16))
                        .padding(.horizontal, 16)
                        .frame(width: 320, height: 40)
                        .background(.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.34, green: 0.36, blue: 0.43).opacity(0.5), lineWidth: 1)
                        )
                        .offset(x: 0, y: -195)
                    
                    errorText(error: viewModel.nameTouched ? viewModel.errorName: nil,yOffset: -167)
                    
                    Text("Correo electrónico")
                        .font(Font.custom("Roboto", size: 14))
                        .lineSpacing(20)
                        .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                        .frame(width: 320, alignment: .leading)
                        .offset(x: 0, y: -154)
                    
                    
                    TextField("", text: $viewModel.email, prompt: Text("nombre@ejemplo.com").font(Font.custom("Roboto", size: 16)).foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43).opacity(0.8))).focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress) // Añadido para mejor UX
                        .autocapitalization(.none)
                        .font(Font.custom("Roboto", size: 16))
                        .padding(.horizontal, 16)
                        .frame(width: 320, height: 40)
                        .background(.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.34, green: 0.36, blue: 0.43).opacity(0.5), lineWidth: 1)
                        )
                        .offset(x: 0, y: -123)
                    
                    
                    errorText(error: viewModel.emailTouched ? viewModel.errorEmail: nil,yOffset: -90)
                    
                    
                    Text("Contraseña")
                        .font(Font.custom("Roboto", size: 14))
                        .lineSpacing(20)
                        .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                        .frame(width: 320, alignment: .leading)
                        .offset(x: 0, y: -70)
                    
                    SecureField("", text: $viewModel.password, prompt: Text("Ingresa tu contraseña").font(Font.custom("Roboto", size: 16)).foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43).opacity(0.8))).focused($focusedField, equals: .password)
                        .font(Font.custom("Roboto", size: 16))
                        .padding(.horizontal, 16)
                        .frame(width: 320, height: 40)
                        .background(.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.34, green: 0.36, blue: 0.43).opacity(0.5), lineWidth: 1)
                        )
                        .offset(x: 0, y: -35)
                    
                    
                    errorText(error: viewModel.passwordTouched ? viewModel.errorPassword: nil,yOffset: 5)
                    
                    
                    Text("Confirmar contraseña")
                        .font(Font.custom("Roboto", size: 14))
                        .lineSpacing(20)
                        .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                        .frame(width: 320, alignment: .leading)
                        .offset(x: 0, y: 35)
                    
                    SecureField("", text: $viewModel.confirmPassword, prompt: Text("Repite tu contraseña").font(Font.custom("Roboto", size: 16)).foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43).opacity(0.8))).focused($focusedField, equals: .confirmPassword)
                        .font(Font.custom("Roboto", size: 16))
                        .padding(.horizontal, 16)
                        .frame(width: 320, height: 40)
                        .background(.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.34, green: 0.36, blue: 0.43).opacity(0.5), lineWidth: 1)
                        )
                        .offset(x: 0, y: 70)
                    
                    
                    errorText(error: viewModel.confirmPasswordTouched ? viewModel.errorConfirmPassword : nil, yOffset: 100)
                    
                    
                    HStack(spacing: 8) {
                        Button {
                            viewModel.acepto.toggle()
                        } label: {
                            Image(systemName: viewModel.acepto ? "checkmark.square.fill" : "square")
                            // Enlazado a viewModel.acepto
                                .foregroundColor(viewModel.acepto ? .blue : Color(red: 0.34, green: 0.36, blue: 0.43))
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
                    .frame(width: 320, alignment: .leading)
                    // Ajustamos el offset para compensar el espacio de los errores
                    .offset(x: 0, y: 135)
                    
                    // 7. Botón de Registro (Controlado por viewModel.puedeRegistrar)
                    NavigationLink(destination: PREV_login()) {
                        Text("Registrarse")
                            .font(Font.custom("Roboto", size: 16).weight(.semibold))
                            .lineSpacing(22)
                            .foregroundColor(.white)
                            .frame(width: 320, height: 40)
                        // Color dinámico según la validez
                            .background(viewModel.puedeRegistrar ? Color(red: 0.27, green: 0.35, blue: 0.39) : Color.gray)
                            .cornerRadius(20)
                    }
                    .buttonStyle(.plain)
                    // Deshabilita el enlace de navegación si las restricciones fallan
                    .disabled(!viewModel.puedeRegistrar)
                    // Llama a la lógica de registro
                    .simultaneousGesture(TapGesture().onEnded {
                        viewModel.registrarUsuario()
                    })
                    // Ajustamos el offset para compensar el espacio de los errores
                    .offset(x: 0, y: 195)
                }
                .frame(width: 375, height: 844)
                .background(Color.white)
                .offset(x: -2, y: -4)
            }
            .frame(width: 393, height: 852)
            .background(.white)
            .offset(x: 0, y: 0)
            .shadow(
                color: Color(red: 0.07, green: 0.06, blue: 0.16, opacity: 0.12), radius: 6, y: 3
            )
            .navigationBarHidden(true)
            
            .onChange(of: focusedField) { oldValue, newValue in
                // Si el foco se pierde (newValue es nil), marcamos el campo anterior como "tocado"
                if let newField = newValue {
                    switch newField {
                    case .name: viewModel.nameTouched = true
                    case .email: viewModel.emailTouched = true
                    case .password: viewModel.passwordTouched = true
                    case .confirmPassword: viewModel.confirmPasswordTouched = true
                    }
                    // Y ejecutamos la validación para actualizar el mensaje de error
                    viewModel.validarTodosLosCampos()
                }
            }
            .onChange(of: viewModel.name) { _ in viewModel.validarTodosLosCampos() }
            .onChange(of: viewModel.email) { _ in viewModel.validarTodosLosCampos() }
            
        }
    }
}
    
// Placeholder for TermsView
struct TermsView: View {
    var body: some View {
        Text("Términos y Condiciones")
            .navigationTitle("Términos")
    }
}

struct ContentView_Previews_Inicio: PreviewProvider {
    static var previews: some View {
    PREVIEW_Inicio()
    }
}
