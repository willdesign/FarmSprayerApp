//
//  FarmSprayTrackerApp.swift
//  FarmSprayTracker
//
//  Created by William Smith on 4/11/25.
//

import SwiftUI

@main
struct FarmSprayTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
