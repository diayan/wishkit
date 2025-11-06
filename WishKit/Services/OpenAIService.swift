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
        theme: String,
        messageLength: MessageLength,
        includeEmojis: Bool,
        customNotes: String?
    ) async throws -> String {
        // Build the prompt
        let prompt = buildPrompt(
            recipientName: recipientName,
            occasion: occasion,
            relationship: relationship,
            theme: theme,
            messageLength: messageLength,
            includeEmojis: includeEmojis,
            customNotes: customNotes
        )

        // Create the request
        let request = OpenAIRequest(
            model: "gpt-3.5-turbo",
            messages: [
                OpenAIRequest.Message(
                    role: "system",
                    content: "You are a creative and empathetic message writer who crafts personalized, heartfelt messages for various occasions. Your messages are genuine, warm, and tailored to the recipient's interests."
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
        theme: String,
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
        prompt += "The message should be inspired by or reference: \(theme)\n"

        if includeEmojis {
            prompt += "Include relevant emojis to make it more expressive.\n"
        } else {
            prompt += "Do not use any emojis.\n"
        }

        if let notes = customNotes, !notes.isEmpty {
            prompt += "Additional context: \(notes)\n"
        }

        prompt += """
        \n
        Requirements:
        - Make it personal and heartfelt
        - Reference the theme naturally and creatively
        - Keep the tone appropriate for a \(occasion.displayName.lowercased()) message
        - Make it feel genuine and sincere
        - Don't be overly formal unless it's appropriate for the occasion

        Write only the message itself, without any preamble or explanation.
        """

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
