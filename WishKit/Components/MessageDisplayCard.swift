//
//  MessageDisplayCard.swift
//  WishKit
//
//  Created by diayan siat on 03/11/2025.
//

import SwiftUI

struct MessageDisplayCard: View {
    let messageText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your Message")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            ScrollView(.vertical, showsIndicators: false) {
                Text(messageText)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 300)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
        .cardStyle()
    }
}
