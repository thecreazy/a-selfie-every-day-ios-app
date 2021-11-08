//
//  NotificationManager.swift
//  A Selfie Every Day
//
//  Created by canella riccardo on 07/11/21.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager() //singleton
    func requestAuth(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
            content.title = "New day new selfie!"
            content.subtitle = "from a selfie every day!"
            content.body = "Shot your selfie now!"
            content.sound = .default
            content.badge = 1
            
        var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = 18    // 18:00 hours
            dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
        print("Notification setted")
    }
}
