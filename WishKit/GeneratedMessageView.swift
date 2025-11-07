//
//  GeneratedMessageView.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct GeneratedMessageView: View {
    // Optional parameters for direct message display
    let recipientName: String?
    let occasion: String?
    let theme: String?
    let messageText: String?
    let onCreateAnother: (() -> Void)?
    let onDismiss: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(MessageState.self) private var messageState
    @State private var isAnimated: Bool = false

    // Default initializer for use with MessageState environment (deprecated)
    init() {
        self.recipientName = nil
        self.occasion = nil
        self.theme = nil
        self.messageText = nil
        self.onCreateAnother = nil
        self.onDismiss = nil
    }

    // Initializer with create another callback
    init(onCreateAnother: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        self.recipientName = nil
        self.occasion = nil
        self.theme = nil
        self.messageText = nil
        self.onCreateAnother = onCreateAnother
        self.onDismiss = onDismiss
    }

    // Initializer for direct message display (e.g., from history)
    init(recipientName: String, occasion: String, theme: String?, messageText: String) {
        self.recipientName = recipientName
        self.occasion = occasion
        self.theme = theme
        self.messageText = messageText
        self.onCreateAnother = nil
        self.onDismiss = nil
    }

    // Computed properties to get the correct data source
    private var displayRecipientName: String {
        recipientName ?? messageState.recipientName
    }

    private var displayOccasion: String {
        occasion ?? (messageState.selectedOccasion?.displayName ?? "")
    }

    private var displayTheme: String? {
        theme ?? (messageState.themeName.isEmpty ? nil : messageState.themeName)
    }

    private var displayMessage: String {
        messageText ?? messageState.generatedMessage
    }

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()

                    Button(action: {
                        if let onDismiss = onDismiss {
                            onDismiss()
                        } else {
                            dismiss()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .opacity(isAnimated ? 1 : 0)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        SuccessHeaderSection(
                            recipientName: displayRecipientName,
                            occasion: displayOccasion,
                            theme: displayTheme
                        )
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 30)

                        MessageDisplayCard(messageText: displayMessage)
                            .opacity(isAnimated ? 1 : 0)
                            .offset(y: isAnimated ? 0 : 30)

                        ActionButtonsSection(
                            messageText: displayMessage,
                            onCreateAnother: onCreateAnother != nil ? {
                                onCreateAnother?()
                            } : nil
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
