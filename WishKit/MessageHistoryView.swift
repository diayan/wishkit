//
//  MessageHistoryView.swift
//  WishKit
//
//  Created by diayan siat on 01/11/2025.
//

import SwiftUI
import SwiftData

struct MessageHistoryView: View {
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) private var colorScheme
    @State private var isAnimated: Bool = false

    @Query(sort: \SavedMessage.date, order: .reverse) private var messages: [SavedMessage]

    var body: some View {
        ZStack {
            AppColors.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Title
                Text("History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : -20)

                // Message Cards or Empty State
                if messages.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()

                        Image(systemName: "tray.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary.opacity(0.5))

                        Text("No Messages Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Text("Generate your first message to see it here!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 48)

                        Button(action: {
                            selectedTab = 0
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 18, weight: .semibold))

                                Text("Create Your Message")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 18)
                            .background(
                                Capsule()
                                    .fill(AppColors.primaryButtonGradient)
                                    .shadow(color: Color.orange.opacity(0.3), radius: 16, x: 0, y: 6)
                            )
                        }
                        .buttonPressAnimation()
                        .padding(.top, 16)

                        Spacer()
                    }
                    .opacity(isAnimated ? 1 : 0)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack() {
                            ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                                MessageHistoryCard(message: message)
                                    .rotation3DEffect(
                                        .degrees(index % 2 == 0 ? 3 : -3),
                                        axis: (x: 0, y: 0, z: 1)
                                    )
                                    .offset(x: index % 2 == 0 ? -8 : 8)
                                    .zIndex(Double(messages.count - index))
                                    .opacity(isAnimated ? 1 : 0)
                                    .offset(y: isAnimated ? 0 : 50)
                            }

                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    MessageHistoryView(selectedTab: .constant(1))
        .modelContainer(for: SavedMessage.self, inMemory: true)
}
