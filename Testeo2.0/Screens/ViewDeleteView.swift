import SwiftUI

struct ViewDeleteView: View {
    let incidentId: Int

    @State private var url: String = ""
    @State private var descriptionText: String = ""
    @State private var isAnonymous: Bool = false
    @State private var selectedCategory: String = "Categoría"
    @State private var photoImage: Image? = Image(systemName: "photo")

    @State private var isLoading = false
    @State private var isDeleting = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var confirmDelete = false

    private let api = ReportsAPI()
    private let baseURLString = "http://10.48.251.159:3000"

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.opacity(0.9).ignoresSafeArea()
                

                ScrollView {
                    VStack(spacing: 32) {
                        
                        Text("Tu Incidente")
                            .font(Font.custom("Inter", size: 24).weight(.semibold))
                            .foregroundColor(.black)
                            .padding(.top, 10)

                        // URL (solo lectura)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("URL del Incidente")
                                .font(Font.custom("Roboto", size: 14))
                                .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))

                            HStack {
                                Image(systemName: "link")
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                TextField("", text: .constant(url))
                                    .font(Font.custom("Roboto", size: 16))
                                    .foregroundColor(.gray)
                                    .disabled(true)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 1)

                            Text("Enlace directo a la página web")
                                .font(Font.custom("Roboto", size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)

                        // Descripción (solo lectura)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Descripción del Incidente")
                                .font(Font.custom("Roboto", size: 14))
                                .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))

                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                TextEditor(text: .constant(descriptionText))
                                    .font(Font.custom("Roboto", size: 16))
                                    .foregroundColor(.gray)
                                    .frame(minHeight: 100)
                                    .multilineTextAlignment(.leading)
                                    .disabled(true)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.white)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                        }
                        .padding(.horizontal)

                        // Anónimo (visible, no editable) + Categoría (solo texto)
                        HStack {
                            Toggle(isOn: .constant(isAnonymous)) {
                                Text("Anónimo")
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color.gray))
                            .disabled(true)

                            Spacer()

                            HStack {
                                Text(selectedCategory)
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(.gray.opacity(0.6))
                                    
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                            .padding()
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(20)
                            .shadow(radius: 1)
                        }
                        .padding(.horizontal)

                        // Evidencia Foto (solo vista)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Evidencia Foto")
                                .font(Font.custom("Inter", size: 20).weight(.semibold))
                                .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))

                            if let photoImage = photoImage {
                                photoImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)

                        Spacer()

                        // Eliminar reporte
                        Button {
                            confirmDelete = true
                        } label: {
                            HStack {
                                if isDeleting {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Eliminar reporte")
                                        .font(Font.custom("Roboto", size: 16).weight(.semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal)
                        .disabled(isDeleting)
                    }
                    .padding(.top, 40)
                }
            }
            .background(Color.white)
            .overlay { if isLoading { ProgressView().scaleEffect(1.2) } }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Aviso"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .confirmationDialog(
                "¿Eliminar este reporte?",
                isPresented: $confirmDelete,
                titleVisibility: .visible
            ) {
                Button("Eliminar", role: .destructive) { Task { await deleteReport() } }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Esta acción no se puede deshacer. Se realizará un borrado lógico.")
            }
            .onAppear { Task { await loadDetail() } }
        }
    
    }

    private func loadDetail() async {
        await MainActor.run { isLoading = true }
        defer { Task { await MainActor.run { isLoading = false } } }

        do {
            let detail = try await api.fetchReportDetail(id: incidentId)
            await MainActor.run {
                self.url = detail.pageURL ?? ""
                self.descriptionText = detail.description ?? ""
                self.isAnonymous = detail.anonymous!
                self.selectedCategory = detail.category ?? "Categoría"
            }

            if let path = detail.image,
               let full = makeAbsoluteURL(from: path),
               let ui = try? await downloadImage(from: full) {
                await MainActor.run { self.photoImage = Image(uiImage: ui) }
            } else {
                await MainActor.run { self.photoImage = Image(systemName: "photo") }
            }
        } catch {
            await MainActor.run {
                self.alertMessage = "No se pudo cargar el reporte (#\(incidentId)): \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }

    private func deleteReport() async {
        await MainActor.run { isDeleting = true }
        defer { Task { await MainActor.run { isDeleting = false } } }
        do {
            try await api.deleteReport(id: incidentId)
            await MainActor.run {
                self.alertMessage = "Reporte eliminado correctamente."
                self.showAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.dismiss()
                }
            }
        } catch {
            await MainActor.run {
                self.alertMessage = "No se pudo eliminar: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }

    private func makeAbsoluteURL(from path: String) -> URL? {
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return URL(string: baseURLString + "/" + trimmed)
    }

    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        guard let img = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        return img
    }
}

struct ViewDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        ViewDeleteView(incidentId: 1)
    }
}
