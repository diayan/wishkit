//
//  MessageThemeView.swift
//  WishKit
//
//  Created by diayan siat on 31/10/2025.
//

import SwiftUI

struct MessageThemeView: View {
    @Binding var navigationPath: NavigationPath
    @Binding var selectedTab: Int

    @Environment(MessageState.self) private var messageState
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var isButtonAnimating: Bool = false
    @State private var showGeneratedMessage: Bool = false
    @State private var isAnimated: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var showSettings = false
    @State private var showPaywall = false
    @Environment(\.colorScheme) private var colorScheme

    private var bindableState: Bindable<MessageState> {
        Bindable(messageState)
    }

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()
                .dismissKeyboardOnTap()

            VStack(spacing: 0) {
                HeaderView(title: "What's the vibe?", currentStep: 1)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 40) {
                        ThemeSelectionSection(
                            includeTheme: bindableState.includeTheme,
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

                        // Trial countdown banner (only show if not subscribed and within grace period)
                        if !subscriptionManager.isSubscribed && subscriptionManager.isWithinGracePeriod {
                            TrialBanner(daysRemaining: subscriptionManager.daysRemainingInTrial) {
                                HapticManager.light()
                                showPaywall = true
                            }
                            .opacity(isAnimated ? 1 : 0)
                            .offset(y: isAnimated ? 0 : 20)
                        }

                        GenerateMessageButton(
                            isAnimating: $isButtonAnimating,
                            isEnabled: messageState.canGenerateMessage,
                            isGenerating: messageState.isGenerating
                        ) {
                            // Check if user has access (subscribed OR within 3-day grace period)
                            if !subscriptionManager.hasAccess {
                                HapticManager.warning()
                                showPaywall = true
                            } else {
                                Task {
                                    await messageState.generateMessage()
                                    if messageState.generationError != nil {
                                        HapticManager.error()
                                        showErrorAlert = true
                                    } else if !messageState.generatedMessage.isEmpty {
                                        HapticManager.success()
                                        showGeneratedMessage = true
                                        // Track successful generation and potentially request review
                                        RatingManager.shared.messageGeneratedSuccessfully()
                                    }
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    HapticManager.light()
                    showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView {
                showPaywall = false
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                isAnimated = true
            }
        }
        .sheet(isPresented: $showGeneratedMessage) {
            GeneratedMessageView(
                onCreateAnother: {
                    messageState.reset()
                    showGeneratedMessage = false
                    navigationPath.removeLast(navigationPath.count)
                },
                onDismiss: {
                    messageState.reset()
                    showGeneratedMessage = false
                    selectedTab = 1  // Switch to History tab
                }
            )
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
                        // Track successful generation and potentially request review
                        RatingManager.shared.messageGeneratedSuccessfully()
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
    @Previewable @State var path = NavigationPath()
    @Previewable @State var tab = 0
    MessageThemeView(navigationPath: $path, selectedTab: $tab)
        .environment(MessageState())
}
