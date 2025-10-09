import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        // Profile icon (clickable to profile)
                        NavigationLink(destination: ContentView2()) {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                )
                        }
                        
                        // Logo and Title
                        VStack(spacing: 0) {
                            Text("*")  // Placeholder for logo, replace with Image("logo") later
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                            Text("FraudX")
                                .font(Font.custom("Inter", size: 24).weight(.bold))
                                .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                        }
                        
                        Spacer()
                        
                        // Search icon (clickable to search screen)
                        NavigationLink(destination: SearchView()) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    // Tabs: Comunidad (selected), Ranking
                    HStack(spacing: 16) {
                        Text("Comunidad")
                            .font(Font.custom("Roboto", size: 16).weight(.medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                            .cornerRadius(20)
                        
                        NavigationLink(destination: RankingView()) {
                            Text("Ranking")
                                .font(Font.custom("Roboto", size: 16).weight(.medium))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(red: 0.27, green: 0.35, blue: 0.39), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Scrollable posts
                    ScrollView {
                        VStack(spacing: 16) {
                            // Post 1
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.white)
                                        )
                                    
                                    Text("User 1")
                                        .font(Font.custom("Roboto", size: 16).weight(.medium))
                                        .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                }
                                
                                Text("Categoria: categoria 1")
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(Color.gray)
                                
                                Text("URL: example.com")
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(Color.gray)
                                
                                Text("Al momento de querer comprar en esta página, al momento de pagar se robaron datos de tarjeta, ponganse trucha")
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                
                                // Image placeholder
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 150)
                                    .cornerRadius(8)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                            .font(.largeTitle)
                                    )
                                
                                // Date in bottom right
                                HStack {
                                    Spacer()
                                    Text("21/10/25")
                                        .font(Font.custom("Roboto", size: 12))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            
                            // Post 2
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.5))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.white)
                                        )
                                    
                                    Text("Usuario anónimo")
                                        .font(Font.custom("Roboto", size: 16).weight(.medium))
                                        .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                }
                                
                                Text("Categoria: categoria 2")
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(Color.gray)
                                
                                Text("URL: example.com")
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(Color.gray)
                                
                                Text("Llegan correos de una cuenta de \"Amazon\" con")
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                
                                // Date in bottom right
                                HStack {
                                    Spacer()
                                    Text("21/10/25")
                                        .font(Font.custom("Roboto", size: 12))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            
                            // Add more posts as needed for scrolling
                        }
                        .padding()
                    }
                }
                
                // Bottom navigation
                VStack {
                    Spacer()
                    HStack {
                        // Inicio (selected)
                        VStack {
                            Image(systemName: "house.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Inicio")
                                .font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
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
                        
                        // Prevencion
                        NavigationLink(destination: PreventionView()) {
                            VStack {
                                Image(systemName: "rosette")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.gray)
                                Text("Prevencion")
                                    .font(Font.custom("Roboto", size: 10))
                                    .foregroundColor(Color.gray)
                            }
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

// Placeholder views for navigation




struct HistorialView: View {
    var body: some View {
        Text("Historial")
            .navigationTitle("Historial")
    }
}


// Assume ProfileView is from previous code

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
