import SwiftUI

struct WeatherView: View {
    let weather: WeatherManager.WeatherData?

    var body: some View {
        if let weather = weather {
            HStack {
                Text("Temp: \(weather.temperature, specifier: "%.1f")°C")
                Text("Wind: \(weather.windSpeed, specifier: "%.1f") m/s")
                Text("Rain: \(weather.precipitation, specifier: "%.0f")%")
            }
            .padding(8)
            .background(Color.gray.opacity(0.8))
            .cornerRadius(10)
        } else {
            Text("No weather data available")
        }
    }
}
