//
//  LaunchScreen.swift
//  WishKit
//
//  Created by diayan siat on 08/11/2025.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0
    @State private var iconRotation: Double = 0
    @Binding var isActive: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Magic Wand Icon with Sparkles
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.orange.opacity(0.4),
                                    Color.pink.opacity(0.2),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 30,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 20)

                    // Main sparkles icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 80, weight: .regular))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(iconRotation))

                    // Additional decorative sparkles
                    Image(systemName: "sparkle")
                        .font(.system(size: 20))
                        .foregroundColor(.yellow)
                        .offset(x: -50, y: -40)
                        .opacity(opacity)

                    Image(systemName: "sparkle")
                        .font(.system(size: 16))
                        .foregroundColor(.pink)
                        .offset(x: 50, y: -30)
                        .opacity(opacity)

                    Image(systemName: "sparkle")
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                        .offset(x: -40, y: 50)
                        .opacity(opacity)
                }
                .scaleEffect(scale)
                .opacity(opacity)

                // App Name
                Text("WishKit")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(opacity)
                    .scaleEffect(scale)

                // Tagline
                Text("Make Every Message Magical")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .opacity(opacity * 0.8)
            }
        }
        .onAppear {
            startAnimations()

            // Transition to main app after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isActive = false
                }
            }
        }
    }

    // MARK: - Animations

    private func startAnimations() {
        // Main entrance animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            scale = 1.0
            opacity = 1.0
        }

        // Gentle rotation for sparkles
        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
            iconRotation = 360
        }
    }
}

#Preview {
    LaunchScreen(isActive: .constant(false))
}
