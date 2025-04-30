/*
 File: SettingsView.swift
 Description: Provides settings UI with offline map snapshot caching and progress feedback.
 Features:
 - Button to download map snapshots with a progress indicator.
 - Dismiss button to exit settings.
*/
import SwiftUI
import MapKit

struct SettingsView: View {
    @Binding var region: MKCoordinateRegion
    @Environment(\.dismiss) var dismiss
    @StateObject private var offlineManager = OfflineMapManager()
    @State private var isDownloading = false
    @State private var downloadError: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Offline Maps")) {
                    if isDownloading {
                        ProgressView("Downloading map snapshots...")
                    } else {
                        Button("Download Map for Current Area") {
                            isDownloading = true
                            downloadError = nil
                            offlineManager.cacheTiles(for: region) { error in
                                DispatchQueue.main.async {
                                    isDownloading = false
                                    if let error = error {
                                        downloadError = error.localizedDescription
                                    } else {
                                        downloadError = "Download complete!"
                                    }
                                }
                            }
                        }
                        .disabled(isDownloading)
                    }
                    if let errorMessage = downloadError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .accessibilityLabel("Close settings")
                }
            }
        }
    }
}
