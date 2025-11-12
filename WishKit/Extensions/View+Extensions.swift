//
//  View+Extensions.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Liquid Glass Extensions

extension View {
    /// Applies a glass effect with backward compatibility for iOS 25 and earlier
    /// - Parameters:
    ///   - shape: The shape to apply the glass effect to (default: .capsule)
    ///   - interactive: Whether the glass should respond to interactions with shimmer/scale effects
    ///   - tint: Optional color tint for the glass
    @ViewBuilder
    func glassedEffect(
        in shape: some Shape = .capsule,
        interactive: Bool = false,
        tint: Color? = nil
    ) -> some View {
        if #available(iOS 26.0, *) {
            if let tint = tint {
                self.glassEffect(
                    interactive ? .regular.tint(tint).interactive() : .regular.tint(tint),
                    in: shape
                )
            } else {
                self.glassEffect(
                    interactive ? .regular.interactive() : .regular,
                    in: shape
                )
            }
        } else {
            // Fallback for iOS 25 and earlier
            self.background {
                shape
                    .fill(.ultraThinMaterial)
                    .overlay {
                        if let tint = tint {
                            shape.fill(tint.opacity(0.1))
                        }
                    }
                    .overlay {
                        shape
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }

    /// Applies a glass card effect optimized for WishKit's design
    @ViewBuilder
    func glassCardStyle(interactive: Bool = false) -> some View {
        if #available(iOS 26.0, *) {
            self.glassedEffect(
                in: .rect(cornerRadius: 24),
                interactive: interactive
            )
        } else {
            // Use existing card style for older versions
            self.modifier(CardStyleModifier())
        }
    }
}
