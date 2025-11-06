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
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                PersonalInformationView()
                    .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    ContentView()
        .modelContainer(for: SavedMessage.self, inMemory: true)
}
