//
//  Daemonizer.swift
//  brewd
//
//  Created by mxa on 27.10.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Foundation
import Darwin.C.errno

typealias Closure = () -> Void

struct Daemon {
    private let runInterval: UInt32
    private let task: Closure
    private let logFile: LogFile?
    private var daemonShouldStop = false

    init(runInterval: UInt32, task: @escaping Closure, logFile: LogFile?) {
        self.runInterval = runInterval
        self.task = task
        self.logFile = logFile
    }

    func start() {
        #if DEBUG
            self.setup(fork: false)
        #else
            self.setup(fork: true)
        #endif

        // Run loop
        while true {
            guard !self.daemonShouldStop else { break }

            self.task()
            sleep(self.runInterval)
        }
        
        // Exit
        self.logFile?.log("Daemon stopped.")
        exit(EXIT_SUCCESS)
    }
    
    mutating func stop() {
        self.daemonShouldStop = true
    }
    
    private func setup(fork doFork: Bool) {
        // TODO: Use posixSpawn() instead ?
        let processID = doFork ? Forker.fork() : 0

        // Note:
        // Both (parent & child) processes continue running from here,
        // but have different processIDs
        
        // -1: Forking failed (and we are the parent, obviously)
        if processID < 0 {
            self.logFile?.log("Could not fork off parent.", level: .error)
            assertionFailure()
            exit(EXIT_FAILURE)
        }
        
        // >0: We are the parent process, and forking succeeded
        if processID > 0 {
            self.logFile?.log("Starting daemon.")
            exit(EXIT_SUCCESS)
        }
        
        // ELSE:
        // 0: We are the child process, and forking succeeded
        self.logFile?.log("Daemon running.")
        
        
        // Create a new session, so the child is not killed with the parent
        if doFork {
            let sessionID = setsid()
            
            guard sessionID >= 0 else {
                self.logFile?.log("Session creation failed.", level: .error)
                assertionFailure()
                exit(EXIT_FAILURE)
            }
            self.logFile?.log("Session created. ID:", sessionID)
        }
        
        
        // Remove file permissions (might break logfile access?)
//        umask(0)
        
        // Change working dir
        let path = "/".withCString { $0 }
        guard chdir(path) == 0 else {
            self.logFile?.log("chdir to '\(String(cString: path))' failed", level: .error)
            assertionFailure()
            exit(EXIT_FAILURE)
        }
        self.logFile?.log("Changed working dir to:", String(cString: path))
        
        
        // Close standard file descriptors
//        close(STDIN_FILENO)
//        close(STDOUT_FILENO)
//        close(STDERR_FILENO)
//        self.logFile.log("Standard file descriptors closed.")
    }
}










/*
func posixSpawn(path: String, fileActions: posix_spawn_file_actions_t? = nil, attributes: posix_spawnattr_t? = nil) -> pid_t? {
 
    // TODO: Fill these correctly.
    // See `man posix_spawn` for details.
    let arguments: [String]   = ["brewd"]
    let environment: [String] = []

    var childProcessID: pid_t = -1
    let path = path.withCString { $0 }
    var mutableFileActions = fileActions
    var mutableAttributes = attributes
    var argv = UnsafeMutablePointer(mutating: arguments.first?.withCString { $0 })
    var envp = UnsafeMutablePointer(mutating: environment.first?.withCString { $0 })

    return posix_spawn(&childProcessID, path, &mutableFileActions, &mutableAttributes, &argv, &envp)
}
*/
