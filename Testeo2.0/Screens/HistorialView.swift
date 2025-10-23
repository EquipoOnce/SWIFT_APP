import SwiftUI

// MARK: - Modelos
enum IncidentStatus: String, Codable {
    case pendiente = "Pendiente"
    case aprobado  = "Aprobado"
    case rechazado = "Rechazado"

    var icon: String {
        switch self {
        case .pendiente: return "clock"
        case .aprobado:  return "checkmark"
        case .rechazado: return "xmark"
        }
    }
    var color: Color {
        switch self {
        case .pendiente: return .orange
        case .aprobado:  return .green
        case .rechazado: return .red
        }
    }
}

struct Incident: Identifiable, Codable {
    let id: Int
    let categoria: String
    let descripcionResumida: String
    let fechaCreacion: Date
    var estatus: IncidentStatus

    var idDisplay: String { "ID Incidente: \(id)" }

    var fechaDisplay: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f.string(from: fechaCreacion)
    }
}

// MARK: - Vista Principal
struct HistorialView: View {
    @State private var incidents: [Incident] = []
    @State private var isLoading = false
    @State private var api = ReportsAPI()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 16) {
                            if isLoading {
                                ProgressView().padding(.top, 50)
                            } else if incidents.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(incidents) { incident in
                                    NavigationLink(destination: destinationView(for: incident)) {
                                        IncidentCardView(incident: incident)
                                    }
                                    .buttonStyle(.plain)
                                    .simultaneousGesture(TapGesture().onEnded {
                                        callBackendForIncident(incident)
                                    })
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }

                    Spacer()

                    // Menú inferior fijo
                    HStack {
                        NavigationLink(destination: HomeView()) {
                            VStack {
                                Image(systemName: "house.fill").font(.system(size: 24)).foregroundColor(.gray)
                                Text("Inicio").font(Font.custom("Roboto", size: 10)).foregroundColor(.gray)
                            }
                        }.frame(maxWidth: .infinity)

                        NavigationLink(destination: RegisterIncidentView()) {
                            VStack {
                                Image(systemName: "doc.text.fill").font(.system(size: 24)).foregroundColor(.gray)
                                Text("Registrar Incidente").font(Font.custom("Roboto", size: 10)).foregroundColor(.gray)
                            }
                        }.frame(maxWidth: .infinity)

                        VStack {
                            Image(systemName: "clock.fill").font(.system(size: 24))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                            Text("Historial").font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.39))
                        }.frame(maxWidth: .infinity)

                        NavigationLink(destination: PreventionView()) {
                            VStack {
                                Image(systemName: "rosette").font(.system(size: 24)).foregroundColor(.gray)
                                Text("Prevención").font(Font.custom("Roboto", size: 10)).foregroundColor(.gray)
                            }
                        }.frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
                }
            }
            .navigationTitle("Historial de Incidentes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear { loadIncidents() }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass").font(.system(size: 60)).foregroundColor(.gray)
            Text("No hay incidentes registrados").font(.headline).foregroundColor(.secondary)
        }
        .padding(.top, 100)
    }

    @ViewBuilder
    private func destinationView(for incident: Incident) -> some View {
        switch incident.estatus {
        case .pendiente:
            EditDeleteView(incidentId: incident.id)
        case .aprobado, .rechazado:
            ViewDeleteView(incidentId: incident.id)
        }
    }

    // MARK: - Carga desde backend real
    // Reemplaza TODO el método loadIncidents() por este:
    private func loadIncidents() {
        isLoading = true
        Task {
            do {
                async let pending  = api.fetchPendingReports()
                async let validated = api.fetchValidatedReports()
                async let rejected  = api.fetchRejectedReports()

                let p = try await pending
                let v = try await validated
                let r = try await rejected

                let all = p + v + r

                // Mapeo ReportHistoryItem -> Incident
                let mapped: [Incident] = all.compactMap { item in
                    guard let date = isoToDate(item.createdAt) else { return nil }
                    let status: IncidentStatus
                    switch item.status.lowercased() {
                    case "pending":   status = .pendiente
                    case "validated": status = .aprobado
                    case "rejected":  status = .rechazado
                    default:          status = .pendiente
                    }
                    return Incident(
                        id: item.id,
                        categoria: item.category,
                        descripcionResumida: item.description,
                        fechaCreacion: date,
                        estatus: status
                    )
                }

                // 🚫 Aquí es donde te duplicabas —> deduplicamos por id
                let unique = dedupeKeepingNewest(mapped)

                await MainActor.run {
                    self.incidents = unique.sorted(by: { $0.fechaCreacion > $1.fechaCreacion })
                    self.isLoading = false
                }
            } catch {
                print("Error al cargar incidentes: \(error)")
                await MainActor.run { self.isLoading = false }
            }
        }
    }
    // Acepta ISO8601 con o sin milisegundos (ej: 2025-10-09T19:40:24.000Z)
    private func isoToDate(_ isoString: String) -> Date? {
        let fmt = ISO8601DateFormatter()
        fmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = fmt.date(from: isoString) { return d }
        // Fallback sin fracciones por si cambia el backend
        let fmt2 = ISO8601DateFormatter()
        fmt2.formatOptions = [.withInternetDateTime]
        return fmt2.date(from: isoString)
    }
    
    // Prioridad de estatus si hay dos con misma fecha para el mismo id
    private func statusPriority(_ s: IncidentStatus) -> Int {
        switch s {
        case .pendiente: return 0
        case .aprobado:  return 2
        case .rechazado: return 2
        }
    }

    /// Deja un solo Incident por id: el más nuevo; si empatan en fecha,
    /// se queda el de mayor prioridad de estatus (validado/rechazado > pendiente).
    private func dedupeKeepingNewest(_ items: [Incident]) -> [Incident] {
        let grouped = Dictionary(grouping: items, by: { $0.id })
        return grouped.values.compactMap { group in
            group.max { a, b in
                if a.fechaCreacion == b.fechaCreacion {
                    return statusPriority(a.estatus) < statusPriority(b.estatus)
                }
                return a.fechaCreacion < b.fechaCreacion
            }
        }
    }

    private func callBackendForIncident(_ incident: Incident) {
        print("Incidente seleccionado ID: \(incident.id)")
    }

    private func deleteIncident(_ incident: Incident) {
        incidents.removeAll { $0.id == incident.id }
    }

    private func updateIncident(_ incident: Incident) {
        if let i = incidents.firstIndex(where: { $0.id == incident.id }) {
            incidents[i] = incident
        }
    }
}

// MARK: - Tarjeta de Incidente
struct IncidentCardView: View {
    let incident: Incident

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(incident.estatus.color.opacity(0.1)).frame(width: 50, height: 50)
                Image(systemName: incident.estatus.icon).font(.system(size: 22)).foregroundColor(incident.estatus.color)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(incident.idDisplay).font(.caption).foregroundColor(.secondary)
                Text(incident.categoria).font(.headline).foregroundColor(.primary)
                Text(incident.descripcionResumida).font(.subheadline).foregroundColor(.secondary).lineLimit(2)
                HStack {
                    Spacer()
                    Text(incident.fechaDisplay).font(.caption).foregroundColor(.secondary)
                }
            }
            Image(systemName: "chevron.right").font(.system(size: 14)).foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct HistorialView_Previews: PreviewProvider {
    static var previews: some View { HistorialView() }
}
