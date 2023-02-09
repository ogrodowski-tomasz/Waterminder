//
//  NotificationService.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 08/02/2023.
//

import CoreData
import Foundation
import UserNotifications

protocol AnyUserNotificationsService {
    func scheduleNotification(id: NSManagedObjectID, title: String, triggerDate: Date)
    func removeNotification(id: NSManagedObjectID)
    func updateNotification(id: NSManagedObjectID, newTitle: String, newTriggerDate: Date)
}

struct UserNotificationsService: AnyUserNotificationsService {

    init() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
            }
        }
    }

    func scheduleNotification(id: NSManagedObjectID, title: String, triggerDate: Date) {
        let content = UNMutableNotificationContent()
        let localizedStringNotificationTitle = NSLocalizedString("%@ is thirsty!", comment: "Notification title")
        let finalTitle = String(format: localizedStringNotificationTitle, title)

        content.title = finalTitle
        content.body = NSLocalizedString("Your plant is thirsty! Give him some water...", comment: "Notification body")
        content.sound = UNNotificationSound.default

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let stringId = id.toString

        let request = UNNotificationRequest(identifier: stringId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func removeNotification(id: NSManagedObjectID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.toString])
    }

    func updateNotification(id: NSManagedObjectID, newTitle: String, newTriggerDate: Date) {
        removeNotification(id: id)
        scheduleNotification(id: id, title: newTitle, triggerDate: newTriggerDate)
    }
}
