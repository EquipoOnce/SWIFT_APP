import SwiftUI

struct RankingView: View {
    @State private var items: [TopDomainItemDTO] = []
    @State private var isLoading = false
    @State private var errorText: String?

    private let api = ReportsAPI()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Lista
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Top URLs mas reportadas")
                                .font(Font.custom("Inter", size: 20).weight(.semibold))
                                .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                .padding(.horizontal)
                                .padding(.top, 20)

                            if let errorText {
                                Text(errorText)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }

                            if items.isEmpty && !isLoading && errorText == nil {
                                Text("No hay elementos")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            }

                            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                                // Respetamos TU lógica: ir a SearchView(query: url)
                                let query = item.url ?? ""

                                NavigationLink(destination: SearchView(query: query)) {
                                    HStack {
                                        Text("\(idx + 1)")
                                            .font(Font.custom("Roboto", size: 16).weight(.medium))
                                            .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                            .frame(width: 30, alignment: .leading)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.category ?? "—")
                                                .font(Font.custom("Roboto", size: 14))
                                                .foregroundColor(.gray)
                                            Text("Url: \(displayHost(from: query))")
                                                .font(Font.custom("Roboto", size: 14))
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                        }

                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                                    .opacity(query.isEmpty ? 0.5 : 1)
                                }
                                .disabled(query.isEmpty)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .refreshable { await loadData() }
                }

                // Bottom navigation (igual que tenías)
                 

                if isLoading { ProgressView().scaleEffect(1.1) }
            }
            .navigationBarHidden(true)
            .onAppear { Task { await loadData() } }
        }
    }

    // MARK: - Data
    private func loadData() async {
        await MainActor.run { isLoading = true; errorText = nil }
        defer { Task { await MainActor.run { isLoading = false } } }

        do {
            // Ajusta window/limit si quieres
            let rs = try await api.fetchTopDomains(windowDays: 30, limit: 10, offset: 0)
            await MainActor.run { self.items = rs }
        } catch {
            await MainActor.run { self.errorText = "Error al cargar ranking: \(error.localizedDescription)" }
        }
    }

    // MARK: - Helpers
    private func displayHost(from raw: String) -> String {
        // Muestra bonito el host (sin esquema ni path);
        // si no es URL válida, regresa el raw truncado.
        if let url = URL(string: raw), let host = url.host {
            return host
        }
        // Intento simple si viene sin esquema
        if let url = URL(string: "https://\(raw)"), let host = url.host {
            return host
        }
        return raw
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}
