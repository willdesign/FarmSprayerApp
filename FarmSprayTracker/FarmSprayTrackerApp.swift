/*
 File: FarmSprayTrackerApp.swift
 Description: Entry point for FarmSprayTracker app.
 Changes:
 - Updated ContentView initialization to match its parameter-less structure.
 - Added environment objects for dependency injection.
*/
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
