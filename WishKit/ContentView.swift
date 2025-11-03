//
//  ContentView.swift
//  WishKit
//
//  Created by diayan siat on 30/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                PersonalInformationView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                MessageHistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }
        }
        .tint(.red)
    }
}

#Preview {
    ContentView()
}
