/*
 File: SessionSummaryView.swift
 Description: Displays a searchable list of saved spray sessions with map thumbnails.
 Features:
 - Shows session name, area, and a real map preview using MKMapSnapshotter.
 - Allows resuming sessions by reloading into LocationManager.
*/
import SwiftUI
import MapKit

struct SessionSummaryView: View {
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var locationManager: LocationManager
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sessionManager.sessions.filter {
                    searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
                }) { session in
                    HStack {
                        MapThumbnailView(coordinates: session.clCoordinates)
                            .frame(width: 50, height: 50)
                            .accessibilityLabel("Map preview for session \(session.name)")
                        VStack(alignment: .leading) {
                            Text(session.name)
                                .font(.headline)
                            Text("Area: \(session.area, specifier: "%.2f") acres")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {
                            sessionManager.resumeSession(session, into: locationManager)
                            dismiss()
                        }) {
                            Text("Resume")
                                .foregroundColor(.blue)
                        }
                        .accessibilityLabel("Resume session \(session.name)")
                    }
                }
                .onDelete(perform: sessionManager.deleteSession)
            }
            .searchable(text: $searchText, prompt: "Search sessions")
            .navigationTitle("Spray Sessions")
            .accessibilityLabel("List of saved spray sessions")
        }
    }
}

struct MapThumbnailView: View {
    let coordinates: [CLLocationCoordinate2D]
    @State private var snapshotImage: UIImage?
    
    var body: some View {
        Group {
            if let image = snapshotImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .overlay(
                        Text("Map")
                            .foregroundColor(.white)
                            .font(.caption)
                    )
                    .onAppear {
                        generateSnapshot()
                    }
            }
        }
    }
    
    private func generateSnapshot() {
        guard !coordinates.isEmpty else { return }
        
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        guard let minLat = latitudes.min(), let maxLat = latitudes.max(),
              let minLon = longitudes.min(), let maxLon = longitudes.max() else { return }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max(maxLat - minLat, 0.001) * 1.5,
            longitudeDelta: max(maxLon - minLon, 0.001) * 1.5
        )
        let region = MKCoordinateRegion(center: center, span: span)
        
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: 50, height: 50)
        options.mapType = .hybrid
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Snapshot error: \(error?.localizedDescription ?? "Unknown")")
                return
            }
            
            let image = UIGraphicsImageRenderer(size: options.size).image { context in
                snapshot.image.draw(at: .zero)
                
                let path = UIBezierPath()
                let points = coordinates.map { snapshot.point(for: $0) }
                if let firstPoint = points.first {
                    path.move(to: firstPoint)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                UIColor.blue.setStroke()
                path.lineWidth = 2
                path.stroke()
            }
            
            DispatchQueue.main.async {
                self.snapshotImage = image
            }
        }
    }
}

struct SessionSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = SessionManager()
        let locationManager = LocationManager()
        manager.saveSession(
            name: "Test Session",
            coordinates: [
                CLLocationCoordinate2D(latitude: 38.811, longitude: -84.611),
                CLLocationCoordinate2D(latitude: 38.812, longitude: -84.612)
            ],
            area: 2.5
        )
        return SessionSummaryView(sessionManager: manager, locationManager: locationManager)
            .previewDevice("iPhone 16 Pro")
            .environment(\.colorScheme, .light)
    }
}
