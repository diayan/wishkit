//
//  LengthButton.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct LengthButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            isSelected ?
                            AppColors.primaryButtonGradient :
                            LinearGradient(
                                colors: colorScheme == .dark
                                ? [Color(red: 0.08, green: 0.06, blue: 0.06), Color(red: 0.08, green: 0.06, blue: 0.06)]
                                : [Color.white.opacity(0.5), Color.white.opacity(0.5)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    isSelected ? Color.clear :
                                    (colorScheme == .dark
                                    ? Color(red: 0.2, green: 0.13, blue: 0.11).opacity(0.8)
                                    : Color.white.opacity(0.3)),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(
                            color: isSelected ? Color.orange.opacity(0.3) : Color.black.opacity(colorScheme == .dark ? 0.2 : 0.08),
                            radius: isSelected ? 12 : 8,
                            x: 0,
                            y: isSelected ? 6 : 4
                        )
                )
                .selectionAnimation(isSelected: isSelected)
        }
        .buttonPressAnimation()
    }
}
