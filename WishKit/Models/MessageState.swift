//
//  MessageState.swift
//  WishKit
//
//  Created by diayan siat on 04/11/2025.
//

import Foundation

@Observable
class MessageState {
    // MARK: - Services
    private let openAIService: OpenAIService

    // MARK: - Personal Information
    var recipientName: String = ""
    var selectedOccasion: Occasion? = nil
    var selectedRelationship: Relationship? = nil

    // MARK: - Theme & Preferences
    var selectedTheme: Theme? = nil
    var themeName: String = ""
    var messageLength: MessageLength? = nil
    var includeEmojis: Bool = false
    var customNotes: String = ""

    // MARK: - Generated Message
    var generatedMessage: String = ""
    var isGenerating: Bool = false
    var generationError: String? = nil

    // MARK: - Initialization

    init(apiKey: String = "YOUR_API_KEY_HERE") {
        self.openAIService = OpenAIService(apiKey: apiKey)
    }

    // MARK: - Computed Properties

    var canContinueToTheme: Bool {
        !recipientName.isEmpty &&
        selectedOccasion != nil &&
        selectedRelationship != nil
    }

    var canGenerateMessage: Bool {
        selectedTheme != nil &&
        messageLength != nil &&
        !themeName.isEmpty &&
        !isGenerating
    }

    // MARK: - Actions

    func generateMessage() async {
        guard canGenerateMessage,
              let occasion = selectedOccasion,
              let messageLength = messageLength else {
            return
        }

        isGenerating = true
        generationError = nil

        do {
            let message = try await openAIService.generateMessage(
                recipientName: recipientName,
                occasion: occasion,
                relationship: selectedRelationship,
                theme: themeName,
                messageLength: messageLength,
                includeEmojis: includeEmojis,
                customNotes: customNotes.isEmpty ? nil : customNotes
            )

            generatedMessage = message
            isGenerating = false
        } catch {
            isGenerating = false
            generationError = error.localizedDescription
        }
    }

    func clearError() {
        generationError = nil
    }

    func reset() {
        recipientName = ""
        selectedOccasion = nil
        selectedRelationship = nil
        selectedTheme = nil
        themeName = ""
        messageLength = nil
        includeEmojis = false
        customNotes = ""
        generatedMessage = ""
        isGenerating = false
        generationError = nil
    }

    func resetThemeSelection() {
        selectedTheme = nil
        themeName = ""
        messageLength = nil
        includeEmojis = false
        customNotes = ""
    }
}
