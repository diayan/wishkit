//
//  BasicsScreen.swift
//  WishKit
//
//  Created by diayan siat on 08/11/2025.
//

import SwiftUI

struct BasicsScreen: View {
    @Binding var showContent: Bool
    let onContinue: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 48) {
                // Illustration - Minimalist Dots Flow
                ZStack {
                    // Connecting gradient flow
                    RoundedRectangle(cornerRadius: 60)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.orange.opacity(0.2),
                                    Color.pink.opacity(0.15),
                                    Color.red.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 120)
                        .blur(radius: 20)

                    // Three dots in flowing arrangement
                    HStack(spacing: 40) {
                        // Dot 1 - Person
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange.opacity(0.3), Color.orange.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 70, height: 70)

                            Circle()
                                .stroke(Color.orange.opacity(0.4), lineWidth: 2)
                                .frame(width: 70, height: 70)

                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.orange)
                        }
                        .offset(y: -10)

                        // Dot 2 - Gift/Occasion
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.pink.opacity(0.3), Color.pink.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 70, height: 70)

                            Circle()
                                .stroke(Color.pink.opacity(0.4), lineWidth: 2)
                                .frame(width: 70, height: 70)

                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 26))
                                .foregroundColor(.pink)
                        }
                        .offset(y: 10)

                        // Dot 3 - Heart/Relationship
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.red.opacity(0.3), Color.red.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 70, height: 70)

                            Circle()
                                .stroke(Color.red.opacity(0.4), lineWidth: 2)
                                .frame(width: 70, height: 70)

                            Image(systemName: "heart.fill")
                                .font(.system(size: 26))
                                .foregroundColor(.red)
                        }
                        .offset(y: -5)
                    }
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)

                // Content
                VStack(spacing: 24) {
                    // Title
                    Text("Tell us more")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    // Bullet points
                    VStack(alignment: .leading, spacing: 16) {
                        BulletPoint(icon: "person.circle.fill", text: "Who is it for?", color: .orange)
                        BulletPoint(icon: "calendar.badge.clock", text: "What's the occasion?", color: .pink)
                        BulletPoint(icon: "heart.circle.fill", text: "What's your relationship", color: .red)
                    }
                    .padding(.horizontal, 20)
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

// MARK: - Bullet Point Component

struct BulletPoint: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)

            Text(text)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()
        }
    }
}

#Preview {
    BasicsScreen(
        showContent: .constant(true),
        onContinue: {}
    )
}
