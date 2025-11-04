//
//  ContentView.swift
//  WishKit
//
//  Created by diayan siat on 30/10/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var messageState = MessageState()

    var body: some View {
        TabView {
            NavigationStack {
                PersonalInformationView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                MessageHistoryView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }
        }
        .tint(.red)
        .environment(messageState)
    }
}

#Preview {
    ContentView()
}
