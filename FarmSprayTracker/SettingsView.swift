import SwiftUI
import MapKit

struct SettingsView: View {
    @Binding var region: MKCoordinateRegion

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Map Settings")) {
                    Text("Region Center: \(region.center.latitude), \(region.center.longitude)")
                    Text("Adjust settings here")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
