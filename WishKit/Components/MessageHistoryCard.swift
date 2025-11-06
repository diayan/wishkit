//
//  MessageHistoryCard.swift
//  WishKit
//
//  Created by diayan siat on 03/11/2025.
//

import SwiftUI

struct MessageHistoryCard: View {
    let message: SavedMessage
    @Environment(\.colorScheme) private var colorScheme
    @State private var showMessageDetail: Bool = false

    var occasionIcon: String {
        switch message.occasion {
        case .birthday: return "gift.fill"
        case .anniversary: return "heart.fill"
        case .graduation: return "graduationcap.fill"
        case .wedding: return "figure.2.arms.open"
        case .congrats: return "sparkles"
        case .getWell: return "leaf.fill"
        case .newBaby: return "figure.2.and.child.holdinghands"
        case .justBecause: return "face.smiling.fill"
        }
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }

    var body: some View {
        Button(action: {
            showMessageDetail = true
        }) {
            VStack(alignment: .leading, spacing: 16) {
                // Header with occasion, theme, and favorite
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: occasionIcon)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)

                        Text(message.occasion.displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let theme = message.theme {
                            Text("•")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text(theme)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }

                    Spacer()
                }

                // Recipient Name
                Text(message.recipientName)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)

                // Divider
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 1)

                // Message Preview
                Text(message.messageText)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                // Footer with date and arrow
                HStack {
                    Text(dateFormatter.string(from: message.date))
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Circle()
                        .fill(Color.red)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(28)
            .cardStyle()
        }
        .cardTapAnimation()
        .sheet(isPresented: $showMessageDetail) {
            GeneratedMessageView(
                recipientName: message.recipientName,
                occasion: message.occasion.displayName,
                theme: message.theme,
                messageText: message.messageText
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(28)
        }
    }
}
