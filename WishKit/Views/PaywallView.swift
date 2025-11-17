//
//  PaywallView.swift
//  Wishly
//
//  Created by diayan siat on 11/11/2025.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var onComplete: () -> Void

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            if subscriptionManager.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.orange)

                    Text("Loading...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                }
            } else {
                paywallContent
            }

            // Dismiss button at top right
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        HapticManager.light()
                        onComplete()
                    }) {
                        dismissButton
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }

                Spacer()
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    private var paywallContent: some View {
        RevenueCatUI.PaywallView()
            .onPurchaseCompleted { customerInfo in
                handlePurchaseSuccess(customerInfo)
            }
            .onPurchaseCancelled {
                print("Purchase cancelled")
            }
            .onRestoreCompleted { customerInfo in
                handleRestoreSuccess(customerInfo)
            }
            .onRestoreFailure { error in
                handleError(error)
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

    // MARK: - Actions

    private func handlePurchaseSuccess(_ customerInfo: CustomerInfo) {
        HapticManager.success()
        if subscriptionManager.isSubscribed {
            onComplete()
        }
    }

    private func handleRestoreSuccess(_ customerInfo: CustomerInfo) {
        HapticManager.success()
        if subscriptionManager.isSubscribed {
            onComplete()
        } else {
            errorMessage = "No active subscriptions found."
            showError = true
        }
    }

    private func handleError(_ error: Error) {
        HapticManager.warning()
        errorMessage = error.localizedDescription
        showError = true
    }
}

#Preview {
    PaywallView {
        print("Paywall completed")
    }
}
