//
//  EmojiToggleSection.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct EmojiToggleSection: View {
    @Binding var includeEmojis: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                SectionTitle("Include Emojis")

                Spacer()

                Toggle("", isOn: $includeEmojis)
                    .labelsHidden()
                    .tint(Color(red: 1.0, green: 0.3, blue: 0.2))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .cardStyle()
    }
}
