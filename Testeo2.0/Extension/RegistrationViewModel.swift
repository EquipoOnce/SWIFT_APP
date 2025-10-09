//
//  RegistrationViewModel.swift
//  Testeo2.0
//
//  Created by Usuario on 06/10/25.
//
import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    
    // Propiedades enlazadas a los campos de la vista
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var acepto: Bool = false
    
    // Propiedades para mensajes de error
    @Published var errorName: String?
    @Published var errorEmail: String?
    @Published var errorPassword: String?
    @Published var errorConfirmPassword: String?
    
    @Published var nameTouched: Bool = false
    @Published var emailTouched: Bool = false
    @Published var passwordTouched: Bool = false
    @Published var confirmPasswordTouched: Bool = false
    
    // La restricción principal: solo true si todos los campos son válidos
    var puedeRegistrar: Bool {
        return name.esNombreValido &&
               email.esCorreoValido &&
               password.esContrasenavalida &&
               password == confirmPassword &&
               acepto
    }
    
    // Función que valida y prepara el envío
    func registrarUsuario() {
        nameTouched = true
        emailTouched = true
        passwordTouched = true
        confirmPasswordTouched = true
        
        validarTodosLosCampos()
        
        guard puedeRegistrar else { return }
        
        //falta el task para mandar los datos
        let payload = RegistrationRequest(
                email: email,
                name: name,
                password: password,
            )
        
        Task {
            do{
                try await HTTPClient().UserRegistration(payload)
                print("Registro exitoso.")
            } catch {
                print("Error al registrarse:", error.localizedDescription)
            }
        }
    }
    
    func validarTodosLosCampos() {
        
        // Nombre
        if nameTouched {
            errorName = name.esNombreValido ? nil : "El nombre debe tener al menos 2 caracteres."
        } else {
            errorName = nil // Oculta si no ha sido tocado
        }

        // Email
        if emailTouched {
            errorEmail = email.esCorreoValido ? nil : "El formato del correo electrónico no es válido."
        } else {
            errorEmail = nil
        }

        // Contraseña
        if passwordTouched {
            errorPassword = password.esContrasenavalida ? nil : "Formato de contraseña inválido."
        } else {
            errorPassword = nil
        }

        // Confirmar contraseña
        if confirmPasswordTouched {
            if password.esVacio || confirmPassword.esVacio {
                errorConfirmPassword = "Confirma la contraseña."
            } else if password != confirmPassword {
                errorConfirmPassword = "Las contraseñas no coinciden."
            } else {
                errorConfirmPassword = nil
            }
        } else {
            errorConfirmPassword = nil
        }
    }
    
}

