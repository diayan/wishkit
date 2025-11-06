//
//  MessageModels.swift
//  WishKit
//
//  Created by diayan siat on 02/11/2025.
//

import Foundation
import SwiftData

// MARK: - Occasion Enum

enum Occasion: String, Codable {
    case birthday
    case anniversary
    case graduation
    case congrats
    case getWell
    case justBecause
    case wedding
    case newBaby

    var displayName: String {
        switch self {
        case .birthday: return "Birthday"
        case .anniversary: return "Anniversary"
        case .graduation: return "Graduation"
        case .congrats: return "Congrats"
        case .getWell: return "Get Well"
        case .justBecause: return "Just Because"
        case .wedding: return "Wedding"
        case .newBaby: return "New Baby"
        }
    }
}

// MARK: - Relationship Enum

enum Relationship: String, Codable {
    case friend
    case family
    case colleague
    case partner
    case mentor
    case acquaintance
    case other
}

// MARK: - Theme Enum

enum Theme: Equatable {
    case movie
    case musician
    case tvCharacter
    case book
    case show
    case superhero
    case custom

    var promptText: String {
        switch self {
        case .movie: return "What's the movie?"
        case .musician: return "Who's the musician?"
        case .tvCharacter: return "Who's the character?"
        case .book: return "What's the book?"
        case .show: return "What's the show?"
        case .superhero: return "Who's the superhero?"
        case .custom: return "What's the inspiration?"
        }
    }

    var placeholderText: String {
        switch self {
        case .movie: return "Enter the name of the movie"
        case .musician: return "Enter the name of the musician"
        case .tvCharacter: return "Enter the character name"
        case .book: return "Enter the name of the book"
        case .show: return "Enter the name of the show"
        case .superhero: return "Enter the superhero name"
        case .custom: return "Enter your custom inspiration"
        }
    }
}

// MARK: - Message Length Enum

enum MessageLength: Equatable {
    case short
    case medium
    case long
}

// MARK: - Saved Message Model

@Model
class SavedMessage {
    @Attribute(.unique) var id: UUID
    var recipientName: String
    var occasion: Occasion
    var theme: String?  // e.g., "The Godfather", "Taylor Swift", etc.
    var messageText: String
    var date: Date
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        recipientName: String,
        occasion: Occasion,
        theme: String? = nil,
        messageText: String,
        date: Date = Date(),
        isFavorite: Bool = false
    ) {
        self.id = id
        self.recipientName = recipientName
        self.occasion = occasion
        self.theme = theme
        self.messageText = messageText
        self.date = date
        self.isFavorite = isFavorite
    }
}
