import Foundation

@MainActor
class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        // Al iniciar la app, verifica si hay tokens guardados
        if TokenStorage.get(.access) != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }

    func loginSucceeded(accessToken: String, refreshToken: String) {
        // Guarda tokens en Keychain y marca sesión activa
        TokenStorage.set(.access, value: accessToken)
        TokenStorage.set(.refresh, value: refreshToken)
        isLoggedIn = true
    }

    func logout() {
        // Borra tokens y marca sesión como cerrada
        TokenStorage.clearSession()
        isLoggedIn = false
    }
}
