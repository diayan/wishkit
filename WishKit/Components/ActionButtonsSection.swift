//
//  ActionButtonsSection.swift
//  WishKit
//
//  Created by diayan siat on 03/11/2025.
//

import SwiftUI

struct ActionButtonsSection: View {
    let messageText: String
    let onCreateAnother: (() -> Void)?

    @Environment(\.colorScheme) private var colorScheme
    @State private var showCopiedFeedback: Bool = false
    @State private var showShareSheet: Bool = false

    var body: some View {
        HStack(spacing: 24) {
            // Copy Button
            CircularActionButton(
                icon: showCopiedFeedback ? "checkmark" : "doc.on.doc.fill",
                label: showCopiedFeedback ? "Copied!" : "Copy",
                color: .orange,
                colorScheme: colorScheme
            ) {
                HapticManager.success()
                UIPasteboard.general.string = messageText
                showCopiedFeedback = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCopiedFeedback = false
                }
            }

            // Share Button
            CircularActionButton(
                icon: "square.and.arrow.up.fill",
                label: "Share",
                color: .blue,
                colorScheme: colorScheme
            ) {
                HapticManager.medium()
                showShareSheet = true
            }

            // Create Another Button (only shown when creating new messages)
            if let onCreateAnother = onCreateAnother {
                CircularActionButton(
                    icon: "sparkles",
                    label: "Create Another",
                    color: .purple,
                    colorScheme: colorScheme
                ) {
                    HapticManager.medium()
                    onCreateAnother()
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityViewController(activityItems: [messageText])
        }
    }
}

// MARK: - Circular Action Button

struct CircularActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let colorScheme: ColorScheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                circleIcon

                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonPressAnimation()
    }

    @ViewBuilder
    private var circleIcon: some View {
        if #available(iOS 26.0, *) {
            // Liquid Glass version for iOS 26+
            ZStack {
                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            .frame(width: 72, height: 72)
            .background(Circle().fill(.clear))
            .glassEffect(.regular.tint(color.opacity(0.2)).interactive(), in: .circle)
        } else {
            // Original version for iOS 25 and earlier
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(colorScheme == .dark ? 0.3 : 0.2),
                                color.opacity(colorScheme == .dark ? 0.2 : 0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(colorScheme == .dark ? 0.5 : 0.4), lineWidth: 2)
                    )
                    .shadow(
                        color: color.opacity(colorScheme == .dark ? 0.4 : 0.3),
                        radius: 12,
                        x: 0,
                        y: 6
                    )

                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
        }
    }
}
