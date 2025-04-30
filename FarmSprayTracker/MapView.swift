import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var path: [CLLocationCoordinate2D]
    var overlapPath: [CLLocationCoordinate2D]
    var applicatorWidth: Double

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeOverlays(uiView.overlays)
        if path.count > 1 {
            let sprayOverlay = SprayAreaOverlay(path: path, sprayWidth: applicatorWidth)
            uiView.addOverlay(sprayOverlay)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let sprayOverlay = overlay as? SprayAreaOverlay {
                let renderer = MKPolygonRenderer(polygon: sprayOverlay.polygon())
                renderer.fillColor = UIColor.blue.withAlphaComponent(0.3)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 1
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

class SprayAreaOverlay: NSObject, MKOverlay {
    let path: [CLLocationCoordinate2D]
    let sprayWidth: Double
    let boundingMapRect: MKMapRect
    let coordinate: CLLocationCoordinate2D

    init(path: [CLLocationCoordinate2D], sprayWidth: Double) {
        self.path = path
        self.sprayWidth = sprayWidth

        var minPoint = MKMapPoint(x: Double.greatestFiniteMagnitude, y: Double.greatestFiniteMagnitude)
        var maxPoint = MKMapPoint(x: -Double.greatestFiniteMagnitude, y: -Double.greatestFiniteMagnitude)
        for coord in path {
            let point = MKMapPoint(coord)
            minPoint.x = min(minPoint.x, point.x)
            minPoint.y = min(minPoint.y, point.y)
            maxPoint.x = max(maxPoint.x, point.x)
            maxPoint.y = max(maxPoint.y, point.y)
        }
        let padding = sprayWidth * 0.3048
        self.boundingMapRect = MKMapRect(
            x: minPoint.x - padding,
            y: minPoint.y - padding,
            width: maxPoint.x - minPoint.x + 2 * padding,
            height: maxPoint.y - minPoint.y + 2 * padding
        )
        self.coordinate = path[path.count / 2]

        super.init()
    }

    func polygon() -> MKPolygon {
        var leftPoints: [CLLocationCoordinate2D] = []
        var rightPoints: [CLLocationCoordinate2D] = []

        for i in 0..<path.count - 1 {
            let p1 = path[i]
            let p2 = path[i + 1]
            let bearing = calculateBearing(from: p1, to: p2)
            let halfWidth = sprayWidth / 2.0 * 0.3048

            let leftOffset = offsetCoordinate(p1, distance: halfWidth, bearing: bearing + 90)
            let rightOffset = offsetCoordinate(p1, distance: halfWidth, bearing: bearing - 90)
            leftPoints.append(leftOffset)
            rightPoints.append(rightOffset)

            if i == path.count - 2 {
                let leftEnd = offsetCoordinate(p2, distance: halfWidth, bearing: bearing + 90)
                let rightEnd = offsetCoordinate(p2, distance: halfWidth, bearing: bearing - 90)
                leftPoints.append(leftEnd)
                rightPoints.append(rightEnd)
            }
        }

        let allPoints = leftPoints + rightPoints.reversed()
        return MKPolygon(coordinates: allPoints, count: allPoints.count)
    }

    private func calculateBearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let lat1 = from.latitude * .pi / 180
        let lon1 = from.longitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let lon2 = to.longitude * .pi / 180

        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        return atan2(y, x) * 180 / .pi
    }

    private func offsetCoordinate(_ coordinate: CLLocationCoordinate2D, distance: Double, bearing: Double) -> CLLocationCoordinate2D {
        let earthRadius = 6371000.0
        let bearingRad = bearing * .pi / 180
        let latRad = coordinate.latitude * .pi / 180
        let lonRad = coordinate.longitude * .pi / 180

        let newLat = asin(sin(latRad) * cos(distance / earthRadius) + cos(latRad) * sin(distance / earthRadius) * cos(bearingRad))
        let newLon = lonRad + atan2(sin(bearingRad) * sin(distance / earthRadius) * cos(latRad), cos(distance / earthRadius) - sin(latRad) * sin(newLat))

        return CLLocationCoordinate2D(latitude: newLat * 180 / .pi, longitude: newLon * 180 / .pi)
    }
}
