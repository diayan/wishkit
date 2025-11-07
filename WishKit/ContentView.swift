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
    @Environment(\.modelContext) private var modelContext

    var body: some View {
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
