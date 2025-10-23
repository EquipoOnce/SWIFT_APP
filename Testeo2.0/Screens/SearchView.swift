import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var searchText: String = ""
    @State private var selectedCategoryName: String? = nil

    // ⚠️ Ajusta los IDs a los de tu BD
    private let categoriesWithIds: [(name: String, id: Int)] = [
        ("Tecnología", 1),
        ("Viajes", 2),
        ("Negocios", 3),
        ("Redes Sociales", 4),
        ("Educación", 10)
    ]
    var categories: [String] { categoriesWithIds.map(\.name) }

    // Resultados
    @State private var results: [PublicSearchItemDTO] = []
    @State private var isLoading = false
    @State private var errorText: String? = nil

    // Red
    private let api = ReportsAPI()
    private let baseURLString = "http://10.48.251.159:3000"

    // Debounce
    @State private var searchTask: Task<Void, Never>?

    init(query: String = "") {
        _searchText = State(initialValue: query)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top bar compacta con título centrado
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Atrás")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .overlay(
                        Text("Buscar Incidentes")
                            .font(.system(size: 18, weight: .medium))
                    )

                    // Search field
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        TextField("Buscar por URL o dominio", text: $searchText)
                            .font(.system(size: 16))
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .onChange(of: searchText) { _ in
                                selectedCategoryName = nil
                                debounceSearch()
                            }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.vertical, 6)

                    // Chips de categoría (compacto)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { cat in
                                let selected = (selectedCategoryName == cat)
                                Button {
                                    selectedCategoryName = cat
                                    searchText = ""
                                    Task { await searchByCategory(cat) }
                                } label: {
                                    Text(cat)
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(selected ? Color.gray : Color.white)
                                        .foregroundColor(selected ? .white : .gray)
                                        .cornerRadius(20)
                                        .shadow(radius: 1)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 44)

                    // Título
                    Text("Resultado de Búsqueda")
                        .font(.system(size: 20, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    // Lista de resultados
                    ScrollView {
                        if let errorText {
                            Text(errorText)
                                .foregroundColor(.red)
                                .padding()
                        }

                        if results.isEmpty && !isLoading && errorText == nil {
                            Text("Sin resultados")
                                .foregroundColor(.secondary)
                                .padding(.top, 40)
                        }

                        VStack(spacing: 16) {
                            ForEach(results) { item in
                                SearchResultCard(item: item, baseURLString: baseURLString)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 80)
                    }
                }

                // Bottom nav (igual)
                VStack {
                    Spacer()
                    HStack {
                        VStack {
                            Image(systemName: "house.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Inicio").font(.system(size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                        }.frame(maxWidth: .infinity)

                        NavigationLink(destination: RegisterIncidentView()) {
                            VStack {
                                Image(systemName: "doc.text.fill").font(.system(size: 24)).foregroundColor(.gray)
                                Text("Registrar Incidente").font(.system(size: 10)).foregroundColor(.gray)
                            }
                        }.frame(maxWidth: .infinity)

                        NavigationLink(destination: HistorialView()) {
                            VStack {
                                Image(systemName: "clock.fill").font(.system(size: 24)).foregroundColor(.gray)
                                Text("Historial").font(.system(size: 10)).foregroundColor(.gray)
                            }
                        }.frame(maxWidth: .infinity)

                        NavigationLink(destination: PreventionView()) {
                            VStack {
                                Image(systemName: "rosette").font(.system(size: 24)).foregroundColor(.gray)
                                Text("Prevención").font(.system(size: 10)).foregroundColor(.gray)
                            }
                        }.frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
                }

                if isLoading { ProgressView().scaleEffect(1.1) }
            }
            .navigationBarHidden(true)
            .onAppear {
                if !searchText.isEmpty { debounceSearch(initial: true) }
            }
        }
    }

    // MARK: - Búsquedas
    private func debounceSearch(initial: Bool = false) {
        searchTask?.cancel()
        searchTask = Task { [searchText] in
            if !initial { try? await Task.sleep(nanoseconds: 500_000_000) } // 0.5s
            await searchByQuery(searchText)
        }
    }

    private func searchByQuery(_ query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            await MainActor.run { self.results = [] ; self.errorText = nil }
            return
        }

        await MainActor.run { self.isLoading = true; self.errorText = nil }
        defer { Task { await MainActor.run { self.isLoading = false } } }

        // Heurística: si parece URL (tiene "://" o "/"), mandamos como url; si no, como dominio
        let looksLikeURL = trimmed.contains("://") || trimmed.contains("/")
        do {
            let rs = try await api.publicSearch(domain: looksLikeURL ? nil : trimmed,
                                                url: looksLikeURL ? trimmed : nil,
                                                categoryId: nil,
                                                order: "newest",
                                                limit: 50,
                                                offset: 0)
            await MainActor.run { self.results = rs }
        } catch {
            await MainActor.run { self.errorText = "Error: \(error.localizedDescription)" }
        }
    }

    private func searchByCategory(_ name: String) async {
        let id = categoriesWithIds.first(where: { $0.name == name })?.id
        await MainActor.run { self.isLoading = true; self.errorText = nil }
        defer { Task { await MainActor.run { self.isLoading = false } } }

        do {
            let rs = try await api.publicSearch(domain: nil,
                                                url: nil,
                                                categoryId: id,
                                                order: "newest",
                                                limit: 50,
                                                offset: 0)
            await MainActor.run { self.results = rs }
        } catch {
            await MainActor.run { self.errorText = "Error: \(error.localizedDescription)" }
        }
    }
}

// MARK: - Card de resultado
private struct SearchResultCard: View {
    let item: PublicSearchItemDTO
    let baseURLString: String

    var dateDisplay: String {
        let out = DateFormatter()
        out.dateFormat = "dd/MM/yy"
        if let d = isoToDate(item.createdAt!) { return out.string(from: d) }
        return ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {   // más compacto
            // Reporter
            HStack {
                Circle().fill(Color.green).frame(width: 40, height: 40)
                    .overlay(Text((item.reporter ?? "Anon").prefix(1)).foregroundColor(.white))
                Text(item.reporter ?? "Anonymous")
                    .font(.system(size: 16, weight: .medium))
            }

            Text("Categoría: \(item.category ?? "—")")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            if let url = item.url {
                Text("URL: \(url)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Text(item.description ?? "—")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            // Imagen (si hay)
            if let path = item.imageURL,
               let full = absoluteURL(from: path, base: baseURLString) {
                AsyncImage(url: full) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(Color.gray.opacity(0.2))
                            .frame(height: 150).cornerRadius(8)
                    case .success(let img):
                        img.resizable().scaledToFit().frame(height: 150).cornerRadius(8)
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }

            HStack {
                Spacer()
                Text(dateDisplay).font(.system(size: 12)).foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 150)
            .cornerRadius(8)
            .overlay(Image(systemName: "photo").foregroundColor(.gray).font(.largeTitle))
    }

    private func absoluteURL(from path: String, base: String) -> URL? {
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return URL(string: base + "/" + trimmed)
    }
}

// MARK: - Helpers de fecha (ISO8601 con/sin milisegundos)
private func isoToDate(_ iso: String) -> Date? {
    let f1 = ISO8601DateFormatter()
    f1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let d = f1.date(from: iso) { return d }

    let f2 = ISO8601DateFormatter()
    f2.formatOptions = [.withInternetDateTime]
    return f2.date(from: iso)
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
