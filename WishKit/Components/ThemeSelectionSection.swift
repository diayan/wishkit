//
//  ThemeSelectionSection.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct ThemeSelectionSection: View {
    @Binding var selectedTheme: Theme?
    @Binding var themeName: String
    @Environment(\.colorScheme) private var colorScheme

    private let themes: [(Theme, String, String, Color)] = [
        (.movie, "popcorn.fill", "Movie", .indigo),
        (.musician, "music.mic", "Musician", .pink),
        (.tvCharacter, "tv.fill", "TV Character", .orange),
        (.book, "book.fill", "Book", .brown),
        (.show, "film.fill", "Show", .purple),
        (.superhero, "bolt.fill", "Superhero", .green),
        (.custom, "sparkles", "Custom", .teal)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 20) {
                SectionTitle("Choose a theme for your message")

                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { index in
                            let theme = themes[index]
                            SelectionButton(
                                icon: theme.1,
                                label: theme.2,
                                color: theme.3,
                                isSelected: selectedTheme == theme.0,
                                action: {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                        selectedTheme = theme.0
                                    }
                                }
                            )
                        }
                    }

                    HStack(spacing: 8) {
                        ForEach(4..<7, id: \.self) { index in
                            let theme = themes[index]
                            SelectionButton(
                                icon: theme.1,
                                label: theme.2,
                                color: theme.3,
                                isSelected: selectedTheme == theme.0,
                                action: {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                        selectedTheme = theme.0
                                    }
                                }
                            )
                        }
                        Spacer().frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .cardStyle()

            // Conditional TextField
            if let theme = selectedTheme {
                VStack(alignment: .leading, spacing: 16) {
                    SectionTitle(theme.promptText)

                    TextField("", text: $themeName)
                        .placeholder(when: themeName.isEmpty) {
                            Text(theme.placeholderText)
                                .foregroundColor(.secondary)
                        }
                        .font(.body)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 18)
                        .cardStyle()
                }
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
    }
}
