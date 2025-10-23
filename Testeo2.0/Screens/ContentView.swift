import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sesion : SessionManager
  var body: some View {
    NavigationStack {
      ZStack() {
        ZStack() {
          ZStack() {
            VStack(spacing: 16) {
              Text("FraudX")
                .font(Font.custom("Inter", size: 40).weight(.bold))
                .lineSpacing(32)
                .italic()
                .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
              
              // Imagen debajo de FraudX y más grande
              AsyncImage(url: URL(string: "https://redporlaciberseguridad.org/wp-content/uploads/2025/09/Logo-escudo-negro-scaled.png")) { phase in
                switch phase {
                case .empty:
                  ProgressView()
                    .frame(width: 140, height: 140)
                case .success(let image):
                  image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .cornerRadius(12)
                case .failure:
                  Image(systemName: "photo")
                    .frame(width: 140, height: 140)
                    .foregroundColor(.gray)
                @unknown default:
                  Image(systemName: "photo")
                    .frame(width: 140, height: 140)
                    .foregroundColor(.gray)
                }
              }
            }
            .offset(x: -5, y: -190)
            
            Text("Bienvenido a FraudX")
              .font(Font.custom("Inter", size: 30).weight(.semibold))
              .lineSpacing(36)
              .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
              .offset(x: 1, y: -66)
            
            Text("Tu compañero confiable para la prevención de fraudes")
              .font(Font.custom("Roboto", size: 20).weight(.light))
              .lineSpacing(10)
              .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12).opacity(0.80))
              .offset(x: 1, y: 49)
              .multilineTextAlignment(.center)
            
            NavigationLink(destination: tutorialView()) {
              ZStack() {
                Text("Registrarse")
                  .font(Font.custom("Roboto", size: 16).weight(.semibold))
                  .lineSpacing(22)
                  .foregroundColor(.white)
                  .offset(x: 0, y: 0)
              }
              .frame(width: 320, height: 40)
              .background(Color(red: 0.27, green: 0.35, blue: 0.39))
              .cornerRadius(20)
            }
            .buttonStyle(.plain)
            .offset(x: -0.50, y: 186)
            .shadow(
              color: Color(red: 0.09, green: 0.10, blue: 0.12, opacity: 0.05), radius: 1
            )
            
            NavigationLink(destination: PREV_login()) {
              ZStack() {
                Text("Iniciar Sesión")
                  .font(Font.custom("Roboto", size: 16).weight(.semibold))
                  .lineSpacing(22)
                  .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                  .offset(x: 0, y: 0)
              }
              .frame(width: 320, height: 40)
              .background(.white)
              .cornerRadius(20)
              .overlay(
                RoundedRectangle(cornerRadius: 20)
                  .inset(by: 1)
                  .stroke(Color(red: 0.27, green: 0.35, blue: 0.39), lineWidth: 1)
              )
            }
            .buttonStyle(.plain)
            .offset(x: -0.50, y: 242)
            
            ZStack() {
              ZStack() {
              }
              .frame(width: 70, height: 40)
              .offset(x: -152.50, y: 0)
              ZStack() {
              }
              .frame(width: 96, height: 40)
              .offset(x: 139.50, y: 0)
            }
            .frame(width: 375, height: 40)
            .background(Color(red: 0, green: 0, blue: 0).opacity(0))
            .offset(x: -1, y: -402)
          }
          .frame(width: 375, height: 844)
          .background(Color(red: 0.96, green: 0.97, blue: 0.98))
          .offset(x: -2, y: -4)
        }
        .frame(width: 393, height: 852)
        .background(.white)
        .offset(x: 0, y: 0)
        .shadow(
          color: Color(red: 0.07, green: 0.06, blue: 0.16, opacity: 0.12), radius: 6, y: 3
        )
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 453, height: 912)
            .offset(x: 0, y: 0)
        }
        .frame(width: 393, height: 852)
        .offset(x: 0, y: 0)
      }
      .frame(width: 393, height: 852)
      .navigationBarHidden(true);
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
