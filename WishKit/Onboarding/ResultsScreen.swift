//
//  ResultsScreen.swift
//  WishKit
//
//  Created by diayan siat on 08/11/2025.
//

import SwiftUI

struct ResultsScreen: View {
    @Binding var showContent: Bool
    let onContinue: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @State private var shimmerOffset: CGFloat = -200
    @State private var glowIntensity: Double = 0.4

    private let messages: [(emoji: String, title: String, snippet: String, color: Color, rotation: Double)] = [
        ("🎂", "Birthday", "Happy Birthday, Mize! Another year of incredible memories. Your kindness lights up every room...", .blue, -8),
        ("💝", "Anniversary", "Happy Anniversary, my love! Every moment with you is a gift. You make ordinary days extraordinary...", .red, -3),
        ("🎓", "Graduation", "Congratulations on your graduation! Your dedication and hard work have truly paid off. I'm so proud...", .green, 6)
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Title
                Text("Make Every Message Memorable")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)

                // Overlapping Message Cards
                ZStack {
                    // Card 3 (back) - Graduation
                    MessageCard(
                        emoji: messages[2].emoji,
                        title: messages[2].title,
                        snippet: messages[2].snippet,
                        color: messages[2].color,
                        rotation: messages[2].rotation
                    )
                    .offset(x: 40, y: 120)
                    .zIndex(1)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.4), value: showContent)

                    // Card 1 (back-middle) - Birthday
                    MessageCard(
                        emoji: messages[0].emoji,
                        title: messages[0].title,
                        snippet: messages[0].snippet,
                        color: messages[0].color,
                        rotation: messages[0].rotation
                    )
                    .offset(x: -40, y: 40)
                    .zIndex(2)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.2), value: showContent)

                    // Card 2 (front) - Anniversary
                    MessageCard(
                        emoji: messages[1].emoji,
                        title: messages[1].title,
                        snippet: messages[1].snippet,
                        color: messages[1].color,
                        rotation: messages[1].rotation
                    )
                    .offset(x: 0, y: -80)
                    .zIndex(3)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.3), value: showContent)
                }
                .frame(height: 380)
            }
            .padding(.horizontal, 32)

            Spacer()

            // Start Creating Button
            Button(action: {
                HapticManager.heavy()
                onContinue()
            }) {
                HStack(spacing: 12) {
                    Text("Start Creating")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    ZStack {
                        // Base gradient with pulsing glow
                        Capsule()
                            .fill(AppColors.primaryButtonGradient)
                            .shadow(color: Color.orange.opacity(glowIntensity), radius: 20, x: 0, y: 10)

                        // Shimmer overlay
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0),
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 100)
                            .offset(x: shimmerOffset)
                            .mask(Capsule())
                    }
                )
            }
            .buttonPressAnimation()
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
            .animation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.5), value: showContent)
            .onAppear {
                startShimmerAnimation()
            }
        }
    }

    // MARK: - Animation

    private func startShimmerAnimation() {
        // Shimmer sweep animation
        withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
            shimmerOffset = 400
        }

        // Pulsing glow animation
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowIntensity = 0.7
        }
    }
}

// MARK: - Message Card Component

struct MessageCard: View {
    let emoji: String
    let title: String
    let snippet: String
    let color: Color
    let rotation: Double

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 8) {
                Text(emoji)
                    .font(.title2)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)

                Spacer()

                // Action icons
                HStack(spacing: 12) {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Image(systemName: "square.and.arrow.up")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Message snippet
            Text(snippet)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(width: 300, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.95))
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    color.opacity(0.3),
                    lineWidth: 1
                )
        )
        .rotationEffect(.degrees(rotation))
    }
}

#Preview {
    ResultsScreen(
        showContent: .constant(true),
        onContinue: {}
    )
}
