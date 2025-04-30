/*
 File: WeatherManager.swift
 Description: Fetches and manages real-time weather data using WeatherKit.
 Features:
 - Fetches temperature, wind speed, and precipitation for the current location.
 - Optimized for Verona, KY fields.
*/
import Foundation
import CoreLocation
import WeatherKit

class WeatherManager: ObservableObject {
    @Published var weather: WeatherData?
    
    struct WeatherData {
        let temperature: Double // Celsius
        let windSpeed: Double // Meters per second
        let precipitation: Double // Percentage
    }
    
    func fetchWeather(for location: CLLocation, completion: @escaping () -> Void = {}) {
        Task {
            do {
                let service = WeatherService.shared
                let weather = try await service.weather(for: location)
                let currentWeather = weather.currentWeather
                let hourlyForecast = weather.hourlyForecast.first
                
                self.weather = WeatherData(
                    temperature: currentWeather.temperature.value, // Already in Celsius
                    windSpeed: currentWeather.wind.speed.value, // Meters per second
                    precipitation: (hourlyForecast?.precipitationChance ?? 0) * 100 // Convert to percentage
                )
                await MainActor.run {
                    completion()
                }
            } catch {
                print("Weather fetch error: \(error)")
                // Fallback to mock data if API fails
                self.weather = WeatherData(temperature: 20.0, windSpeed: 5.0, precipitation: 10.0)
                await MainActor.run {
                    completion()
                }
            }
        }
    }
}
