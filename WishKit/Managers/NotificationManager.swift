//
//  NotificationManager.swift
//  WishKit
//
//  Created by diayan siat on 07/11/2025.
//

import UserNotifications
import UIKit
import Foundation

/// Manages local notifications for user engagement
class NotificationManager: NSObject {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    // MARK: - Notification Identifiers

    enum NotificationID: String {
        case returnReminder3Day = "return_reminder_3day"
        case returnReminder7Day = "return_reminder_7day"
        case weeklyReminder = "weekly_reminder"
        case holidayReminder = "holiday_reminder"
        case tipNotification = "tip_notification"
    }

    // MARK: - Initialization

    private override init() {
        super.init()
        center.delegate = self
    }

    // MARK: - Permission

    /// Request notification permission from user
    func requestPermission(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Notification permission granted")
                    self.scheduleInitialNotifications()
                } else {
                    print("❌ Notification permission denied")
                }
                completion(granted)
            }
        }
    }

    /// Check current authorization status
    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    // MARK: - Schedule Notifications

    /// Schedule all initial engagement notifications
    func scheduleInitialNotifications() {
        // Clear existing notifications first
        center.removeAllPendingNotificationRequests()

        // Schedule return reminders
        schedule3DayReminder()
        schedule7DayReminder()

        // Schedule holiday reminders
        scheduleUpcomingHolidayReminders()
    }

    /// Schedule notification after user inactivity (3 days)
    private func schedule3DayReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Ready to create another message? 🎉"
        content.body = "Someone's special day might be coming up!"
        content.sound = .default
        content.badge = 1

        // Trigger in 3 days at 10 AM
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3 * 24 * 60 * 60, repeats: false)

        let request = UNNotificationRequest(
            identifier: NotificationID.returnReminder3Day.rawValue,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Error scheduling 3-day reminder: \(error.localizedDescription)")
            } else {
                print("✅ Scheduled 3-day reminder")
            }
        }
    }

    /// Schedule notification after 7 days
    private func schedule7DayReminder() {
        let content = UNMutableNotificationContent()
        content.title = "We miss you! ✨"
        content.body = "Come back and create something special"
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7 * 24 * 60 * 60, repeats: false)

        let request = UNNotificationRequest(
            identifier: NotificationID.returnReminder7Day.rawValue,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Error scheduling 7-day reminder: \(error.localizedDescription)")
            } else {
                print("✅ Scheduled 7-day reminder")
            }
        }
    }

    /// Schedule reminders for upcoming holidays
    private func scheduleUpcomingHolidayReminders() {
        let holidays = getUpcomingHolidays()

        for holiday in holidays {
            scheduleHolidayReminder(holiday: holiday)
        }
    }

    /// Schedule a specific holiday reminder
    private func scheduleHolidayReminder(holiday: Holiday) {
        // Schedule 2 weeks before
        guard let reminderDate = Calendar.current.date(byAdding: .day, value: -14, to: holiday.date) else {
            return
        }

        // Only schedule if in the future
        guard reminderDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "\(holiday.emoji) \(holiday.name) is coming!"
        content.body = "Start creating your \(holiday.name.lowercased()) messages now"
        content.sound = .default
        content.badge = 1

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: "\(NotificationID.holidayReminder.rawValue)_\(holiday.name)",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Error scheduling \(holiday.name) reminder: \(error.localizedDescription)")
            } else {
                print("✅ Scheduled \(holiday.name) reminder for \(reminderDate)")
            }
        }
    }

    // MARK: - Engagement Tracking

    /// Call this when user generates a message
    func userGeneratedMessage() {
        // Update last active time
        UserDefaults.standard.set(Date(), forKey: "lastActiveDate")

        // Clear badge
        clearBadge()

        // Reschedule engagement notifications
        scheduleInitialNotifications()
    }

    /// Call this when user opens the app
    func userOpenedApp() {
        // Clear badge
        clearBadge()

        // Track app opens
        let appOpens = UserDefaults.standard.integer(forKey: "appOpenCount")
        UserDefaults.standard.set(appOpens + 1, forKey: "appOpenCount")
    }

    /// Clear app badge (iOS 17+ compatible)
    private func clearBadge() {
        if #available(iOS 17.0, *) {
            center.setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }

    // MARK: - Helpful Tips

    /// Schedule a helpful tip notification
    func scheduleTipNotification(after days: Int, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(days * 24 * 60 * 60), repeats: false)

        let request = UNNotificationRequest(
            identifier: "\(NotificationID.tipNotification.rawValue)_\(days)",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("❌ Error scheduling tip: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Holiday Data

    struct Holiday {
        let name: String
        let date: Date
        let emoji: String
    }

    /// Get upcoming holidays for the current year
    private func getUpcomingHolidays() -> [Holiday] {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)

        var holidays: [Holiday] = []

        // Christmas
        if let christmas = calendar.date(from: DateComponents(year: currentYear, month: 12, day: 25)),
           christmas > now {
            holidays.append(Holiday(name: "Christmas", date: christmas, emoji: "🎄"))
        }

        // New Year
        if let newYear = calendar.date(from: DateComponents(year: currentYear + 1, month: 1, day: 1)) {
            holidays.append(Holiday(name: "New Year", date: newYear, emoji: "🎊"))
        }

        // Valentine's Day
        if let valentines = calendar.date(from: DateComponents(year: currentYear, month: 2, day: 14)),
           valentines > now {
            holidays.append(Holiday(name: "Valentine's Day", date: valentines, emoji: "💝"))
        } else if let valentines = calendar.date(from: DateComponents(year: currentYear + 1, month: 2, day: 14)) {
            holidays.append(Holiday(name: "Valentine's Day", date: valentines, emoji: "💝"))
        }

        // Mother's Day (2nd Sunday of May - approximate)
        if let mothersDay = calendar.date(from: DateComponents(year: currentYear, month: 5, day: 10)),
           mothersDay > now {
            holidays.append(Holiday(name: "Mother's Day", date: mothersDay, emoji: "🌸"))
        }

        // Father's Day (3rd Sunday of June - approximate)
        if let fathersDay = calendar.date(from: DateComponents(year: currentYear, month: 6, day: 15)),
           fathersDay > now {
            holidays.append(Holiday(name: "Father's Day", date: fathersDay, emoji: "👔"))
        }

        // Halloween
        if let halloween = calendar.date(from: DateComponents(year: currentYear, month: 10, day: 31)),
           halloween > now {
            holidays.append(Holiday(name: "Halloween", date: halloween, emoji: "🎃"))
        }

        return holidays
    }

    // MARK: - Cancel Notifications

    /// Cancel all pending notifications
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
        print("✅ Cancelled all notifications")
    }

    /// Cancel specific notification
    func cancelNotification(_ id: NotificationID) {
        center.removePendingNotificationRequests(withIdentifiers: [id.rawValue])
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    /// Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is open
        completionHandler([.banner, .sound, .badge])
    }

    /// Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        print("📱 User tapped notification: \(identifier)")

        // Clear badge
        clearBadge()

        // Handle different notification types
        if identifier.contains("holiday") {
            // User tapped holiday reminder - could navigate to specific occasion
            print("Holiday reminder tapped")
        }

        completionHandler()
    }
}
