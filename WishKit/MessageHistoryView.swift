//
//  MessageHistoryView.swift
//  WishKit
//
//  Created by diayan siat on 01/11/2025.
//

import SwiftUI

struct MessageHistoryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var isAnimated: Bool = false

    // Sample data
    @State private var messages: [SavedMessage] = [
        SavedMessage(
            id: UUID(),
            recipientName: "Mize",
            occasion: .birthday,
            theme: "Star Trek",
            messageText: "Happy emergence day, Mize! A being celebrates your solar rotation with deep gratitude for your existence",
            date: Date(),
            isFavorite: false
        ),
        SavedMessage(
            id: UUID(),
            recipientName: "Yung",
            occasion: .birthday,
            theme: "Harry Potter",
            messageText: "✨ Happy Birthday, Yung! May your day sparkle with a little mischief, a touch of magic, and the wonder of a well-cast charm. 🪄",
            date: Date(),
            isFavorite: false
        ),
        SavedMessage(
            id: UUID(),
            recipientName: "Ray",
            occasion: .birthday,
            theme: "Friends",
            messageText: "🍕 Happy Birthday, Ray! Hope your day's full of good food, great laughs, and people who know — you're the gift that keeps on giving. How you doin'? 😉",
            date: Date(),
            isFavorite: false
        )

    ]

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Title
                Text("History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : -20)

                // Message Cards
                ScrollView(.vertical, showsIndicators: false) {
                    VStack() {
                        ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                            MessageHistoryCard(message: message)
                                .rotation3DEffect(
                                    .degrees(index % 2 == 0 ? 3 : -3),
                                    axis: (x: 0, y: 0, z: 1)
                                )
                                .offset(x: index % 2 == 0 ? -8 : 8)
                                .zIndex(Double(messages.count - index))
                                .opacity(isAnimated ? 1 : 0)
                                .offset(y: isAnimated ? 0 : 50)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    MessageHistoryView()
}
