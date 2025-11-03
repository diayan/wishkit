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
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color.opacity(0.2) : .white)
                        .frame(width: 72, height: 72)
                        .shadow(
                            color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.2),
                            radius: isSelected ? 10 : 8,
                            x: 0,
                            y: isSelected ? 6 : 4
                        )
                        .shadow(
                            color: isSelected ? color.opacity(colorScheme == .dark ? 0.7 : 0.6) : Color.clear,
                            radius: isSelected ? 16 : 0,
                            x: 0,
                            y: 0
                        )

                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                .background(
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(colorScheme == .dark ? 0.5 : 0.4),
                                    color.opacity(0.0)
                                ]),
                                center: .center,
                                startRadius: 20,
                                endRadius: colorScheme == .dark ? 50 : 45
                            )
                        )
                        .frame(width: 90, height: 90)
                        .opacity(isSelected ? 1 : 0)
                )

                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? color : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
