import SwiftUI

@main
struct Testeo2_0App: App {
    @StateObject private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            if sessionManager.isLoggedIn {
                HomeView()
                    .environmentObject(sessionManager)
            } else {
                ContentView()
                    .environmentObject(sessionManager)
            }
        }
    }
}
