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
    
    static func run(config: Config = Config.default) {
        let runInterval: UInt32
        #if DEBUG
            runInterval =   10 // seconds
        #else
            runInterval = config.updateInterval // seconds
        #endif
        
        // Setup
        var logFile: LogFile?
        if let logFilePath = config.logFilePath {
            logFile = LogFile(path: logFilePath, executableName: "brewd")
        }
        let notificationManager = NotificationManager(logFile: logFile)
        let brewRunner = BrewRunner(logFile: logFile, notificationManager: notificationManager, brewExecutablePath: config.brewExecutablePath)
        
        // Create update task
        let daemonTask: Closure = {
            brewRunner.updateAndNotify()
        }
        
        // Run as daemon
        let deamon = Daemon(runInterval: runInterval, task: daemonTask, logFile: logFile)
        deamon.start()
    }
}

