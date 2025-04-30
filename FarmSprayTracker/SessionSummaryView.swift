import SwiftUI

struct SessionSummaryView: View {
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        NavigationView {
            List {
                ForEach(sessionManager.sessions) { session in
                    SessionCell(session: session)
                }
            }
            .navigationTitle("Spray Sessions")
        }
    }
}

struct SessionCell: View {
    var session: SpraySession

    var body: some View {
        VStack(alignment: .leading) {
            Text(session.name)
                .font(.headline)
            Text("Area: \(session.area, specifier: "%.2f") acres")
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct SessionSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let sessionManager = SessionManager()
        let locationManager = LocationManager()
        sessionManager.saveSession(name: "Test Session", coordinates: [], area: 10.5)
        return SessionSummaryView(sessionManager: sessionManager, locationManager: locationManager)
            .previewDevice("iPhone 16 Pro")
            .environment(\.colorScheme, .light)
    }
}
