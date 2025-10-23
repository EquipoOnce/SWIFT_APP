import SwiftUI

struct tutorialView: View {
    @State private var currentScreen = 0
    
    var body: some View {
        ZStack {
            Group {
                if currentScreen == 0 {
                    WelcomeScreen(currentScreen: $currentScreen)
                } else if currentScreen == 1 {
                    IncidentGuideScreen(currentScreen: $currentScreen)
                } else {
                    AdditionalFeaturesScreen(currentScreen: $currentScreen)
                }
            }
        }
    }
}

// MARK: - Pantalla 1: Bienvenida
struct WelcomeScreen: View {
    @Binding var currentScreen: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack {
                Text("Bienvenido a la Comunidad")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.gray800)
                    .padding(.top, 32)
            }
            
            // Illustration
            VStack {
                AsyncImage(url: URL(string: "https://www.digitalbizmagazine.com/wp-content/uploads/2025/07/cultura-ciberseguridad_sosafe01-e1753962792918.jpg")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray600)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250)
                .padding(.vertical, 32)
            }
            .frame(maxHeight: .infinity)
            
            // Content
            VStack(spacing: 16) {
                Text("Descubre Comunidad Segura")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.gray800)
                
                Text("Únete a nuestra plataforma dedicada a la gestión de incidentes y la seguridad comunitaria. Contribuye activamente para prevenir riesgos, mantener tu entorno seguro y fomentar una red de apoyo mutuo.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray600)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            
            // Button
            Button(action: { currentScreen = 1 }) {
                Text("Siguiente")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.gray700)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.gray50, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

// MARK: - Pantalla 2: Gestión de Incidentes
struct IncidentGuideScreen: View {
    @Binding var currentScreen: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { currentScreen = 0 }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                    }
                    .foregroundColor(.gray600)
                }
                
                Text("Guía de Gestión de Incidentes")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray800)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .overlay(Divider(), alignment: .bottom)
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Paso 1
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 20))
                                .foregroundColor(.gray600)
                            
                            Text("1. Registrar un Nuevo Incidente")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray800)
                        }
                        
                        Text("Aprende a reportar cualquier suceso o situación en tu comunidad de forma rápida y sencilla, asegurando que todos estén informados.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.gray600)
                            .lineLimit(nil)
                            .padding(.leading, 32)
                    }
                    
                    // Paso 2
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "book")
                                .font(.system(size: 20))
                                .foregroundColor(.gray600)
                            
                            Text("2. Describir el Incidente")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray800)
                        }
                        
                        Text("Detalla la información que se te pide y una descripción clara de lo ocurrido para una mejor comprensión y seguimiento.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.gray600)
                            .lineLimit(nil)
                            .padding(.leading, 32)
                    }
                    
                    // Paso 3
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.gray600)
                            
                            Text("3. Confianza en la publicación")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray800)
                        }
                        
                        Text("Los administradores pueden revisar y aprobar los incidentes, garantizando la fiabilidad de la información en la plataforma.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.gray600)
                            .lineLimit(nil)
                            .padding(.leading, 32)
                    }
                }
                .padding(24)
            }
            
            // Button
            Button(action: { currentScreen = 2 }) {
                Text("Siguiente")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.gray700)
                    .cornerRadius(8)
            }
            .padding(24)
            .background(Color.white)
            .overlay(Divider(), alignment: .top)
        }
        .background(Color.white)
    }
}

// MARK: - Pantalla 3: Funciones Adicionales
struct AdditionalFeaturesScreen: View {
    @Binding var currentScreen: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { currentScreen = 1 }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                    }
                    .foregroundColor(.gray600)
                }
                
                Text("Guía de Funciones Adicionales")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray800)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .overlay(Divider(), alignment: .bottom)
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Explora Más Funciones")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.gray800)
                        
                        Text("Descubre otros materiales que pueden ayudarte y ayudar a más personas")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.gray600)
                    }
                    .padding(.bottom, 8)
                    
                    // Feature 1
                    HStack(alignment: .top, spacing: 12) {
                        Text("💡")
                            .font(.system(size: 28))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Consejos de Prevención")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray800)
                            
                            Text("En a pestaña de \"prevención\" podrás encontrar un acceso directo a nuestra página web y adicionalmente encontrarás material que te puede ayudar")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.gray600)
                                .lineLimit(nil)
                        }
                    }
                    
                    // Feature 2
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.gray600)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ranking de Participación")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray800)
                            
                            Text("El ranking nos ayuda a saber tendencias en cuanto a URIs más reportadas")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.gray600)
                                .lineLimit(nil)
                        }
                    }
                }
                .padding(24)
            }
            
            // Button
            NavigationLink(destination: PREVIEW_Inicio()) {
                Text("Finalizar")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.gray700)
                    .cornerRadius(8)
            }
            .padding(24)
            .background(Color.white)
            .overlay(Divider(), alignment: .top)
        }
        .background(Color.white)
    }
}

// MARK: - Colors
extension Color {
    static let gray50 = Color(red: 0.98, green: 0.98, blue: 0.98)
    static let gray600 = Color(red: 0.47, green: 0.53, blue: 0.60)
    static let gray700 = Color(red: 0.29, green: 0.34, blue: 0.42)
    static let gray800 = Color(red: 0.11, green: 0.13, blue: 0.16)
}

#Preview {
    tutorialView()
}
