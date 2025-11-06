//
//  ActionButtonsSection.swift
//  WishKit
//
//  Created by diayan siat on 03/11/2025.
//

import SwiftUI

struct ActionButtonsSection: View {
    let messageText: String
    @Environment(\.colorScheme) private var colorScheme
    @State private var showCopiedFeedback: Bool = false
    @State private var showShareSheet: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            // Copy Button
            Button(action: {
                UIPasteboard.general.string = messageText
                showCopiedFeedback = true
                // Hide feedback after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCopiedFeedback = false
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: showCopiedFeedback ? "checkmark" : "doc.on.doc.fill")
                        .font(.system(size: 18, weight: .semibold))

                    Text(showCopiedFeedback ? "Copied!" : "Copy Message")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    Capsule()
                        .fill(AppColors.primaryButtonGradient)
                        .shadow(color: Color.orange.opacity(0.3), radius: 16, x: 0, y: 6)
                )
            }
            .buttonStyle(ScaleButtonStyle(scaleAmount: 0.92))

            // Share Button
            Button(action: {
                showShareSheet = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.system(size: 18, weight: .semibold))

                    Text("Share Message")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    Capsule()
                        .fill(AppColors.cardGradient(for: colorScheme))
                        .overlay(
                            Capsule()
                                .stroke(AppColors.cardBorderColor(for: colorScheme), lineWidth: 1.5)
                        )
                        .shadow(color: AppColors.cardShadow(for: colorScheme).opacity(colorScheme == .dark ? 0.3 : 0.12), radius: 12, x: 0, y: 4)
                )
            }
            .buttonStyle(ScaleButtonStyle(scaleAmount: 0.92))
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityViewController(activityItems: [messageText])
        }
    }
}
