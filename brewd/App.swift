//
//  App.swift
//  brewd
//
//  Created by mxa on 31.10.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Foundation

internal struct App {
    private init() {}
    
    static func run() {
        #if DEBUG
            let runInterval: UInt32 =   10 // seconds
        #else
            let runInterval: UInt32 = 3600 // seconds
        #endif
        
        // Stuff
        let logFile = LogFile(path: "~/brewd.log", executableName: "brewd")
        let notificationManager = NotificationManager(logFile: logFile)
        
        // Update task
        let brewRunner = BrewRunner(logFile: logFile, notificationManager: notificationManager)
        let daemonTask: Closure = {
            brewRunner.update()
        }
        
        // Run as daemon
        let deamon = Daemon(runInterval: runInterval, task: daemonTask, logFile: logFile)
        deamon.start()
    }
}

