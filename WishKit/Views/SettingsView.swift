//
//  SettingsView.swift
//  WishKit
//
//  Created by diayan siat on 07/11/2025.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var appearanceManager = AppearanceManager.shared
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var notificationsEnabled = false
    @State private var isCheckingPermission = true
    @State private var isAnimated = false
    @State private var showCustomerCenter = false
    @State private var showPaywall = false

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with dismiss button
                HStack {
                    Spacer()

                    Button(action: {
                        HapticManager.light()
                        dismiss()
                    }) {
                        dismissButton
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .opacity(isAnimated ? 1 : 0)

                // Title
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : -20)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {

                        // General Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionTitle("General")

                            SettingsToggleCard(
                                icon: "bell.fill",
                                iconColor: .orange,
                                title: "Notifications",
                                subtitle: "Get reminders for special occasions",
                                isOn: $notificationsEnabled,
                                isLoading: isCheckingPermission
                            ) { newValue in
                                handleNotificationToggle(newValue)
                            }

                            SettingsActionCard(
                                icon: "star.fill",
                                iconColor: .orange,
                                title: "Rate the App",
                                subtitle: "Share your experience on the App Store"
                            ) {
                                rateApp()
                            }

                            // Appearance Picker
                            AppearancePickerCard(
                                icon: "paintbrush.fill",
                                iconColor: .indigo,
                                title: "Appearance",
                                subtitle: "Choose your preferred theme",
                                selectedMode: $appearanceManager.selectedMode
                            )

                            // Subscription Management
                            if subscriptionManager.isSubscribed {
                                SettingsActionCard(
                                    icon: "crown.fill",
                                    iconColor: .purple,
                                    title: "Manage Subscription",
                                    subtitle: "View and manage your Wishly Pro subscription"
                                ) {
                                    showCustomerCenter = true
                                }
                            } else {
                                SettingsActionCard(
                                    icon: "crown.fill",
                                    iconColor: .orange,
                                    title: "Subscribe to Wishly Pro",
                                    subtitle: "Unlock unlimited messages and all themes"
                                ) {
                                    showPaywall = true
                                }
                            }

                            SettingsActionCard(
                                icon: "envelope.fill",
                                iconColor: .red,
                                title: "Support or Feedback",
                                subtitle: "Get help or share your thoughts"
                            ) {
                                sendFeedback()
                            }
                            
                        }
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 20)

                        // Sharing Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionTitle("Sharing is Caring")

                            SettingsActionCard(
                                icon: "square.and.arrow.up.fill",
                                iconColor: .blue,
                                title: "Share App with Friends",
                                subtitle: "Help others create amazing messages"
                            ) {
                                shareApp()
                            }
                        }
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 20)

                        // Legal Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionTitle("Legal")

                            SettingsActionCard(
                                icon: "hand.raised.fill",
                                iconColor: .purple,
                                title: "Privacy Policy",
                                subtitle: "How we handle your information"
                            ) {
                                openPrivacyPolicy()
                            }

                            SettingsActionCard(
                                icon: "doc.text.fill",
                                iconColor: .gray,
                                title: "Terms of Use",
                                subtitle: "Terms and conditions"
                            ) {
                                openTermsOfUse()
                            }
                        }
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 20)

                        // Version
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                            .opacity(isAnimated ? 1 : 0)

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
        }
        .preferredColorScheme(appearanceManager.currentColorScheme)
        .sheet(isPresented: $showCustomerCenter) {
            CustomerCenterView()
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView {
                showPaywall = false
            }
        }
        .onAppear {
            checkNotificationStatus()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                isAnimated = true
            }
        }
    }

    // MARK: - Actions

    private func checkNotificationStatus() {
        NotificationManager.shared.checkAuthorizationStatus { status in
            isCheckingPermission = false
            notificationsEnabled = (status == .authorized)
        }
    }

    private func handleNotificationToggle(_ enabled: Bool) {
        HapticManager.light()

        if enabled {
            // Request permission
            NotificationManager.shared.requestPermission { granted in
                notificationsEnabled = granted
                if granted {
                    HapticManager.success()
                } else {
                    HapticManager.warning()
                    // Show alert to go to Settings
                    openAppSettings()
                }
            }
        } else {
            // Disable notifications
            NotificationManager.shared.cancelAllNotifications()
            notificationsEnabled = false
            HapticManager.success()
        }
    }

    private func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings)
        }
    }

    private func rateApp() {
        HapticManager.medium()
        // TODO: Replace with actual App Store ID when published
        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
            UIApplication.shared.open(url)
        }
    }

    private func sendFeedback() {
        HapticManager.medium()
        if let url = URL(string: "mailto:diayansiat@gmail.com?subject=WishKit%20Feedback") {
            UIApplication.shared.open(url)
        }
    }

    private func shareApp() {
        HapticManager.medium()
        let text = "Check out WishKit - Create personalized AI messages for any occasion! ✨"
        let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!

        let activityVC = UIActivityViewController(
            activityItems: [text, url],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

    private func openPrivacyPolicy() {
        HapticManager.medium()
        if let url = URL(string: "https://wishkit.app/privacy") {
            UIApplication.shared.open(url)
        }
    }

    private func openTermsOfUse() {
        HapticManager.medium()
        if let url = URL(string: "https://wishkit.app/terms") {
            UIApplication.shared.open(url)
        }
    }
}

@ViewBuilder
private var dismissButton: some View {
    if #available(iOS 26.0, *) {
        Image(systemName: "xmark")
            .font(.title3)
            .foregroundColor(.secondary)
            .padding(12)
            .background(Circle().fill(.clear))
            .glassEffect(.regular.interactive(), in: .circle)
    } else {
        Image(systemName: "xmark")
            .font(.title3)
            .foregroundColor(.secondary)
            .padding(12)
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
    }
}
// MARK: - Settings Toggle Card

struct SettingsToggleCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let isLoading: Bool
    let onChange: (Bool) -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if isLoading {
                    ProgressView()
                        .tint(.secondary)
                } else {
                    Toggle("", isOn: $isOn)
                        .labelsHidden()
                        .tint(.orange)
                        .onChange(of: isOn) { oldValue, newValue in
                            onChange(newValue)
                        }
                }
            }
        }
        .padding(20)
        .cardStyle()
    }
}

// MARK: - Settings Action Card

struct SettingsActionCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: {
            HapticManager.light()
            action()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .cardStyle()
        }
        .buttonPressAnimation()
    }
}

// MARK: - Appearance Picker Card

struct AppearancePickerCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var selectedMode: AppearanceMode

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            // Appearance Mode Picker
            HStack(spacing: 12) {
                ForEach(AppearanceMode.allCases) { mode in
                    Button(action: {
                        HapticManager.selection()
                        selectedMode = mode
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: mode.icon)
                                .font(.title2)
                                .foregroundColor(selectedMode == mode ? .orange : .secondary)

                            Text(mode.rawValue)
                                .font(.caption)
                                .fontWeight(selectedMode == mode ? .semibold : .regular)
                                .foregroundColor(selectedMode == mode ? .orange : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedMode == mode
                                      ? Color.orange.opacity(0.15)
                                      : (colorScheme == .dark
                                         ? Color.white.opacity(0.05)
                                         : Color.gray.opacity(0.1)))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedMode == mode
                                        ? Color.orange.opacity(0.5)
                                        : Color.clear,
                                        lineWidth: 2)
                        )
                    }
                    .buttonPressAnimation()
                }
            }
        }
        .padding(20)
        .cardStyle()
    }
}

#Preview {
    SettingsView()
}
