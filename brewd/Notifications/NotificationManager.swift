//
//  NotificationManager.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Cocoa

// MARK: - User notifications

class Notification {
    class func show(message: String)
    {
        NotificationManager.sharedManager.show(message)
    }
}

class NotificationManager: NSObject {

    static let sharedManager = NotificationManager()
    
    let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()

    override init() {
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
        notification.setValue(BeerImage(size: NSMakeSize(30, 30)), forKey: "_identityImage")
        notification.setValue(false, forKey: "_identityImageHasBorder")

        self.notificationCenter.deliverNotification(notification)
        LogFile.log("Displaying notification \"\(message)\".")
    }
    
}

extension NotificationManager: NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
        LogFile.log("Notification \"\(notification.title)\" delivered.")
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        LogFile.log("Notification \"\(notification.title)\" activated.")
    }
    
}
