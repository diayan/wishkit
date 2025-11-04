//
//  View+Animations.swift
//  WishKit
//
//  Created by diayan siat on 03/11/2025.
//

import SwiftUI

// MARK: - Button Styles with Animations

struct ScaleButtonStyle: ButtonStyle {
    let scaleAmount: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .brightness(configuration.isPressed ? -0.03 : 0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Selection Animation

struct SelectionAnimation: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isSelected ? 1.08 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isSelected)
    }
}

// MARK: - Custom Transitions

extension AnyTransition {
    static var slideAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }

    static var scaleAndFade: AnyTransition {
        .scale(scale: 0.95).combined(with: .opacity)
    }
}

// MARK: - View Extensions

extension View {
    func buttonPressAnimation() -> some View {
        self.buttonStyle(ScaleButtonStyle(scaleAmount: 0.95))
    }

    func gentleBounce() -> some View {
        self.buttonStyle(ScaleButtonStyle(scaleAmount: 0.92))
    }

    func cardTapAnimation() -> some View {
        self.buttonStyle(CardButtonStyle())
    }

    func selectionAnimation(isSelected: Bool) -> some View {
        modifier(SelectionAnimation(isSelected: isSelected))
    }
}
