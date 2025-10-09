//
//  RankingView.swift
//  Testeo2.0
//
//  Created by Iker on 06/10/25.
//

import SwiftUI

struct RankingView: View {
    // Mock data from "database" – replace with actual fetch in real app
    let topURLs = [
        ("1", "Categoria 1", "http://examplefraud.com"),
        ("2", "Categoria 2", "http://examplefraud.com"),
        ("3", "Categoria 4", "http://examplefraud.com"),
        ("4", "Categoria 1", "http://examplefraud.com"),
        ("5", "Categoria 2", "http://examplefraud.com"),
        ("6", "Categoria 3", "http://examplefraud.com"),
        ("7", "Categoria 4", "http://examplefraud.com"),
        ("8", "Categoria 3", "http://examplefraud.com"),
        ("9", "Categoria 3", "http://examplefraud.com"),
        ("10", "Categoria 1", "http://examplefraud.com")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top bar
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
                        VStack(spacing: 0) {
                            Text("*")  // Placeholder for logo, replace with Image("logo") later
                                .font(.system(size: 30))
                                .foregroundColor(.black)
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
                    
                    // Tabs: Comunidad, Ranking (selected)
                    HStack(spacing: 16) {
                        NavigationLink(destination: HomeView()) {
                            Text("Comunidad")
                                .font(Font.custom("Roboto", size: 16).weight(.medium))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(red: 0.27, green: 0.35, blue: 0.39), lineWidth: 1)
                                )
                        }
                        
                        Text("Ranking")
                            .font(Font.custom("Roboto", size: 16).weight(.medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.27, green: 0.35, blue: 0.39))
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    
                    // Scrollable list with bottom padding to avoid overlap
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Top URLs mas reportadas")
                                .font(Font.custom("Inter", size: 20).weight(.semibold))
                                .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                .padding(.horizontal)
                                .padding(.top, 20)
                            
                            ForEach(topURLs, id: \.0) { item in
                                NavigationLink(destination: SearchView(query: item.2)) {  // Auto-search the URL
                                    HStack {
                                        Text(item.0)
                                            .font(Font.custom("Roboto", size: 16).weight(.medium))
                                            .foregroundColor(Color(red: 0.09, green: 0.10, blue: 0.12))
                                            .frame(width: 30, alignment: .leading)
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.1)
                                                .font(Font.custom("Roboto", size: 14))
                                                .foregroundColor(Color.gray)
                                            Text("Url: \(item.2)")
                                                .font(Font.custom("Roboto", size: 14))
                                                .foregroundColor(Color.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 100)  // Padding to prevent overlap with bottom nav
                    }
                }
                
                // Bottom navigation
                VStack {
                    Spacer()
                    HStack {
                        // Inicio (selected)
                        VStack {
                            Image(systemName: "house.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Inicio")
                                .font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
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
                        
                        // Prevencion
                        NavigationLink(destination: PreventionView()) {
                            VStack {
                                Image(systemName: "rosette")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.gray)
                                Text("Prevencion")
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
        }
    }
}

// Assume SearchView accepts a query parameter for auto-search
struct SearchView: View {
    var query: String = ""
    
    var body: some View {
        Text("Búsqueda para: \(query)")
            .navigationTitle("Buscar")
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}
