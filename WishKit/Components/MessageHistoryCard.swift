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
        case .christmas: return "tree.fill"
        case .newYear: return "party.popper.fill"
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
                            .font(.callout)
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
                    .font(.largeTitle)
                    .fontWeight(.bold)
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
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        )
                }
            }
            .modifier(CardPaddingModifier())
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

// MARK: - Card Padding Modifier

struct CardPaddingModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            // iOS 26+: Apply card style first, then padding
            content
                .cardStyle()
                .padding(28)
        } else {
            // iOS 25 and below: Apply padding first, then card style
            content
                .padding(28)
                .cardStyle()
        }
    }
}
