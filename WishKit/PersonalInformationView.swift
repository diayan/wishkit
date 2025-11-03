//
//  PersonalInformationView.swift
//  WishKit
//
//  Created by diayan siat on 30/10/2025.
//

import SwiftUI

struct PersonalInformationView: View {
    @State private var recipientName: String = ""
    @State private var selectedOccasion: Occasion? = nil
    @State private var selectedRelationship: Relationship? = nil
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(title: "Create Your Message", currentStep: 0)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 40) {
                        RecipientNameSection(recipientName: $recipientName)
                            .padding(.top, 24)

                        OccasionSelectionSection(selectedOccasion: $selectedOccasion)

                        RelationshipSelectionSection(selectedRelationship: $selectedRelationship)

                        ContinueButton()
                            .padding(.top, 16)

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

// MARK: - Recipient Name Section

struct RecipientNameSection: View {
    @Binding var recipientName: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionTitle("To Whom?")

            TextField("", text: $recipientName)
                .placeholder(when: recipientName.isEmpty) {
                    Text("Recipient's Name")
                        .foregroundColor(.secondary)
                }
                .font(.body)
                .foregroundStyle(.primary)
                .padding(.horizontal, 24)
                .padding(.vertical, 18)
                .cardStyle()
        }
    }
}

// MARK: - Occasion Selection Section

struct OccasionSelectionSection: View {
    @Binding var selectedOccasion: Occasion?

    private let occasions: [(Occasion, String, String, Color)] = [
        (.birthday, "gift.fill", "Birthday", .blue),
        (.anniversary, "heart.fill", "Anniversary", .red),
        (.graduation, "graduationcap.fill", "Graduation", .blue),
        (.wedding, "figure.2.arms.open", "Wedding", .red),
        (.congrats, "sparkles", "Congrats", .yellow),
        (.getWell, "leaf.fill", "Get Well", .purple),
        (.newBaby, "figure.2.and.child.holdinghands", "New Baby", .green),
        (.justBecause, "face.smiling.fill", "Other", .black)
    ]

    var body: some View {
        SelectionGrid(
            title: "What's the Occasion?",
            items: occasions,
            selectedItem: $selectedOccasion
        ) { occasion, icon, label, color in
            SelectionButton(
                icon: icon,
                label: label,
                color: color,
                isSelected: selectedOccasion == occasion,
                action: { selectedOccasion = occasion }
            )
        }
    }
}

// MARK: - Relationship Selection Section

struct RelationshipSelectionSection: View {
    @Binding var selectedRelationship: Relationship?

    private let relationships: [(Relationship, String, String, Color)] = [
        (.friend, "figure.wave", "Friend", .blue),
        (.family, "house.fill", "Family", .orange),
        (.colleague, "briefcase.fill", "Colleague", .indigo),
        (.partner, "heart.circle.fill", "Partner", .pink),
        (.mentor, "person.crop.circle.badge.checkmark", "Mentor", .teal),
        (.acquaintance, "person.fill", "Acquaintance", .gray),
        (.other, "ellipsis.circle.fill", "Other", .gray)
    ]

    var body: some View {
        SelectionGrid(
            title: "What is your relationship",
            items: relationships,
            selectedItem: $selectedRelationship
        ) { relationship, icon, label, color in
            SelectionButton(
                icon: icon,
                label: label,
                color: color,
                isSelected: selectedRelationship == relationship,
                action: { selectedRelationship = relationship }
            )
        }
    }
}

// MARK: - Continue Button

struct ContinueButton: View {
    var body: some View {
        NavigationLink(destination: MessageThemeView()) {
            HStack(spacing: 8) {
                Text("Continue")
                    .font(.headline)
                    .fontWeight(.semibold)

                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Capsule()
                    .fill(AppColors.primaryButtonGradient)
                    .shadow(color: Color.orange.opacity(0.3), radius: 16, x: 0, y: 6)
            )
        }
    }
}

#Preview {
    PersonalInformationView()
}
