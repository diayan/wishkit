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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedMessage.self)
    }
}
