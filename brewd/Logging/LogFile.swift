//
//  LogFile.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Foundation

enum LogLevel {
    case debug
    case info
    case error
}

class LogFile {
    private let executableName: String
    private let path: String
    
    init(path: String, executableName: String) {
        self.executableName = executableName
        self.path = (path as NSString).expandingTildeInPath
    }

    func log(format: String, _ arguments: CVarArg..., level: LogLevel = .info) {
        let message = String(format: format, arguments: arguments)
        self.log(message, level: level)
    }

    func log(_ messages: Any..., level: LogLevel = .info) {
        let message: String
        
        switch level {
        case .debug:
            #if !DEBUG
                return
            #endif
            fallthrough
        case .info:  message = messages.reduce("")       { $0 + "\($1) " }
        case .error: message = messages.reduce("ERROR:") { $0 + "\($1) " }
        }


        let timeStamp = Date().formattedTimeStamp()
        let processID = getpid()
        let logString = String(format: "%@ <%@>[%d] %@\n", timeStamp, self.executableName, processID, message)

        // Print to console
        print(logString, terminator: "")
        
        // Write to file
        guard
            let handle = FileHandle(forWritingAtPath: self.path),
            let logStringData = logString.data(using: .utf8)
        else {
            print("ERROR: Could not write to file", self.path)
            return
        }
        handle.seekToEndOfFile()
        handle.write(logStringData)
    }
}

