//
//  SuccessView.swift
//  Testeo2.0
//
//  Created by Usuario on 09/10/25.
//

import Foundation
import SwiftUI

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

