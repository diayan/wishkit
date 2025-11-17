//
//  SelectionButton.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct SelectionButton: View {
    let icon: String
    let label: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            HapticManager.selection()
            action()
        }) {
            VStack(spacing: 10) {
                iconCircle

                Text(label)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(
                        isSelected
                            ? color
                            : (colorScheme == .dark ? .secondary.opacity(0.8) : .secondary)
                    )
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .selectionAnimation(isSelected: isSelected)
        }
        .buttonPressAnimation()
    }

    @ViewBuilder
    private var iconCircle: some View {
        if #available(iOS 26.0, *) {
            // Liquid Glass version for iOS 26+
            ZStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? color : color.opacity(0.8))
            }
            .frame(width: 72, height: 72)
            .background(
                Circle()
                    .fill(.clear)
            )
            .glassEffect(
                isSelected ? .regular.tint(color.opacity(0.3)).interactive() : .regular.interactive(),
                in: .circle
            )
            .background(
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                color.opacity(colorScheme == .dark ? 0.4 : 0.35),
                                color.opacity(0.0)
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: colorScheme == .dark ? 55 : 45
                        )
                    )
                    .frame(width: 100, height: 100)
                    .opacity(isSelected ? 1 : 0)
            )
        } else {
            // Original version for iOS 25 and earlier
            ZStack {
                // Background circle with better dark mode support
                Circle()
                    .fill(
                        colorScheme == .dark
                            ? (isSelected
                                ? color.opacity(0.25)
                                : color.opacity(0.08))
                            : (isSelected
                                ? color.opacity(0.2)
                                : Color.white)
                    )
                    .frame(width: 72, height: 72)

                // Subtle border for definition
                Circle()
                    .stroke(
                        colorScheme == .dark
                            ? (isSelected
                                ? color.opacity(0.5)
                                : color.opacity(0.15))
                            : (isSelected
                                ? color.opacity(0.3)
                                : Color.clear),
                        lineWidth: isSelected ? 2 : 1
                    )
                    .frame(width: 72, height: 72)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? color : (colorScheme == .dark ? color.opacity(0.7) : color))
            }
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.15),
                radius: isSelected ? 8 : 6,
                x: 0,
                y: isSelected ? 4 : 3
            )
            .shadow(
                color: isSelected ? color.opacity(colorScheme == .dark ? 0.6 : 0.5) : Color.clear,
                radius: isSelected ? 20 : 0,
                x: 0,
                y: 0
            )
            .background(
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                color.opacity(colorScheme == .dark ? 0.4 : 0.35),
                                color.opacity(0.0)
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: colorScheme == .dark ? 55 : 45
                        )
                    )
                    .frame(width: 100, height: 100)
                    .opacity(isSelected ? 1 : 0)
            )
        }
    }
}
