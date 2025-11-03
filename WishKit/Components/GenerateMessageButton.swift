//
//  GenerateMessageButton.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct GenerateMessageButton: View {
    @Binding var isAnimating: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
                action()
            }
        }) {
            ZStack {
                // Animated glow effect
                Capsule()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6),
                                Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.0)
                            ]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 100
                        )
                    )
                    .frame(height: 64)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(isAnimating ? 0.8 : 0.5)
                    .blur(radius: 8)

                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .bold))
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))

                    Text("Generate My Message")
                        .font(.system(size: 19, weight: .bold))

                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .bold))
                        .rotationEffect(.degrees(isAnimating ? -360 : 0))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.35, blue: 0.2),
                                    Color(red: 0.98, green: 0.28, blue: 0.15),
                                    Color(red: 1.0, green: 0.35, blue: 0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.4),
                                            Color.white.opacity(0.1)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: Color(red: 1.0, green: 0.35, blue: 0.2).opacity(0.5), radius: 20, x: 0, y: 10)
                        .shadow(color: Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
                )
                .scaleEffect(isAnimating ? 0.95 : 1.0)
            }
        }
    }
}
