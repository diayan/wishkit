//
//  OpenAIService.swift
//  WishKit
//
//  Created by diayan siat on 04/11/2025.
//

import Foundation

// MARK: - OpenAI Models

struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
    let maxTokens: Int?

    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxTokens = "max_tokens"
    }

    struct Message: Codable {
        let role: String
        let content: String
    }
}

struct OpenAIResponse: Codable {
    let id: String
    let choices: [Choice]

    struct Choice: Codable {
        let message: Message

        struct Message: Codable {
            let content: String
        }
    }
}

struct OpenAIError: Codable {
    let error: ErrorDetail

    struct ErrorDetail: Codable {
        let message: String
        let type: String
    }
}

// MARK: - OpenAI Service

class OpenAIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func generateMessage(
        recipientName: String,
        occasion: Occasion,
        relationship: Relationship?,
        themeType: Theme?,
        theme: String?,
        messageLength: MessageLength,
        includeEmojis: Bool,
        customNotes: String?
    ) async throws -> String {
        // Build the prompt
        let prompt = buildPrompt(
            recipientName: recipientName,
            occasion: occasion,
            relationship: relationship,
            themeType: themeType,
            theme: theme,
            messageLength: messageLength,
            includeEmojis: includeEmojis,
            customNotes: customNotes
        )

        // Create the request
        let request = OpenAIRequest(
            model: "gpt-4o-mini",
            messages: [
                OpenAIRequest.Message(
                    role: "system",
                    content: "You are a creative message writer who crafts personalized, heartfelt messages for special occasions. When a theme is provided, capture its spirit creatively while creating original content. When no theme is given, write genuine, sincere messages from the heart. Avoid direct quotes or copying copyrighted dialogue verbatim."
                ),
                OpenAIRequest.Message(
                    role: "user",
                    content: prompt
                )
            ],
            temperature: 0.8,
            maxTokens: getMaxTokens(for: messageLength)
        )

        // Make the API call
        return try await callOpenAI(request: request)
    }

    // MARK: - Private Methods

    private func buildPrompt(
        recipientName: String,
        occasion: Occasion,
        relationship: Relationship?,
        themeType: Theme?,
        theme: String?,
        messageLength: MessageLength,
        includeEmojis: Bool,
        customNotes: String?
    ) -> String {
        var prompt = """
        Write a \(messageLength.description) \(occasion.displayName.lowercased()) message for \(recipientName)
        """

        if let relationship = relationship {
            prompt += " who is my \(relationship.description.lowercased())"
        }

        prompt += ".\n\n"

        // Handle themed vs. classic messages
        if let themeType = themeType, let theme = theme {
            prompt += "The message should be inspired by \(theme) (a \(themeType.categoryDescription)). Capture the essence and feeling of this theme in the message.\n"
        } else {
            prompt += "Create a classic, heartfelt message that is genuine and personal.\n"
        }

        if includeEmojis {
            prompt += "Include relevant emojis to make it more expressive.\n"
        } else {
            prompt += "Do not use any emojis.\n"
        }

        if let notes = customNotes, !notes.isEmpty {
            prompt += "Additional context: \(notes)\n"
        }

        prompt += "\n\nRequirements:\n"
        prompt += "- Make it personal and heartfelt\n"

        if let theme = theme {
            prompt += "- Capture the essence and feeling of \(theme) in the message\n"
            prompt += "- Create original content - avoid direct quotes or copying dialogue verbatim\n"
            prompt += "- Reference the theme naturally and creatively\n"
        } else {
            prompt += "- Write a genuine, sincere message from the heart\n"
            prompt += "- Focus on the relationship and the occasion\n"
        }

        prompt += "- Keep the tone appropriate for a \(occasion.displayName.lowercased()) message\n"
        prompt += "- Make it feel genuine and sincere\n"
        prompt += "- Don't be overly formal unless it's appropriate for the occasion\n"
        prompt += "\nWrite only the message itself, without any preamble or explanation."

        return prompt
    }

    private func getMaxTokens(for length: MessageLength) -> Int {
        switch length {
        case .short: return 150
        case .medium: return 300
        case .long: return 500
        }
    }

    private func callOpenAI(request: OpenAIRequest) async throws -> String {
        guard let url = URL(string: baseURL) else {
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }

        if httpResponse.statusCode != 200 {
            // Try to parse error
            if let errorResponse = try? JSONDecoder().decode(OpenAIError.self, from: data) {
                throw NSError(domain: "OpenAIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.error.message])
            } else {
                throw NSError(domain: "OpenAIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed with status \(httpResponse.statusCode)"])
            }
        }

        let decoder = JSONDecoder()
        let openAIResponse = try decoder.decode(OpenAIResponse.self, from: data)

        guard let message = openAIResponse.choices.first?.message.content else {
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No message in response"])
        }

        return message.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Extensions for Display

extension MessageLength {
    var description: String {
        switch self {
        case .short: return "short"
        case .medium: return "medium-length"
        case .long: return "long"
        }
    }
}

extension Relationship {
    var description: String {
        switch self {
        case .friend: return "friend"
        case .family: return "family member"
        case .colleague: return "colleague"
        case .partner: return "partner"
        case .mentor: return "mentor"
        case .acquaintance: return "acquaintance"
        case .other: return "acquaintance"
        }
    }
}

extension Theme {
    var categoryDescription: String {
        switch self {
        case .movie: return "movie"
        case .musician: return "musician"
        case .tvCharacter: return "TV character"
        case .book: return "book"
        case .show: return "TV show"
        case .superhero: return "superhero"
        case .comic: return "comic"
        case .song: return "song"
        case .custom: return "inspiration"
        }
    }
}
