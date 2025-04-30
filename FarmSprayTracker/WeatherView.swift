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
            .accessibilityLabel("Weather: \(weather.temperature, specifier: "%.1f") degrees Celsius, wind \(weather.windSpeed, specifier: "%.1f") meters per second, \(weather.precipitation, specifier: "%.0f") percent chance of rain")
        } else {
            Text("No weather data available")
                .padding(8)
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: WeatherManager.WeatherData(temperature: 20.0, windSpeed: 5.0, precipitation: 10.0))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
