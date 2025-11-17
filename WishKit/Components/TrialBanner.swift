//
//  TrialBanner.swift
//  WishKit
//
//  Created by diayan siat on 14/11/2025.
//

import SwiftUI

struct TrialBanner: View {
    let daysRemaining: Int
    let onTap: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: {
            HapticManager.light()
            onTap()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "gift.fill")
                    .font(.title3)
                    .foregroundColor(.orange)

                VStack(alignment: .leading, spacing: 2) {
                    Text(daysRemaining == 1 ? "Last day of free trial!" : "\(daysRemaining) days left in your free trial")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("Subscribe anytime")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .cardStyle()
        }
        .buttonPressAnimation()
    }
}

#Preview {
    VStack(spacing: 16) {
        TrialBanner(daysRemaining: 3) {
            print("Tapped")
        }

        TrialBanner(daysRemaining: 1) {
            print("Tapped")
        }
    }
    .padding()
}
