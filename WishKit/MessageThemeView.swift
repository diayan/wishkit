//
//  MessageThemeView.swift
//  WishKit
//
//  Created by diayan siat on 31/10/2025.
//

import SwiftUI

struct MessageThemeView: View {
    @Environment(MessageState.self) private var messageState
    @State private var isButtonAnimating: Bool = false
    @State private var showGeneratedMessage: Bool = false
    @State private var isAnimated: Bool = false
    @State private var showErrorAlert: Bool = false
    @Environment(\.colorScheme) private var colorScheme

    private var bindableState: Bindable<MessageState> {
        Bindable(messageState)
    }

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(title: "What's the vibe?", currentStep: 1)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 40) {
                        ThemeSelectionSection(
                            selectedTheme: bindableState.selectedTheme,
                            themeName: bindableState.themeName
                        )
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 20)

                        MessageLengthSection(selectedLength: bindableState.messageLength)
                            .opacity(isAnimated ? 1 : 0)
                            .offset(y: isAnimated ? 0 : 20)

                        EmojiToggleSection(includeEmojis: bindableState.includeEmojis)
                            .opacity(isAnimated ? 1 : 0)
                            .offset(y: isAnimated ? 0 : 20)

                        CustomNotesSection(customNotes: bindableState.customNotes)
                            .opacity(isAnimated ? 1 : 0)
                            .offset(y: isAnimated ? 0 : 20)

                        GenerateMessageButton(
                            isAnimating: $isButtonAnimating,
                            isEnabled: messageState.canGenerateMessage,
                            isGenerating: messageState.isGenerating
                        ) {
                            Task {
                                await messageState.generateMessage()
                                if let error = messageState.generationError {
                                    showErrorAlert = true
                                } else if !messageState.generatedMessage.isEmpty {
                                    showGeneratedMessage = true
                                }
                            }
                        }
                        .padding(.top, 16)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 20)

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                isAnimated = true
            }
        }
        .sheet(isPresented: $showGeneratedMessage) {
            GeneratedMessageView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(28)
        }
        .alert("Generation Failed", isPresented: $showErrorAlert) {
            Button("Try Again") {
                Task {
                    await messageState.generateMessage()
                    if messageState.generationError == nil && !messageState.generatedMessage.isEmpty {
                        showGeneratedMessage = true
                    } else if messageState.generationError != nil {
                        showErrorAlert = true
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                messageState.clearError()
            }
        } message: {
            Text(messageState.generationError ?? "An unknown error occurred")
        }
    }
}

#Preview {
    MessageThemeView()
        .environment(MessageState())
}
