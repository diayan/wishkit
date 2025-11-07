//
//  WishKitApp.swift
//  WishKit
//
//  Created by diayan siat on 30/10/2025.
//

import SwiftUI
import SwiftData

@main
struct WishKitApp: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        // Track app opens
        NotificationManager.shared.userOpenedApp()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedMessage.self)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                NotificationManager.shared.userOpenedApp()
            case .background:
                // App going to background
                break
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}
