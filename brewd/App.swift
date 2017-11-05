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
            let runInterval: UInt32 = 10
        #else
            let runInterval: UInt32 = 3600
        #endif
        
        let logFile = LogFile(path: "~/brewd.log", executableName: "brewd")
        
        let brew = BrewManager(logFile: logFile)
        let daemonTask: Closure = {
            brew.update()
        }
        let deamon = Daemon(runInterval: runInterval, task: daemonTask, logFile: logFile)
        deamon.start()
    }
}

