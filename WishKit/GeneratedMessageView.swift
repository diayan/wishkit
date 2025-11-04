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
    @Environment(MessageState.self) private var messageState
    @State private var isAnimated: Bool = false

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
                .opacity(isAnimated ? 1 : 0)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        SuccessHeaderSection(
                            recipientName: messageState.recipientName,
                            occasion: messageState.selectedOccasion?.displayName ?? "",
                            theme: messageState.themeName.isEmpty ? nil : messageState.themeName
                        )
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 30)

                        MessageDisplayCard(messageText: messageState.generatedMessage)
                            .opacity(isAnimated ? 1 : 0)
                            .offset(y: isAnimated ? 0 : 30)

                        ActionButtonsSection(
                            onCopy: {
                                // Copy action
                            },
                            onShare: {
                                // Share action
                            }
                        )
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 30)

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.1)) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    let state = MessageState()
    state.recipientName = "Sarah"
    state.selectedOccasion = .birthday
    state.themeName = "Harry Potter"
    state.generatedMessage = "✨ Happy Birthday, Sarah! May your day sparkle with a little mischief, a touch of magic, and the wonder of a well-cast charm. Here's to another year of adventures, friendships as loyal as a Patronus, and dreams as limitless as the wizarding world itself. Wishing you all the joy and happiness today! 🪄"

    return GeneratedMessageView()
        .environment(state)
}
