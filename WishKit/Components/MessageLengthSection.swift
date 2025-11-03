//
//  MessageLengthSection.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct MessageLengthSection: View {
    @Binding var selectedLength: MessageLength?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle("Message Length")

            HStack(spacing: 12) {
                LengthButton(
                    label: "Short",
                    isSelected: selectedLength == .short,
                    action: { selectedLength = .short }
                )

                LengthButton(
                    label: "Medium",
                    isSelected: selectedLength == .medium,
                    action: { selectedLength = .medium }
                )

                LengthButton(
                    label: "Long",
                    isSelected: selectedLength == .long,
                    action: { selectedLength = .long }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .cardStyle()
    }
}
