//
//  WelcomeScreen.swift
//  WishKit
//
//  Created by diayan siat on 08/11/2025.
//

import SwiftUI

struct WelcomeScreen: View {
    @Binding var showContent: Bool
    @Binding var iconRotation: Double
    @Binding var iconScale: Double
    let onContinue: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                // Animated Sparkle Icon
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.orange.opacity(0.3), Color.pink.opacity(0.15), Color.clear],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .blur(radius: 15)
                        .scaleEffect(iconScale)

                    // Sparkle icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 80, weight: .regular))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .pink, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(iconRotation))
                        .scaleEffect(iconScale)
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.5)

                // Headline
                VStack(spacing: 12) {
                    Text("Send The Perfect Message")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .multilineTextAlignment(.center)

                    Text("To friends, family, and loved ones \nevery message matters")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
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
                    Text("Let's Go!")
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
    WelcomeScreen(
        showContent: .constant(true),
        iconRotation: .constant(0),
        iconScale: .constant(1.0),
        onContinue: {}
    )
}
