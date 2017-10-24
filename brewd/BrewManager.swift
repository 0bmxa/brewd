//
//  BrewManager.swift
//  brewd
//
//  Created by Maximilian Heim on 07.01.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Foundation

enum BrewCommand: String {
    case list
    case outdated

    case update
}


@objc class BrewManager: NSObject {
    let logFile: LogFile
    let notificationManager: NotificationManager

    override init() {
        let logFile = LogFile(path: "~/brewd.log", executableName: "brewd")
        self.logFile = logFile
        self.notificationManager = NotificationManager(logFile: logFile)
    }

    func update() {
        self.logFile.log("Starting update...")

        let brew = Brew()

        self.logFile.log("Updating...")
        let updateSuccess = brew.update()
        self.logFile.log("Update finished.")

        if !updateSuccess {
            self.notificationManager.show(message: "Update failed.")
        }

        let outdatedPackages = brew.outdatedPackages()
        if !outdatedPackages.isEmpty {
            self.notificationManager.show(message: "There are \(outdatedPackages.count) outdated packages.")
        }
    }
}
