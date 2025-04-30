import Foundation
import CoreLocation

// Custom codable wrapper for CLLocationCoordinate2D
struct CodableCoordinate: Codable {
    let latitude: Double
    let longitude: Double

    init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct SpraySession: Identifiable, Codable {
    let id: UUID
    let name: String
    let coordinates: [CodableCoordinate]
    let area: Double

    // Custom encoding and decoding for coordinates
    enum CodingKeys: String, CodingKey {
        case id, name, coordinates, area
    }

    init(id: UUID, name: String, coordinates: [CLLocationCoordinate2D], area: Double) {
        self.id = id
        self.name = name
        self.coordinates = coordinates.map { CodableCoordinate(from: $0) }
        self.area = area
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let codableCoordinates = try container.decode([CodableCoordinate].self, forKey: .coordinates)
        coordinates = codableCoordinates
        area = try container.decode(Double.self, forKey: .area)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(area, forKey: .area)
    }
}

class SessionManager: ObservableObject {
    @Published var sessions: [SpraySession] = []

    func saveSession(name: String, coordinates: [CLLocationCoordinate2D], area: Double) {
        let session = SpraySession(id: UUID(), name: name, coordinates: coordinates, area: area)
        sessions.append(session)
    }

    func loadSessions() {
        // Placeholder for loading sessions from storage
    }
}
