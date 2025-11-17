//
//  RatingManager.swift
//  WishKit
//
//  Created by diayan siat on 14/11/2025.
//

import Foundation
import StoreKit
import UIKit

/// Manages App Store rating requests at optimal moments
class RatingManager {
    static let shared = RatingManager()

    // MARK: - Constants

    private let minimumGenerationsBeforeAsk = 3
    private let daysBetweenRequests = 60 // Don't ask more than once every 60 days

    // MARK: - UserDefaults Keys

    private let successfulGenerationsKey = "successfulGenerationsCount"
    private let lastRatingRequestDateKey = "lastRatingRequestDate"

    private init() {}

    // MARK: - Public Methods

    /// Call this after a successful message generation
    func messageGeneratedSuccessfully() {
        // Increment successful generations count
        let currentCount = UserDefaults.standard.integer(forKey: successfulGenerationsKey)
        let newCount = currentCount + 1
        UserDefaults.standard.set(newCount, forKey: successfulGenerationsKey)

        print("✅ Message generated! Total successful generations: \(newCount)")

        // Check if we should request review
        if shouldRequestReview(generationCount: newCount) {
            requestReview()
        }
    }

    // MARK: - Private Methods

    /// Determine if we should request a review
    private func shouldRequestReview(generationCount: Int) -> Bool {
        // Need at least minimum number of successful generations
        guard generationCount >= minimumGenerationsBeforeAsk else {
            print("⏳ Not enough generations yet (\(generationCount)/\(minimumGenerationsBeforeAsk))")
            return false
        }

        // Check if we've asked recently
        if let lastRequestDate = UserDefaults.standard.object(forKey: lastRatingRequestDateKey) as? Date {
            let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequestDate, to: Date()).day ?? 0

            if daysSinceLastRequest < daysBetweenRequests {
                print("⏸️ Asked for review too recently (\(daysSinceLastRequest) days ago)")
                return false
            }
        }

        // Ask at strategic intervals (3, 10, 25, 50, 100...)
        let shouldAsk = generationCount == minimumGenerationsBeforeAsk ||
                       generationCount == 10 ||
                       generationCount == 25 ||
                       generationCount == 50 ||
                       generationCount % 100 == 0

        if shouldAsk {
            print("⭐️ Perfect time to request review! (Generation #\(generationCount))")
        }

        return shouldAsk
    }

    /// Request App Store review
    private func requestReview() {
        // Update last request date
        UserDefaults.standard.set(Date(), forKey: lastRatingRequestDateKey)

        // Request review from the current window scene
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if #available(iOS 18.0, *) {
                    AppStore.requestReview(in: windowScene)
                    print("⭐️ Review prompt shown to user using AppStore.requestReview")
                } else {
                    SKStoreReviewController.requestReview(in: windowScene)
                    print("⭐️ Review prompt shown to user using SKStoreReviewController")
                }
            }
        }
    }

    // MARK: - Reset (for testing)

    /// Reset all tracking (useful for testing)
    func resetTracking() {
        UserDefaults.standard.removeObject(forKey: successfulGenerationsKey)
        UserDefaults.standard.removeObject(forKey: lastRatingRequestDateKey)
        print("🔄 Rating tracking reset")
    }
}

