import SwiftUI

@main
struct FarmSprayTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LocationManager())
                .environmentObject(SessionManager())
                .environmentObject(WeatherManager())
        }
    }
}
