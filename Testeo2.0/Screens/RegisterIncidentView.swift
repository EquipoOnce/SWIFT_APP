import SwiftUI
import PhotosUI

struct RegisterIncidentView: View {
    @State private var url: String = ""
    @State private var description: String = ""
    @State private var isAnonymous: Bool = false
    @State private var selectedCategory: String = "Categoría"
    @State private var photoImage: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var showPhotoOptions = false
    @State private var showCategorySheet = false
    @State private var isSubmitting = false
    @State private var errorText: String?
    @State private var createdId: Int?
    
    private let api = ReportsAPI()
    private let maxWordsDescription = 500
    
    private let categoryMap: [String: Int] = [
        "Tecnologia": 1,
        "Viajes": 2,
        "Negocios": 3,
        "Redes Sociales": 4,
        "Educacion": 10,
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.opacity(0.9)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Title
                        Text("Reportar Incidente")
                            .font(Font.custom("Inter", size: 24).weight(.semibold))
                            .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                            .padding(.top, 20)
                        
                        // URL Section
                        VStack(alignment: .leading, spacing: 4) {
                            Text("URL del Incidente")
                                .font(Font.custom("Roboto", size: 14))
                                .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                            
                            HStack {
                                Image(systemName: "link")
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                TextField("Ej: https://sitiofalso.com", text: $url)
                                    .font(Font.custom("Roboto", size: 16))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                            
                            Text("Enlace directo a la página web")
                                .font(Font.custom("Roboto", size: 12))
                                .foregroundColor(Color.gray)
                        }
                        .padding(.horizontal)
                        
                        // Description Section
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Descripción del Incidente")
                                    .font(Font.custom("Roboto", size: 14))
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                Spacer()
                                Text("\(description.split(separator: " ").count)/\(maxWordsDescription)")
                                    .font(Font.custom("Roboto", size: 12))
                                    .foregroundColor(Color.gray)
                            }
                            
                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                TextEditor(text: $description)
                                    .font(Font.custom("Roboto", size: 16))
                                    .frame(minHeight: 100)
                                    .onChange(of: description) { newValue in
                                        let words = newValue.split(separator: " ")
                                        if words.count > maxWordsDescription {
                                            description = words.prefix(maxWordsDescription).joined(separator: " ")
                                        }
                                    }
                                    .overlay(
                                        Text("Detalla qué sucedió, cómo te diste cuenta y cualquier otra información relevante.")
                                            .foregroundColor(Color.gray.opacity(0.8))
                                            .padding(.top, 8)
                                            .padding(.leading, 5)
                                            .opacity(description.isEmpty ? 1 : 0)
                                    )
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                        }
                        .padding(.horizontal)
                        
                        // Anonymous Toggle and Category Picker
                        HStack(spacing: 50) {
                            Toggle(isOn: $isAnonymous) {
                                Text("Anónimo")
                                    .font(Font.custom("Roboto", size: 16))
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.27, green: 0.35, blue: 0.39)))
                            
                            Spacer()
                            
                            Menu {
                                Picker("Categoría", selection: $selectedCategory) {
                                    ForEach(categoryMap.keys.sorted(), id: \.self) { key in
                                        Text(key)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory)
                                        .font(Font.custom("Roboto", size: 14))
                                        .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                    Image(systemName: "chevron.down")
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 1)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Photo Evidence
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Evidencia Foto")
                                .font(Font.custom("Inter", size: 20).weight(.semibold))
                                .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                            
                            Text("Agrega de la librería o toma una foto para evidenciar la incidencia")
                                .font(Font.custom("Roboto", size: 14))
                                .foregroundColor(Color.gray)
                            
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
                                }
                                
                                Button("Seleccionar de galería") {
                                    sourceType = .photoLibrary
                                    showingImagePicker = true
                                }
                                
                                Button("Cancelar", role: .cancel) { }
                            }
                            
                            if let photoImage = photoImage {
                                photoImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 250)
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Report Button
                        Button(action: submitIncident) {
                            if isSubmitting {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Reportar Incidente")
                                    .font(Font.custom("Roboto", size: 16).weight(.semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .disabled(isSubmitting)
                        
                        if let errorText {
                            Text(errorText)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.bottom, 20)
                }
                
                // Bottom Navigation
                VStack {
                    Spacer()
                    HStack {
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
                        
                        VStack {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Registrar Incidente")
                                .font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                        }
                        .frame(maxWidth: .infinity)
                        
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
                        
                        NavigationLink(destination: PreventionView()) {
                            VStack {
                                Image(systemName: "rosette")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.gray)
                                Text("Prevención")
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage, sourceType: sourceType)
                    .onDisappear {
                        if let inputImage = inputImage {
                            photoImage = Image(uiImage: inputImage)
                        }
                    }
            }
            .sheet(isPresented: $showCategorySheet) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Seleccionar Categoría")
                            .font(Font.custom("Inter", size: 16).weight(.semibold))
                        Spacer()
                        Button("Listo") {
                            showCategorySheet = false
                        }
                        .font(Font.custom("Roboto", size: 14))
                        .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                    }
                    .padding()
                    .background(Color.white)
                    
                    Divider()
                    
                    Picker("Categoría", selection: $selectedCategory) {
                        ForEach(categoryMap.keys.sorted(), id: \.self) { key in
                            Text(key).tag(key)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Spacer()
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
        .navigationDestination(isPresented: Binding(
            get: { createdId != nil },
            set: { if !$0 { createdId = nil } }
        )) {
            SuccessView()
        }
    }
    
    private func submitIncident() {
        let trimmedDesc = description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedDesc.isEmpty else {
            errorText = "La descripción es obligatoria."
            showAlert = true
            alertMessage = errorText ?? ""
            return
        }
        guard let catId = categoryMap[selectedCategory] else {
            errorText = "Selecciona una categoría válida."
            showAlert = true
            alertMessage = errorText ?? ""
            return
        }

        var files: [Data] = []
        if let img = inputImage,
           let jpeg = img.jpegData(compressionQuality: 0.7) {
            files = [jpeg]
        }

        let dto = CreateReportRequest(
            pageURL: url,
            description: trimmedDesc,
            anonymous: isAnonymous,
            categoryId: catId,
            files: files
        )

        isSubmitting = true
        errorText = nil

        Task {
            do {
                let response = try await api.createReport(dto)
                createdId = response.id
                isSubmitting = false
            } catch {
                isSubmitting = false
                errorText = (error as NSError).localizedDescription
                alertMessage = errorText ?? "Ocurrió un error inesperado."
                showAlert = true
            }
        }
    }
}

struct Incidentis: PreviewProvider {
    static var previews: some View {
        RegisterIncidentView()
    }
}
