import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var path: [CLLocationCoordinate2D] = []
    @State private var overlapPath: [CLLocationCoordinate2D] = []
    @State private var sprayWidthText = "10.0"

    var body: some View {
        VStack {
            MapView(region: $region, path: path, overlapPath: overlapPath, applicatorWidth: Double(sprayWidthText) ?? 10.0)
                .frame(height: 300)
            TextField("Spray Width (ft)", text: $sprayWidthText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
