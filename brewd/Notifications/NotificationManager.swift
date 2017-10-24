//
//  NotificationManager.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Cocoa

class NotificationManager: NSObject {
    let notificationCenter: NSUserNotificationCenter
    let logFile: LogFile

    init(logFile: LogFile) {
        self.logFile = logFile
        self.notificationCenter = NSUserNotificationCenter.default
        super.init()
        self.notificationCenter.delegate = self
    }

    func show(message: String) {
        let notification = NSUserNotification()
        notification.title = "HomeBrew"
        notification.informativeText = message
        notification.hasActionButton = true
        notification.actionButtonTitle = "Oh noes!"
        notification.otherButtonTitle = "Close"

        // Caution: Private API
        let beer = BeerImage(size: NSSize(width: 30, height: 30))
        notification.setValue(beer, forKey: "_identityImage")
        notification.setValue(false, forKey: "_identityImageHasBorder")

        self.notificationCenter.deliver(notification)
        self.logFile.log("Displaying notification: ", message)
    }
}

extension NotificationManager: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        self.logFile.log("Notification", notification.title ?? "[no title]", "delivered.")
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        self.logFile.log("Notification", notification.title ?? "[no title]", "activated.")
    }
}
