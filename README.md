# FraudX Release APP

Una aplicación iOS nativa desarrollada en SwiftUI que permite a los usuarios reportar y verificar sitios web fraudulentos de manera colaborativa y segura.

Características Principales

- Reporte de Incidentes: Reporta URLs sospechosas con descripción detallada, categoría y evidencia fotográfica
- Validación Comunitaria: Acceso a un feed público de reportes verificados por la comunidad
- Ranking: Visualiza estadísticas de dominios más reportados
- Gestión de Perfil: Edita tu información personal
- Edición/Eliminación de Reportes: Modifica o elimina tus reportes pendientes
- Autenticación Persistente: Mantén la sesión activa entre sesiones de la app
- Categorización: Clasifica incidentes por tipo (Tecnología, Viajes, Negocios, Redes Sociales, Educación)
- Soporte Anónimo: Opción para reportar de forma anónima


##Frontend
- SwiftUI - Framework declarativo para UI
- iOS 16.0+ - Versión mínima requerida
- Xcode 16.4+

##Backend
Consultar los demas repositorios que pertenencen a esta organizacion

##Networking & Seguridad

- URLSession - Cliente HTTP nativo
- JWT Authentication - Access/Refresh Tokens
- Token Storage - Keychain para tokens sensibles
- Multipart Form-Data - Para subida de imágenes


##Flujo de Uso
Primera vez

Abre la app → Pantalla de Bienvenida (ContentView)
Selecciona Registrarse → Completa formulario
Inicia sesión → Acceso a HomeView

Usuario autenticado

Inicio: Feed público de reportes
Registrar Incidente: Crea nuevo reporte con fotos
Historial: Visualiza tus reportes (pendientes, validados, rechazados)
Prevención: Consejos y materiales de seguridad
Perfil: Edita información personal

Persistencia de sesión

Los tokens se guardan automáticamente al login
Al cerrar y abrir la app, se recupera la sesión
Al logout, se limpian los tokens y vuelve a pantalla de login
