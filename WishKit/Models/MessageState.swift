//
//  MessageState.swift
//  WishKit
//
//  Created by diayan siat on 04/11/2025.
//

import Foundation
import SwiftData

@Observable
class MessageState {
    // MARK: - Services
    private let openAIService: OpenAIService
    private var modelContext: ModelContext?

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

    init(apiKey: String = Config.openAIApiKey) {
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

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    func generateMessage() async {
        guard canGenerateMessage,
              let occasion = selectedOccasion,
              let themeType = selectedTheme,
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
                themeType: themeType,
                theme: themeName,
                messageLength: messageLength,
                includeEmojis: includeEmojis,
                customNotes: customNotes.isEmpty ? nil : customNotes
            )

            generatedMessage = message
            isGenerating = false

            // Track message generation
            let count = UserDefaults.standard.integer(forKey: "totalMessagesGenerated")
            UserDefaults.standard.set(count + 1, forKey: "totalMessagesGenerated")

            // Notify engagement manager
            NotificationManager.shared.userGeneratedMessage()

            // Automatically save the generated message
            saveMessage(message, occasion: occasion)
        } catch {
            isGenerating = false
            generationError = error.localizedDescription
        }
    }

    private func saveMessage(_ message: String, occasion: Occasion) {
        guard let context = modelContext else { return }

        let savedMessage = SavedMessage(
            recipientName: recipientName,
            occasion: occasion,
            theme: themeName.isEmpty ? nil : themeName,
            messageText: message,
            date: Date(),
            isFavorite: false
        )

        context.insert(savedMessage)

        do {
            try context.save()
        } catch {
            print("Failed to save message: \(error.localizedDescription)")
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
