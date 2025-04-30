import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    struct WeatherData: Codable {
        let temperature: Double
        let windSpeed: Double
        let precipitation: Double
    }

    @Published var weather: WeatherData?

    func fetchWeather(for location: CLLocation) {
        // Placeholder for weather API call
        // In a real app, you'd fetch data from a weather service
        self.weather = WeatherData(temperature: 20.0, windSpeed: 5.0, precipitation: 10.0)
    }
}
