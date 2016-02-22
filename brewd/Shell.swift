//
//  Shell.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Cocoa

// MARK: - Simple shell wrapper
class Shell {

    /**
     Executes a shell command synchronously.
     
     - parameter args: The arguments of the command to be executed, including the command itself.
     
     - returns: The returned stdout and stderr strings, if applicable.
     */
    class func executeSynchronous(args: String...) -> (stdout: String?, stderr: String?) {
        // Setup task
        let task = NSTask.init()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        
        // Setup stdout
        let stdout = NSPipe()
        task.standardOutput = stdout
        
        // Setup stdout
        let stderr = NSPipe()
        task.standardError = stderr
        
        // Execute task
        task.launch()
        task.waitUntilExit()
        
        // Obtain stdout data string
        let stdoutData   = stdout.fileHandleForReading.readDataToEndOfFile()
        let stderrData   = stderr.fileHandleForReading.readDataToEndOfFile()
        let stdoutString = String(data: stdoutData, encoding: NSUTF8StringEncoding)
        let stderrString = String(data: stderrData, encoding: NSUTF8StringEncoding)
        
        return (stdoutString, stderrString)
    }

    
}
