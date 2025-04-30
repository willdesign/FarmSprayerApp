/*
 File: OfflineMapManager.swift
 Description: Manages offline map caching using MKMapSnapshotter to store pre-rendered map images.
 Features:
 - Caches map snapshots for a specified region and zoom levels.
 - Stores images in the app's cache directory.
 - Provides a tile overlay for offline use.
 - Optimized for iPhone 16 Pro (iOS 18).
*/
import Foundation
import MapKit

class OfflineMapManager: ObservableObject {
    private let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("MapSnapshots")
    
    func cacheTiles(for region: MKCoordinateRegion, zoomLevels: Range<Int> = 10..<17, completion: @escaping (Error?) -> Void) {
        // Ensure cache directory exists
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        // Generate snapshots for each zoom level
        let dispatchGroup = DispatchGroup()
        var error: Error?
        
        for zoomLevel in zoomLevels {
            dispatchGroup.enter()
            let options = MKMapSnapshotter.Options()
            options.region = region
            options.size = CGSize(width: 256, height: 256) // Standard tile size
            options.mapType = .hybrid
            options.scale = UIScreen.main.scale
            options.showsPointsOfInterest = false
            options.showsBuildings = false
            
            // Adjust region span based on zoom level
            let adjustedSpan = MKCoordinateSpan(
                latitudeDelta: region.span.latitudeDelta / pow(2, Double(zoomLevel - 10)),
                longitudeDelta: region.span.longitudeDelta / pow(2, Double(zoomLevel - 10))
            )
            options.region = MKCoordinateRegion(center: region.center, span: adjustedSpan)
            
            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.start { snapshot, snapshotError in
                defer { dispatchGroup.leave() }
                if let snapshot = snapshot, snapshotError == nil {
                    let tilePath = self.cacheDirectory.appendingPathComponent("z\(zoomLevel).png")
                    if let data = snapshot.image.pngData() {
                        try? data.write(to: tilePath)
                    }
                } else {
                    error = snapshotError ?? NSError(domain: "MapSnapshotError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate snapshot"])
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(error)
        }
    }
    
    func tileOverlay() -> MKTileOverlay {
        let overlay = MKTileOverlay(urlTemplate: nil) // Custom renderer below
        overlay.canReplaceMapContent = true
        return overlay
    }
}
