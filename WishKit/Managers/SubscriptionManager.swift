//
//  SubscriptionManager.swift
//  Wishly
//
//  Created by diayan siat on 11/11/2025.
//

import Foundation
import RevenueCat

/// Manages subscription state and RevenueCat integration
@Observable
class SubscriptionManager: NSObject {
    static let shared = SubscriptionManager()

    // MARK: - Published State

    /// Whether the user has an active Wishly Pro subscription
    private(set) var isSubscribed: Bool = false

    /// Current customer info
    private(set) var customerInfo: CustomerInfo?

    /// Whether a purchase is in progress
    private(set) var isPurchasing: Bool = false

    /// Whether we're loading customer info
    private(set) var isLoading: Bool = true

    // MARK: - Constants

    private let entitlementID = "Wishly Pro"
    private let apiKey = "appl_vrwhbIYwIwedcZsMeyqMuQiXYQb"
    private let gracePeriodDays = 3
    private let firstInstallDateKey = "firstInstallDate"

    // MARK: - Initialization

    private override init() {
        super.init()
        trackFirstInstall()
        configure()
    }

    // MARK: - Configuration

    /// Configure RevenueCat SDK
    func configure() {
        // Configure RevenueCat
        Purchases.logLevel = .debug // Set to .info for production
        Purchases.configure(withAPIKey: apiKey)

        // Set up delegate
        Purchases.shared.delegate = self

        // Load initial customer info
        Task {
            await refreshCustomerInfo()
        }
    }

    // MARK: - Grace Period

    /// Track first install date if not already tracked
    private func trackFirstInstall() {
        if UserDefaults.standard.object(forKey: firstInstallDateKey) == nil {
            UserDefaults.standard.set(Date(), forKey: firstInstallDateKey)
            print("📅 First install tracked: \(Date())")
        }
    }

    /// Check if user is within the grace period
    var isWithinGracePeriod: Bool {
        guard let firstInstallDate = UserDefaults.standard.object(forKey: firstInstallDateKey) as? Date else {
            return false
        }

        let daysSinceInstall = Calendar.current.dateComponents([.day], from: firstInstallDate, to: Date()).day ?? 0
        let withinGracePeriod = daysSinceInstall < gracePeriodDays

        print("📊 Days since install: \(daysSinceInstall)/\(gracePeriodDays) - Grace period active: \(withinGracePeriod)")
        return withinGracePeriod
    }

    /// Check if user has access to premium features (subscribed OR within grace period)
    var hasAccess: Bool {
        let access = isSubscribed || isWithinGracePeriod
        print("🔓 Access granted: \(access) (Subscribed: \(isSubscribed), Grace: \(isWithinGracePeriod))")
        return access
    }

    /// Get remaining days in trial period (0 if expired or subscribed)
    var daysRemainingInTrial: Int {
        guard !isSubscribed else { return 0 }
        guard let firstInstallDate = UserDefaults.standard.object(forKey: firstInstallDateKey) as? Date else {
            return 0
        }

        let daysSinceInstall = Calendar.current.dateComponents([.day], from: firstInstallDate, to: Date()).day ?? 0
        let remaining = max(0, gracePeriodDays - daysSinceInstall)
        return remaining
    }

    // MARK: - Customer Info

    /// Refresh customer info from RevenueCat
    @MainActor
    func refreshCustomerInfo() async {
        isLoading = true

        do {
            let info = try await Purchases.shared.customerInfo()
            customerInfo = info
            isSubscribed = info.entitlements[entitlementID]?.isActive == true
            isLoading = false
            print("✅ Customer info refreshed - Subscribed: \(isSubscribed)")
        } catch {
            print("❌ Failed to fetch customer info: \(error.localizedDescription)")
            isLoading = false
        }
    }

    // MARK: - Purchases

    /// Purchase a package
    @MainActor
    func purchase(package: Package) async throws -> CustomerInfo {
        isPurchasing = true

        do {
            let result = try await Purchases.shared.purchase(package: package)
            customerInfo = result.customerInfo
            isSubscribed = result.customerInfo.entitlements[entitlementID]?.isActive == true
            isPurchasing = false
            print("✅ Purchase successful - Subscribed: \(isSubscribed)")
            return result.customerInfo
        } catch {
            isPurchasing = false
            print("❌ Purchase failed: \(error.localizedDescription)")
            throw error
        }
    }

    /// Restore purchases
    @MainActor
    func restorePurchases() async throws -> CustomerInfo {
        isPurchasing = true

        do {
            let info = try await Purchases.shared.restorePurchases()
            customerInfo = info
            isSubscribed = info.entitlements[entitlementID]?.isActive == true
            isPurchasing = false

            print("✅ Restore successful - Subscribed: \(isSubscribed)")
            return info
        } catch {
            isPurchasing = false
            print("❌ Restore failed: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Offerings

    /// Fetch current offerings
    func getOfferings() async throws -> Offerings {
        do {
            let offerings = try await Purchases.shared.offerings()
            return offerings
        } catch {
            print("❌ Failed to fetch offerings: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Entitlement Checking

    /// Check if user has Wishly Pro entitlement
    var hasProAccess: Bool {
        return isSubscribed
    }
}

// MARK: - PurchasesDelegate

extension SubscriptionManager: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.customerInfo = customerInfo
            self.isSubscribed = customerInfo.entitlements[entitlementID]?.isActive == true
            print("📱 Customer info updated - Subscribed: \(isSubscribed)")
        }
    }
}
