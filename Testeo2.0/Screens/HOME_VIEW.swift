import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .comunidad  // Enum for tabs

    
    enum Tab {
        case comunidad, ranking
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header (common to both screens)
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
                        VStack(spacing: 4) {
                            AsyncImage(url: URL(string: "https://redporlaciberseguridad.org/wp-content/uploads/2025/09/Logo-escudo-negro-scaled.png")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 30, height: 30)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    Image(systemName: "photo")
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.gray)
                                }
                            }
                            
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
                    
                    // Tabs: Comunidad (selected by default), Ranking
                    HStack(spacing: 16) {
                        Button {
                            selectedTab = .comunidad
                        } label: {
                            Text("Comunidad")
                                .font(Font.custom("Roboto", size: 16).weight(.medium))
                                .foregroundColor(selectedTab == .comunidad ? .white : Color(red: 0.27, green: 0.35, blue: 0.39))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(selectedTab == .comunidad ? Color(red: 0.27, green: 0.35, blue: 0.39) : Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedTab == .comunidad ? Color.clear : Color(red: 0.27, green: 0.35, blue: 0.39), lineWidth: 1)
                                )
                        }
                        
                        Button {
                            selectedTab = .ranking
                        } label: {
                            Text("Ranking")
                                .font(Font.custom("Roboto", size: 16).weight(.medium))
                                .foregroundColor(selectedTab == .ranking ? .white : Color(red: 0.27, green: 0.35, blue: 0.39))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(selectedTab == .ranking ? Color(red: 0.27, green: 0.35, blue: 0.39) : Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedTab == .ranking ? Color.clear : Color(red: 0.27, green: 0.35, blue: 0.39), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Dynamic content (no animation)
                    Group {
                        if selectedTab == .comunidad {
                            HomeViewContent()  // Comunidad content with API
                        } else {
                            RankingView()  // Ranking content (adapt as needed)
                        }
                    }
                    .animation(nil, value: selectedTab)  // No animation on switch
                    
                    // Bottom navigation (common)
                    HStack {
                        // Inicio (selected for Home/Main)
                        VStack {
                            Image(systemName: "house.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Inicio")
                                .font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                        }
                        .frame(maxWidth: .infinity)
                        
                        NavigationLink(destination: RegisterIncidentView()) {
                            VStack {
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                                Text("Registrar Incidente")
                                    .font(Font.custom("Roboto", size: 10))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        NavigationLink(destination: HistorialView()) {
                            VStack {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                                Text("Historial")
                                    .font(Font.custom("Roboto", size: 10))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        NavigationLink(destination: PreventionView()) {
                            VStack {
                                Image(systemName: "rosette")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                                Text("Prevención")
                                    .font(Font.custom("Roboto", size: 10))
                                    .foregroundColor(.gray)
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

// Comunidad content (adapted from provided HomeView)
struct HomeViewContent: View {
    @State private var posts: [PublicSearchItemDTO] = []
    @State private var isLoading = false
    @State private var errorText: String? = nil

    // API
    private let api = ReportsAPI()
    private let baseURLString = "http://10.48.251.159:3000"

    var body: some View {
        // Feed
        ScrollView {
            if let errorText {
                Text(errorText)
                    .foregroundColor(.red)
                    .padding()
            }

            if posts.isEmpty && !isLoading && errorText == nil {
                Text("No hay publicaciones")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
            }

            VStack(spacing: 16) {
                ForEach(posts) { item in
                    FeedPostCard(item: item, baseURLString: baseURLString)
                }
            }
            .padding()
        }
        .refreshable { await loadFeed() }
        .onAppear { Task { await loadFeed() } }
    }

    // MARK: - Carga del feed
    private func loadFeed() async {
        await MainActor.run { isLoading = true; errorText = nil }
        defer { Task { await MainActor.run { isLoading = false } } }

        do {
            let rs = try await api.publicFeed(order: "newest", limit: 50, offset: 0, windowDays: 180)
            await MainActor.run { self.posts = rs }
        } catch {
            await MainActor.run { self.errorText = "Error al cargar feed: \(error.localizedDescription)" }
        }
    }
}

// Ranking content (adapt as needed – placeholder for now)
struct RankingViewContent: View {
    var body: some View {
        ScrollView {
            Text("Contenido de Ranking – Top URLs, etc.")
                .padding()
        }
    }
}

// MARK: - Card de post (idéntica lógica a SearchResultCard, con imagen opcional y fecha)
private struct FeedPostCard: View {
    let item: PublicSearchItemDTO
    let baseURLString: String

    var dateDisplay: String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yy"
        if let d = isoToDate(item.createdAt!) { return f.string(from: d) }
        return ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Reporter
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 40, height: 40)
                    .overlay(Text((item.reporter ?? "Anon").prefix(1)).foregroundColor(.white))
                Text(item.reporter ?? "Anonymous")
                    .font(Font.custom("Roboto", size: 16).weight(.medium))
                    .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
            }

            Text("Categoría: \(item.category ?? "—")")
                .font(Font.custom("Roboto", size: 14))
                .foregroundColor(.gray)

            if let url = item.url {
                Text("URL: \(url)")
                    .font(Font.custom("Roboto", size: 14))
                    .foregroundColor(.gray)
            }

            Text(item.description ?? "—")
                .font(Font.custom("Roboto", size: 14))
                .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))

            // Imagen (si hay)
            if let path = item.imageURL,
               let full = absoluteURL(from: path, base: baseURLString) {
                AsyncImage(url: full) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(Color.gray.opacity(0.2))
                            .frame(height: 150)
                            .cornerRadius(8)
                            .overlay(Image(systemName: "photo").foregroundColor(.gray))
                    case .success(let img):
                        img.resizable().scaledToFit().frame(height: 150).cornerRadius(8)
                    case .failure:
                        Rectangle().fill(Color.gray.opacity(0.2))
                            .frame(height: 150)
                            .cornerRadius(8)
                            .overlay(Image(systemName: "photo").foregroundColor(.gray))
                    @unknown default:
                        Rectangle().fill(Color.gray.opacity(0.2))
                            .frame(height: 150)
                            .cornerRadius(8)
                            .overlay(Image(systemName: "photo").foregroundColor(.gray))
                    }
                }
            }

            HStack {
                Spacer()
                Text(dateDisplay)
                    .font(Font.custom("Roboto", size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }

    private func absoluteURL(from path: String, base: String) -> URL? {
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return URL(string: base + "/" + trimmed)
    }
}

// MARK: - Helper de fecha (ISO8601 con/sin milisegundos)
private func isoToDate(_ iso: String) -> Date? {
    let f1 = ISO8601DateFormatter()
    f1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let d = f1.date(from: iso) { return d }

    let f2 = ISO8601DateFormatter()
    f2.formatOptions = [.withInternetDateTime]
    return f2.date(from: iso)
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
