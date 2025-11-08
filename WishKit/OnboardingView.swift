//
//  OnboardingView.swift
//  WishKit
//
//  Created by diayan siat on 08/11/2025.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var currentPage: Int = 0
    @State private var showContent: Bool = false
    @State private var iconRotation: Double = 0
    @State private var iconScale: Double = 1.0

    private let totalPages = 4

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            Group {
                switch currentPage {
                case 0:
                    WelcomeScreen(
                        showContent: $showContent,
                        iconRotation: $iconRotation,
                        iconScale: $iconScale,
                        onContinue: { nextPage() }
                    )
                case 1:
                    BasicsScreen(
                        showContent: $showContent,
                        onContinue: { nextPage() }
                    )
                case 2:
                    PersonalizeScreen(
                        showContent: $showContent,
                        onContinue: { nextPage() }
                    )
                case 3:
                    ResultsScreen(
                        showContent: $showContent,
                        onContinue: { nextPage() }
                    )
                default:
                    WelcomeScreen(
                        showContent: $showContent,
                        iconRotation: $iconRotation,
                        iconScale: $iconScale,
                        onContinue: { nextPage() }
                    )
                }
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    // MARK: - Navigation

    private func nextPage() {
        HapticManager.light()
        if currentPage < totalPages - 1 {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                currentPage += 1
            }
            showContent = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startAnimation()
            }
        } else {
            completeOnboarding()
        }
    }

    // MARK: - Animation

    private func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                showContent = true
            }
            startIconAnimation()
        }
    }

    private func startIconAnimation() {
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            iconRotation = 360
        }
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            iconScale = 1.15
        }
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        dismiss()
    }
}

#Preview {
    OnboardingView()
}
