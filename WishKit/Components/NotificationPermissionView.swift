//
//  NotificationPermissionView.swift
//  WishKit
//
//  Created by diayan siat on 07/11/2025.
//

import SwiftUI

/// View to request notification permission from users
struct NotificationPermissionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var isRequesting = false

    let onComplete: (Bool) -> Void

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                }

                VStack(spacing: 16) {
                    Text("Stay Connected")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    Text("Get timely reminders for upcoming occasions and never miss a special moment")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                // Benefits
                VStack(alignment: .leading, spacing: 16) {
                    NotificationBenefit(
                        icon: "calendar.badge.clock",
                        title: "Holiday Reminders",
                        description: "Get notified before major holidays"
                    )

                    NotificationBenefit(
                        icon: "sparkles",
                        title: "Smart Suggestions",
                        description: "Personalized message creation tips"
                    )

                    NotificationBenefit(
                        icon: "lock.shield.fill",
                        title: "Privacy First",
                        description: "All reminders are local to your device"
                    )
                }
                .padding(.horizontal, 32)

                Spacer()

                // Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        requestPermission()
                    }) {
                        HStack(spacing: 12) {
                            if isRequesting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "bell.fill")
                                    .font(.headline)

                                Text("Enable Notifications")
                                    .font(.headline)
                            }
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
                    .disabled(isRequesting)
                    .buttonPressAnimation()

                    Button(action: {
                        HapticManager.light()
                        onComplete(false)
                        dismiss()
                    }) {
                        Text("Maybe Later")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }

    private func requestPermission() {
        isRequesting = true
        HapticManager.medium()

        NotificationManager.shared.requestPermission { granted in
            isRequesting = false

            if granted {
                HapticManager.success()
            }

            onComplete(granted)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        }
    }
}

// MARK: - Notification Benefit Row

struct NotificationBenefit: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    NotificationPermissionView { granted in
        print("Permission granted: \(granted)")
    }
}
