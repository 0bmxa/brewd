//
//  NotificationManager.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Foundation

class NotificationManager: NSObject {
    let notificationCenter = NSUserNotificationCenter.default
    let logFile: LogFile?

    init(logFile: LogFile?) {
        self.logFile = logFile
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
        self.logFile?.log("Displaying notification: ", message)
    }
}


// MARK: - NSUserNotificationCenterDelegate
extension NotificationManager: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        self.logFile?.log("Notification delivered:", notification.informativeText ?? "[no message]")
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        self.logFile?.log("Notification activated:", notification.informativeText ?? "[no message]")
    }
}
