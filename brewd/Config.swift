//
//  Config.swift
//  brewd
//
//  Created by mxa on 05.11.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Foundation

struct Config {
    
    /// Path to the main HomeBrew executable.
    let brewExecutablePath: String
    
    /// Brew update interval (seconds).
    let updateInterval: UInt32
    
    /// Path where a log file should be written.
    /// If nil, no log is being written.
    let logFilePath: String?
    
    
    /// Default config.
    static let `default` = Config(
        brewExecutablePath: "/usr/local/bin/brew",
        updateInterval: 3600,
        logFilePath: "~/brewd.log"
    )
}
