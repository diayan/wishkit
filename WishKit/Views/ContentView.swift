//
//  ContentView.swift
//  WishKit
//
//  Created by diayan siat on 30/10/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var messageState = MessageState()
    @State private var selectedTab: Int = 0
    @State private var navigationPath = NavigationPath()
    @State private var showNotificationPermission = false
    @State private var showOnboarding = false
    @State private var showLaunchScreen = true
    @State private var appearanceManager = AppearanceManager.shared
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            // Main App Content
            mainContent
                .opacity(showLaunchScreen ? 0 : 1)
                .preferredColorScheme(appearanceManager.currentColorScheme)

            // Launch Screen
            if showLaunchScreen {
                LaunchScreen(isActive: $showLaunchScreen)
                    .transition(.opacity)
                    .zIndex(1)
                    .preferredColorScheme(appearanceManager.currentColorScheme)
            }
        }
    }

    private var mainContent: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $navigationPath) {
                PersonalInformationView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        switch destination {
                        case .messageTheme:
                            MessageThemeView(
                                navigationPath: $navigationPath,
                                selectedTab: $selectedTab
                            )
                        }
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            NavigationStack {
                MessageHistoryView(selectedTab: $selectedTab)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }
            .tag(1)
        }
        .tint(.red)
        .environment(messageState)
        .onAppear {
            messageState.setModelContext(modelContext)
            checkOnboarding()
            checkNotificationPermission()
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .sheet(isPresented: $showNotificationPermission) {
            NotificationPermissionView { granted in
                if granted {
                    print("✅ User enabled notifications")
                } else {
                    print("ℹ️ User declined notifications")
                }
            }
        }
    }

    /// Check if user has completed onboarding
    private func checkOnboarding() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if !hasCompletedOnboarding {
            showOnboarding = true
        }
    }

    /// Check and prompt for notification permission after first message
    private func checkNotificationPermission() {
        // Check if user has already been asked
        let hasAskedForPermission = UserDefaults.standard.bool(forKey: "hasAskedForNotificationPermission")

        guard !hasAskedForPermission else { return }

        // Check if user has generated at least one message
        let messageCount = UserDefaults.standard.integer(forKey: "totalMessagesGenerated")

        if messageCount >= 1 {
            // Check current authorization status
            NotificationManager.shared.checkAuthorizationStatus { status in
                if status == .notDetermined {
                    // Show permission prompt after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showNotificationPermission = true
                        UserDefaults.standard.set(true, forKey: "hasAskedForNotificationPermission")
                    }
                }
            }
        }
    }
}

// MARK: - Navigation Destination

enum NavigationDestination: Hashable {
    case messageTheme
}

#Preview {
    ContentView()
        .modelContainer(for: SavedMessage.self, inMemory: true)
}
