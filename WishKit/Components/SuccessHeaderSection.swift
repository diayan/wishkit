//
//  SuccessHeaderSection.swift
//  WishKit
//
//  Created by diayan siat on 03/11/2025.
//

import SwiftUI

struct SuccessHeaderSection: View {
    let recipientName: String
    let occasion: String
    let theme: String?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)

            Text("Your Message is Ready!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            // Message details
            HStack(spacing: 8) {
                Text("For")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(recipientName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text("•")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(occasion)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if let theme = theme {
                    Text("•")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(theme)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.top, 20)
    }
}
