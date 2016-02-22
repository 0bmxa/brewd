//
//  AppManager.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Foundation

class AppManager {

    init() {
        let daemonManager = DaemonManager()
        daemonManager.startDaemon()
    }
    
}
