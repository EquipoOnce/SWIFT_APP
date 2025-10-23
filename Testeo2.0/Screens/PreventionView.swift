import SwiftUI

struct PreventionView: View {
    
    // Placeholder URLs for links (replace with actual ones)
    let infographicItems = [
        ("Manuales de apoyo", "Manuales de recuperacion de cuenta y de respaldo ", "https://redporlaciberseguridad.org/manuales/", "https://redporlaciberseguridad.org/wp-content/uploads/2025/01/ransomware-2320941_1280.jpg"),
        ("Articulos de apoyo", "variedad de contenidos educativos y de actualidad sobre temas relacionados con la ciberseguridad", "https://redporlaciberseguridad.org/articulos-de-apoyo/", "https://redporlaciberseguridad.org/wp-content/uploads/2023/06/BANNER-WEBINAR-TODOS-11.png.webp"),
        ("Conocenos", "Nuestra misión es fortalecer el ecosistema de ciberseguridad en México y Latinoamérica", "https://redporlaciberseguridad.org/acerca-de/", "https://redporlaciberseguridad.org/wp-content/uploads/2024/03/Academia-1536x1003.png")
    ]
    
    let resourceItems = [
        ("Pagina principal", "Pagina de Red por la ciberseguridad", "https://redporlaciberseguridad.org/"),
        ("Conoce nuestros cursos", "Explora cursos sobre Ciberseguridad, Inteligencia Artificial y más, impartidos por expertos de Red por la Ciberseguridad.", "https://academia.redporlaciberseguridad.org/")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.opacity(0.9)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Title
                    Text("Materiales de Prevención")
                        .font(Font.custom("Inter", size: 24).weight(.semibold))
                        .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                        .padding(.top, 20)
                    
                    // Infografías Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Infografías para la Prevención")
                            .font(Font.custom("Inter", size: 20).weight(.semibold))
                            .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                            .padding(.horizontal)
                        
                        // Carousel
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(infographicItems, id: \.0) { item in
                                    let (_, _, link, imageURL) = item
                                    Link(destination: URL(string: link)!) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            // AsyncImage for the image
                                            AsyncImage(url: URL(string: imageURL)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 200, height: 150)
                                            .cornerRadius(8)
                                            
                                            Text(item.0)
                                                .font(Font.custom("Roboto", size: 16).weight(.medium))
                                                .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                            
                                            Text(item.1)
                                                .font(Font.custom("Roboto", size: 14))
                                                .foregroundColor(Color.gray)
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                                        .frame(width: 220)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 250)
                    }
                    
                    // Recursos Web Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recursos Web Útiles")
                            .font(Font.custom("Inter", size: 20).weight(.semibold))
                            .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                            .padding(.horizontal)
                        
                        ForEach(resourceItems, id: \.0) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.0)
                                        .font(Font.custom("Roboto", size: 16).weight(.medium))
                                        .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                    
                                    Text(item.1)
                                        .font(Font.custom("Roboto", size: 14))
                                        .foregroundColor(Color.gray)
                                }
                                
                                Spacer()
                                
                                Link(destination: URL(string: item.2)!) {
                                    Text("Ver >")
                                        .font(Font.custom("Roboto", size: 14))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                
                // Bottom Navigation (same as HomeView)
                VStack {
                    Spacer()
                    HStack {
                        // Inicio
                        NavigationLink(destination: HomeView()) {
                            VStack {
                                Image(systemName: "house")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.gray)
                                Text("Inicio")
                                    .font(Font.custom("Roboto", size: 10))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Registrar Incidente
                        NavigationLink(destination: RegisterIncidentView()) {
                            VStack {
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.gray)
                                Text("Registrar Incidente")
                                    .font(Font.custom("Roboto", size: 10))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Historial
                        NavigationLink(destination: HistorialView()) {
                            VStack {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.gray)
                                Text("Historial")
                                    .font(Font.custom("Roboto", size: 10))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Prevencion (selected)
                        VStack {
                            Image(systemName: "rosette")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Prevención")
                                .font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct PreventionView_Previews: PreviewProvider {
    static var previews: some View {
        PreventionView()
    }
}
