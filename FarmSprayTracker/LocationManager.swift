import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var path: [CLLocationCoordinate2D] = []
    @Published var overlapPath: [CLLocationCoordinate2D] = []
    @Published var isTracking = false

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func startTracking() {
        manager.startUpdatingLocation()
        isTracking = true
        path = []
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
        isTracking = false
    }

    func pauseTracking() {
        manager.stopUpdatingLocation()
    }

    func resumeTracking() {
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, isTracking {
            currentLocation = location.coordinate
            path.append(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
