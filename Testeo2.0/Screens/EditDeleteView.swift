import SwiftUI
import PhotosUI

struct EditDeleteView: View {
    let incidentId: Int
    
    // Campos editables
    @State private var url: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: String = "Sin categoría"
    // Ajusta estos nombres/ids a los de tu base:
    private let categoriesWithIds: [(name: String, id: Int)] = [
        ("Tecnología", 1), ("Viajes", 2), ("Negocios", 3), ("Redes Sociales", 4), ("Educación", 10)
    ]
    var categories: [String] { categoriesWithIds.map { $0.name } }
    
    @State private var isAnonymous: Bool = false
    
    // Imagen
    @State private var photoImage: Image? = Image(systemName: "photo")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showPhotoOptions = false
    
    // Estados de carga/alertas
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isLoading = false
    @State private var isSaving = false
    
    //Eliminar
    @State private var isDeleting: Bool = false
    @State private var confirmDelete: Bool = false
    
    

    // Original para detectar diffs
    @State private var originalDetail: ReportDetailDTO?
    @State private var originalHadImage: Bool = false
    @State private var userRemovedPhoto: Bool = false   // true cuando el usuario elimina la foto visible

    private let api = ReportsAPI()
    private let baseURLString = "http://10.48.251.159:3000"

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    Text("Tu Incidente")
                        .font(Font.custom("Inter", size: 24).weight(.semibold))
                        .foregroundColor(.black)
                        .padding(.top, 10)

                    // URL
                    VStack(alignment: .leading, spacing: 4) {
                        Text("URL del Incidente")
                            .font(Font.custom("Roboto", size: 14))
                            .foregroundColor(.gray)

                        HStack {
                            Image(systemName: "link").foregroundColor(.gray)
                            TextField("Ej: https://sitiofalso.com", text: $url)
                                .font(Font.custom("Roboto", size: 16))
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
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

                    // Descripción
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Descripción del Incidente")
                            .font(Font.custom("Roboto", size: 14))
                            .foregroundColor(.gray)

                        HStack {
                            Image(systemName: "pencil").foregroundColor(.gray)
                            TextEditor(text: $description)
                                .font(Font.custom("Roboto", size: 16))
                                .frame(minHeight: 100)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 1)
                    }
                    .padding(.horizontal)

                    // Categoría
                    VStack(alignment: .leading, spacing: 4) {
                        Menu {
                            Picker("Categoría", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedCategory)
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                        }
                    }
                    .padding(.horizontal)

                    // Evidencia Foto
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Evidencia Foto")
                            .font(Font.custom("Inter", size: 20).weight(.semibold))
                            .foregroundColor(.black)

                        Text("Agrega de la librería o toma una foto para evidenciar la incidencia")
                            .font(Font.custom("Roboto", size: 14))
                            .foregroundColor(.gray)

                        Button(action: {
                            showPhotoOptions = true
                        }) {
                            HStack {
                                Image(systemName: "camera")
                                Text("Foto")
                                    .font(Font.custom("Roboto", size: 16).weight(.medium))
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                            .cornerRadius(20)
                        }
                        .confirmationDialog("Seleccionar fuente", isPresented: $showPhotoOptions, titleVisibility: .visible) {
                            Button("Tomar foto") {
                                sourceType = .camera
                                showingImagePicker = true
                                userRemovedPhoto = false
                            }
                            
                            Button("Seleccionar de galería") {
                                sourceType = .photoLibrary
                                showingImagePicker = true
                                userRemovedPhoto = false
                            }
                            
                            Button("Cancelar", role: .cancel) { }
                        }

                        if let photoImage = photoImage {
                            HStack {
                                photoImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 250)
                                    .cornerRadius(8)

                                Button {
                                    self.photoImage = nil
                                    self.inputImage = nil
                                    self.userRemovedPhoto = true
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Guardar cambios
                    Button {
                        Task { await saveChanges() }
                    } label: {
                        if isSaving {
                            ProgressView().tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Guardar cambios")
                                .font(Font.custom("Roboto", size: 16).weight(.semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .disabled(isSaving)

                    // Eliminar
                    Button {
                        confirmDelete = true
                    } label: {
                        HStack {
                            if isDeleting {
                                ProgressView().tint(.white)
                            } else {
                                    Image(systemName: "arrow.right")
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
                    .disabled(isSaving || isDeleting)
                }
                .padding(.bottom, 20)
            }
            .overlay { if isLoading { ProgressView().scaleEffect(1.2) } }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Aviso"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .confirmationDialog(
                "¿Estás seguro de que quieres eliminar este reporte?",
                isPresented: $confirmDelete,
                titleVisibility: .visible
            ) {
                Button("Eliminar", role: .destructive) {
                    Task { await deleteReport() }
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Esta acción no se puede deshacer. Se realizará un borrado lógico.")
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage, sourceType: sourceType)
                    .onDisappear {
                        if let inputImage = inputImage {
                            photoImage = Image(uiImage: inputImage)
                        }
                    }
            }
            .onAppear { Task { await loadDetail() } }
        }
    }

    // MARK: - Carga del detalle (GET)
    private func loadDetail() async {
        await MainActor.run { isLoading = true }
        defer { Task { await MainActor.run { isLoading = false } } }

        do {
            let detail = try await api.fetchReportDetail(id: incidentId)
            await MainActor.run {
                self.originalDetail = detail
                self.url = detail.pageURL ?? ""
                self.description = detail.description ?? ""
                self.selectedCategory = detail.category ?? "Sin categoría"
                self.isAnonymous = detail.anonymous!
                self.originalHadImage = (detail.image != nil)
                self.userRemovedPhoto = false
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

    // MARK: - Guardar cambios (PATCH)
    private func saveChanges() async {
        guard let original = originalDetail else {
            await MainActor.run {
                self.alertMessage = "No se pudo validar cambios: datos originales no cargados."
                self.showAlert = true
            }
            return
        }

        await MainActor.run { isSaving = true }
        defer { Task { await MainActor.run { isSaving = false } } }

        // Detectar diffs
        var req = UpdateReportRequest()

        if url != (original.pageURL ?? "") {
            req.pageURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if description != (original.description ?? "") {
            req.description = description
        }

        // categoría -> id
        let selectedId = categoriesWithIds.first(where: { $0.name == selectedCategory })?.id
        let originalName = original.category ?? "Sin categoría"
        let originalId = categoriesWithIds.first(where: { $0.name == originalName })?.id
        if selectedId != originalId {
            req.categoryId = selectedId
        }

        // Imagen:
        var imageDataForUpload: Data?
        if userRemovedPhoto, originalHadImage, inputImage == nil {
            req.deletePhoto = true
        }
        if let uiimg = inputImage {
            imageDataForUpload = uiimg.jpegData(compressionQuality: 0.85)
        }

        // Si no hay cambios, avisamos y salimos
        if req.pageURL == nil,
           req.description == nil,
           req.categoryId == nil,
           req.deletePhoto == nil,
           imageDataForUpload == nil {
            await MainActor.run {
                self.alertMessage = "No hay cambios para guardar."
                self.showAlert = true
            }
            return
        }

        do {
            try await api.updateReport(id: incidentId, body: req, imageJPEG: imageDataForUpload)
            await MainActor.run {
                self.alertMessage = "Cambios guardados."
                self.showAlert = true
            }
        } catch {
            await MainActor.run {
                self.alertMessage = "No se pudo guardar: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    // MARK: - Eliminar (DELETE)
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

    // MARK: - Helpers
    private func makeAbsoluteURL(from path: String) -> URL? {
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return URL(string: baseURLString + "/" + trimmed)
    }

    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        guard let img = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
        return img
    }
}

struct EditDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        EditDeleteView(incidentId: 1)
    }
}
