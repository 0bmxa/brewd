//
//  BrewManager.swift
//  brewd
//
//  Created by Maximilian Heim on 07.01.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Foundation

enum BrewCommand: String {
    case List     = "list"
    case Outdated = "outdated"

    case Update   = "update"
}


enum BrewError: ErrorType {
    case Error
}


@objc class BrewManager: NSObject {
    
//    override init() {
//        // Update
//        if !self.update()
//        {
//            NotificationManager.show("Update failed.")
//            return
//        }
//
//        let outdatedCount = outdatedPackages()?.count
//        if (outdatedCount > 0) {
//            NotificationManager.show("Update successful. There are \(outdatedCount!) outdated packages.")
//        } else {
//            NotificationManager.show("Update successful.")
//        }
//    }
    
    func update() {
        let brew = Brew()
        let updateSuccess = brew.update()
        if !updateSuccess {
            Notification.show("Update failed.")
        }

        guard let outdatedPackagesCount = brew.outdatedPackages()?.count
            else {
                Notification.show("Could not get outdated packages.");
                return
            }
        if (outdatedPackagesCount > 0) {
            Notification.show("There are \(outdatedPackagesCount) outdated packages.")
        }
    }
    
    
//    func installedPackages() -> [String]?
//    {
//        if let list = brew(.List) {
//            let installedPackages: [String] = list.componentsSeparatedByString("\n").filter({$0 != ""})
//            return installedPackages
//        }
//        return nil
//    }
    
    
//    func outdatedPackages() -> [String]? {
//        let outdated = brew(.Outdated)
//        if (outdated.success) {
//            let outdatedPackages = outdated.content?.componentsSeparatedByString("\n").filter({$0 != ""})
//            return outdatedPackages
//        }
//        return nil
//    }
    
    
    
//    // MARK: - Execute brew commands
//    
//    func brew(command: BrewCommand) -> (success: Bool, content: String?) {
//        let result = Shell.executeSynchronous(brewPath, command.rawValue)
//
//        var success = true
//        if let stderr = result.stderr {
//            if(!stderr.isEmpty) {
//                success = false
//            }
//        }
//        
//        return (success, result.stdout)
//    }

    
    
//    // MARK: - Simple shell wrapper
//
//    func executeShellCommand(args: String...) -> (stdout: String?, stderr: String?) {
//        // Setup task
//        let task = NSTask.init()
//        task.launchPath = "/usr/bin/env"
//        task.arguments = args
//        
//        // Setup stdout
//        let stdout = NSPipe()
//        task.standardOutput = stdout
//        
//        // Setup stdout
//        let stderr = NSPipe()
//        task.standardError = stderr
//        
//        // Execute task
//        task.launch()
//        task.waitUntilExit()
//        
//        // Obtain stdout data string
//        let stdoutData   = stdout.fileHandleForReading.readDataToEndOfFile()
//        let stderrData   = stderr.fileHandleForReading.readDataToEndOfFile()
//        let stdoutString = String(data: stdoutData, encoding: NSUTF8StringEncoding)
//        let stderrString = String(data: stderrData, encoding: NSUTF8StringEncoding)
//
//        return (stdoutString, stderrString)
//    }
    
}



class Brew {
    
    let brewPath = "/usr/local/bin/brew"
    
    
    /**
     Calls `brew update`.
     
     - returns: Whether the update was successful or not.
     */
    func update() -> Bool {
        let update = brew(.Update)
        return update.success
    }
    
    
    /**
     Calls `brew list`.
     
     - returns: The list of installed packages, or nil if the call failed.
     */
    func installedPackages() -> [String]?
    {
        let list = brew(.List)
        guard let packages = list.content
            else { return nil }
        
        let installedPackages: [String] = packages.componentsSeparatedByString("\n").filter({$0 != ""})
        return installedPackages
    }
    
    
    /**
     Calls `brew outdated`.
     
     - returns: The list of outdated packages, or nil if the call failed.
     */
    func outdatedPackages() -> [String]? {
        let outdated = brew(.Outdated)
        guard let packages = outdated.content
            else { return nil }

        let outdatedPackages = packages.componentsSeparatedByString("\n").filter({$0 != ""})
        return outdatedPackages
    }


    
    // MARK: - Execute brew commands
    
    func brew(command: BrewCommand) -> (success: Bool, content: String?) {
        let result = Shell.executeSynchronous(brewPath, command.rawValue)
        
        var success = true
        if let stderr = result.stderr {
            if(!stderr.isEmpty) {
                success = false
            }
        }
        
        return (success, result.stdout)
    }

}

