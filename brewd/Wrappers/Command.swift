//
//  Shell.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Foundation

/// Simple command runner.
struct Command {

    struct CommandResult {
        let stdout: String?
        let stderr: String?
    }

    /// Executes a "shell" command synchronously (blocking).
    ///
    /// - Parameter args: The arguments of the command to be executed, including the command itself.
    /// - Returns: The returned stdout and stderr strings, if applicable.
    static func runSynchronously(_ args: String...) -> CommandResult {
        // Setup process
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = args

        // Setup stdout & stderr pipes
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError  = stderrPipe

        // Run process & wait
        process.launch()
        process.waitUntilExit()

        // Obtain output
        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
        let stdout = String(data: stdoutData, encoding: .utf8)
        let stderr = String(data: stderrData, encoding: .utf8)

        return CommandResult(stdout: stdout, stderr: stderr)
    }
}
