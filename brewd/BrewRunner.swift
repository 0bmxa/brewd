//
//  BrewManager.swift
//  brewd
//
//  Created by Maximilian Heim on 07.01.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Foundation

struct BrewRunner {
    let logFile: LogFile?
    let notificationManager: NotificationManager
    let brewExecutablePath: String

    func updateAndNotify() {
        self.logFile?.log("Starting update...", level: .debug)
        let brew = Brew(executablePath: self.brewExecutablePath)

        // Run update
        self.logFile?.log("Updating...", level: .debug)
        let updateSuccess = brew.update()

        // Log success/failure
        if !updateSuccess {
            self.logFile?.log("Update failed.", level: .info)
            self.notificationManager.show(message: "Update failed.")
        } else {
            self.logFile?.log("Update succeeded.", level: .info)
        }

        // Outdated packages
        let outdatedPackages = brew.outdatedPackages()
        if !outdatedPackages.isEmpty {
            self.logFile?.log(outdatedPackages.count, "outdated packages.", level: .info)
            self.notificationManager.show(message: "There are \(outdatedPackages.count) outdated packages.")
        }
    }
}
