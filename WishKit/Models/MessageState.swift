//
//  MessageState.swift
//  WishKit
//
//  Created by diayan siat on 04/11/2025.
//

import Foundation

@Observable
class MessageState {
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

    // MARK: - Computed Properties

    var canContinueToTheme: Bool {
        !recipientName.isEmpty &&
        selectedOccasion != nil &&
        selectedRelationship != nil
    }

    var canGenerateMessage: Bool {
        selectedTheme != nil &&
        messageLength != nil &&
        !themeName.isEmpty
    }

    // MARK: - Actions

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
