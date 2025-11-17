//
//  AppearanceManager.swift
//  WishKit
//
//  Created by diayan siat on 09/11/2025.
//

import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    var icon: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
}

@Observable
class AppearanceManager {
    static let shared = AppearanceManager()

    private let userDefaultsKey = "selectedAppearanceMode"

    var selectedMode: AppearanceMode {
        didSet {
            UserDefaults.standard.set(selectedMode.rawValue, forKey: userDefaultsKey)
        }
    }

    private init() {
        // Load saved preference or default to system
        if let savedMode = UserDefaults.standard.string(forKey: userDefaultsKey),
           let mode = AppearanceMode(rawValue: savedMode) {
            self.selectedMode = mode
        } else {
            self.selectedMode = .system
        }
    }

    var currentColorScheme: ColorScheme? {
        selectedMode.colorScheme
    }
}
