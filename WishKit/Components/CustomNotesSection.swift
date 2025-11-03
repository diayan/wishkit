//
//  CustomNotesSection.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import SwiftUI

struct CustomNotesSection: View {
    @Binding var customNotes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionTitle("Custom Notes")

            ZStack(alignment: .topLeading) {
                if customNotes.isEmpty {
                    Text("Add any additional details you'd like to include...")
                        .foregroundColor(.secondary)
                        .font(.body)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 18)
                }

                TextEditor(text: $customNotes)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
            }
            .cardStyle()
        }
    }
}
