//
//  GeneratedMessageView.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct GeneratedMessageView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    // Message details
    let recipientName: String
    let occasion: String
    let theme: String?
    let messageText: String

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()

                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        SuccessHeaderSection(
                            recipientName: recipientName,
                            occasion: occasion,
                            theme: theme
                        )

                        MessageDisplayCard(messageText: messageText)

                        ActionButtonsSection(
                            onCopy: {
                                // Copy action
                            },
                            onShare: {
                                // Share action
                            }
                        )

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

#Preview {
    GeneratedMessageView(
        recipientName: "Sarah",
        occasion: "Birthday",
        theme: "Harry Potter",
        messageText: "✨ Happy Birthday, Sarah! May your day sparkle with a little mischief, a touch of magic, and the wonder of a well-cast charm. Here's to another year of adventures, friendships as loyal as a Patronus, and dreams as limitless as the wizarding world itself. Wishing you all the joy and happiness today! 🪄"
    )
}
