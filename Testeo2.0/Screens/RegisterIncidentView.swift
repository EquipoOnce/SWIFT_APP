import SwiftUI
import PhotosUI

struct RegisterIncidentView: View {
    @State private var url: String = ""
    @State private var description: String = ""
    @State private var isAnonymous: Bool = false
    @State private var selectedCategory: String = "Categoría"
    let categories = ["Categoría 1", "Categoría 2", "Categoría 3", "Categoría 4"]
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var photoImage: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.opacity(0.9)
                    .ignoresSafeArea()
                
                // ScrollView principal para permitir desplazamiento
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
                            Text("Descripción del Incidente")
                                .font(Font.custom("Roboto", size: 14))
                                .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                            
                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundColor(Color(red: 0.34, green: 0.36, blue: 0.43))
                                TextEditor(text: $description)
                                    .font(Font.custom("Roboto", size: 16))
                                    .frame(minHeight: 100)
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
                            .toggleStyle(SwitchToggleStyle(tint: Color(Color(red: 0.27, green: 0.35, blue: 0.39))))
                            
                            Spacer()
                            
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
                            
                            Menu {
                                Button(action: {
                                    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                                        alertMessage = "La cámara no está disponible en este dispositivo"
                                        showAlert = true
                                        return
                                    }
                                    sourceType = .camera
                                    showingImagePicker = true
                                }) {
                                    Label("Tomar foto", systemImage: "camera")
                                }
                                
                                Button(action: {
                                    guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                                        alertMessage = "No se puede acceder a la galería de fotos"
                                        showAlert = true
                                        return
                                    }
                                    sourceType = .photoLibrary
                                    showingImagePicker = true
                                }) {
                                    Label("Seleccionar de galería", systemImage: "photo.on.rectangle")
                                }
                            } label: {
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
                            
                            // Imagen con tamaño limitado
                            if let photoImage = photoImage {
                                photoImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 250) // Limitar altura máxima
                                    .cornerRadius(8)
                                    .padding(.horizontal) // Añadir padding horizontal
                            }
                        }
                        .padding(.horizontal)
                        
                        // Report Button
                        NavigationLink(destination: SuccessView()) {
                            Text("Reportar Incidente")
                                .font(Font.custom("Roboto", size: 16).weight(.semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                                .cornerRadius(20)
                        }
                        .padding(.horizontal)
                        
                        // Espaciador inferior para evitar que el menú tape el contenido
                        Spacer(minLength: 100)
                    }
                    .padding(.bottom, 20) // Padding inferior para el contenido
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
                        
                        // Registrar Incidente (selected)
                        VStack {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Registrar Incidente")
                                .font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
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
        }
    }
}

// Mantener el resto del código igual (SuccessView, ImagePicker, etc.)
    
    // Success Screen
    struct SuccessView: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("¡Éxito!")
                    .font(Font.custom("Inter", size: 30).weight(.semibold))
                    .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                    .padding(.top, 100)
                
                Text("El incidente se registró con éxito y estará pendiente por aprobar por un administrador.")
                    .font(Font.custom("Roboto", size: 16))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: HomeView()) {
                    Text("Regresar a Inicio")
                        .font(Font.custom("Roboto", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: HistorialView()) {
                    Text("Ir al Historial de Reportes")
                        .font(Font.custom("Roboto", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
    
    struct RegisterIncidentView_Previews: PreviewProvider {
        static var previews: some View {
            RegisterIncidentView()
        }
    }



//struct para fotos
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
