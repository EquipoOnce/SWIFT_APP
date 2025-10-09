import SwiftUI

struct ContentView2: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isLoading =  true
    @State private var errorMessage: String? = nil
    
    private let api = ProfileAPI()
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Header with Back Button
                HStack {
                    NavigationLink(destination: HomeView()) {
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
                    Text("Perfil")
                        .font(.system(size: 20, weight: .medium))
                    
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
                
                // Separator (Divider)
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                // Main Content Below Separator
                ScrollView {
                    if isLoading{
                        ProgressView("Cargando Perfil...").padding(.top, 24)
                    }else if let errorMessage {
                        Text("Error: \(errorMessage)").foregroundColor(.red).padding(.top, 24)
                    } else{
                        VStack(spacing: 32) {
                            // Profile Picture and Info
                            Circle()
                                .fill(Color.green.opacity(0.46)) // Matching green
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person")
                                        .foregroundColor(.white)
                                        .font(.system(size: 50))
                                )
                            
                            VStack(spacing: 8) {
                                Text(name)
                                    .font(.system(size: 24, weight: .medium))
                                Text(email)
                                    .font(.system(size: 16))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                            
                            
                            // Account Details
                            Text("Opciones de la Cuenta")
                                .font(.system(size: 20, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(45)
                            
                            // Boton de editar
                            NavigationLink(destination: EditView()) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.white)
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
                            
                            
                            
                            // Logout Button
                            NavigationLink(destination: PREV_login()) {
                                HStack {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.white)
                                    Text("Cerrar Sesión")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(16)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 40)
                    }
                }
                .background(Color.white)
                .navigationBarHidden(true)
                .task {await loadProfile()}
            }
    
    private func loadProfile() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let me = try await api.fetchMe()
            self.name = me.name
            self.email = me.email
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
        
}




struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
