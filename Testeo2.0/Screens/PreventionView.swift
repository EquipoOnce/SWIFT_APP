//
//  PreventionView.swift
//  Testeo2.0
//
//  Created by Iker on 05/10/25.
//

import SwiftUI

struct PreventionView: View {
    
    // Placeholder URLs for links (replace with actual ones)
    let infographicItems = [
        ("Identifica Estafas Comunes", "Aprende a reconocer las señales de advertencia de las estafas más frecuentes, desde correos electrónicos", "https://example.com/infografia1"),
        ("Otra Infografía", "Descripción de la segunda infografía", "https://example.com/infografia2"),
        ("Tercera Infografía", "Descripción de la tercera", "https://example.com/infografia3")
    ]
    
    let resourceItems = [
        ("Guia de Seguridad Bancaria", "Recursos y consejos del Banco Central", "https://example.com/guia-bancaria"),
        ("Informes de Tendencias de Fraude", "Estadísticas y análisis actualizados", "https://example.com/informes-fraude")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.opacity(0.9)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Title
                    Text("Materiales de Prevención")
                        .font(Font.custom("Inter", size: 24).weight(.semibold))
                        .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                        .padding(.top, 20)
                    
                    // Infografías Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Infografías para la Prevención")
                            .font(Font.custom("Inter", size: 20).weight(.semibold))
                            .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                            .padding(.horizontal)
                        
                        // Carousel
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(infographicItems, id: \.0) { item in
                                    Link(destination: URL(string: item.2)!) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            // Placeholder image
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 200, height: 150)
                                                .cornerRadius(8)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundColor(.gray)
                                                        .font(.largeTitle)
                                                )
                                            
                                            Text(item.0)
                                                .font(Font.custom("Roboto", size: 16).weight(.medium))
                                                .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                            
                                            Text(item.1)
                                                .font(Font.custom("Roboto", size: 14))
                                                .foregroundColor(Color.gray)
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                                        .frame(width: 220)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 250)
                    }
                    
                    // Recursos Web Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recursos Web Útiles")
                            .font(Font.custom("Inter", size: 20).weight(.semibold))
                            .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.12))
                            .padding(.horizontal)
                        
                        ForEach(resourceItems, id: \.0) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.0)
                                        .font(Font.custom("Roboto", size: 16).weight(.medium))
                                        .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                    
                                    Text(item.1)
                                        .font(Font.custom("Roboto", size: 14))
                                        .foregroundColor(Color.gray)
                                }
                                
                                Spacer()
                                
                                Link(destination: URL(string: item.2)!) {
                                    Text("Ver >")
                                        .font(Font.custom("Roboto", size: 14))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
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
                        
                        // Prevencion (selected)
                        VStack {
                            Image(systemName: "rosette")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Prevención")
                                .font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
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

struct PreventionView_Previews: PreviewProvider {
    static var previews: some View {
        PreventionView()
    }
}
