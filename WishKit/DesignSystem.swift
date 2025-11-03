//
//  DesignSystem.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

// MARK: - App Colors

enum AppColors {
    static func backgroundGradient(for colorScheme: ColorScheme) -> LinearGradient {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(red: 0.18, green: 0.09, blue: 0.07), Color.black]
                : [Color(red: 1.0, green: 0.72, blue: 0.68), Color(red: 0.94, green: 0.87, blue: 0.84)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func cardGradient(for colorScheme: ColorScheme) -> LinearGradient {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(red: 0.12, green: 0.08, blue: 0.08), Color(red: 0.10, green: 0.07, blue: 0.07)]
                : [Color(red: 0.99, green: 0.88, blue: 0.86), Color(red: 0.97, green: 0.91, blue: 0.89)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static func cardBorderColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark
            ? Color(red: 0.25, green: 0.15, blue: 0.13).opacity(0.6)
            : Color.white.opacity(0.5)
    }

    static func cardShadow(for colorScheme: ColorScheme) -> Color {
        Color.black.opacity(colorScheme == .dark ? 0.3 : 0.12)
    }

    static var primaryButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.3, blue: 0.2),
                Color(red: 0.95, green: 0.25, blue: 0.15)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Card Style Modifier

struct CardStyleModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(AppColors.cardGradient(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(AppColors.cardBorderColor(for: colorScheme), lineWidth: 1.5)
                    )
                    .shadow(color: AppColors.cardShadow(for: colorScheme), radius: 16, x: 0, y: 6)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyleModifier())
    }
}
