//
//  HeaderView.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

// MARK: - Header View

struct HeaderView: View {
    let title: String
    let currentStep: Int
    let totalSteps: Int = 3

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            ProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                .padding(.top, 28)
        }
    }
}

// MARK: - Progress Indicator

struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index == currentStep ? Color.red : Color(.systemGray4))
                    .frame(width: index == currentStep ? 55 : 45, height: 6)
            }
        }
    }
}
