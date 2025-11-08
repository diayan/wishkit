//
//  PersonalizeScreen.swift
//  WishKit
//
//  Created by diayan siat on 08/11/2025.
//

import SwiftUI

struct PersonalizeScreen: View {
    @Binding var showContent: Bool
    let onContinue: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 48) {
                // Illustration - Paintbrush/Customization visual
                ZStack {
                    // Background circle with gradient
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.15), Color.pink.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)

                    // Customization icons
                    VStack(spacing: 8) {
                        // Paintbrush
                        Image(systemName: "paintbrush.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        // Sparkles below
                        HStack(spacing: 8) {
                            Image(systemName: "sparkle")
                                .font(.system(size: 16))
                                .foregroundColor(.yellow)

                            Image(systemName: "sparkle")
                                .font(.system(size: 20))
                                .foregroundColor(.orange)

                            Image(systemName: "sparkle")
                                .font(.system(size: 16))
                                .foregroundColor(.pink)
                        }
                    }
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)

                // Content
                VStack(spacing: 24) {
                    // Title
                    Text("Choose Your Vibe")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .multilineTextAlignment(.center)

                    // Description
                    Text("Pick a theme and add\npersonal touches to make it\nuniquely yours")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
            }
            .padding(.horizontal, 32)

            Spacer()
            Spacer()

            // Continue Button
            Button(action: {
                HapticManager.heavy()
                onContinue()
            }) {
                HStack(spacing: 12) {
                    Text("Continue")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    Capsule()
                        .fill(AppColors.primaryButtonGradient)
                        .shadow(color: Color.orange.opacity(0.4), radius: 20, x: 0, y: 10)
                )
            }
            .buttonPressAnimation()
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        }
    }
}

#Preview {
    PersonalizeScreen(
        showContent: .constant(true),
        onContinue: {}
    )
}
