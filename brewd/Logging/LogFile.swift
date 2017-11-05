//
//  LogFile.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//


class LogFile {
    private let executableName: String

    private let file: File
    
    enum Level {
        case debug
        case info
        case error
    }

    init(path: String, executableName: String) {
        self.executableName = executableName
        self.file = File(path: path, mode: .appendOrCreate)!
    }

    func log(format: String, _ arguments: CVarArg..., level: Level = .info) {
        let message = String(format: format, arguments: arguments)
        self.log(message, level: level)
    }

    func log(_ messages: Any..., level: Level = .info) {
        let message: String
        switch level {
        case .debug: message = messages.reduce("")       { $0.0 + " " + String(reflecting: $0.1) }
        case .info:  message = messages.reduce("")       { $0.0 + " " + String(describing: $0.1) }
        case .error: message = messages.reduce("ERROR:") { $0.0 + " " + String(describing: $0.1) }
        }

        let timeStamp = Date().formattedTimeStamp()
        let processID = getpid()
        let logString = String(format: "%@ <%@>[%d] %@\n", timeStamp, self.executableName, processID, message)

        // Print to console
        print(logString, terminator: "")
        
        // Write to file
        self.file.write(logString)
    }
}

class File {
    private var handle: UnsafeMutablePointer<FILE>

    enum Mode: String {
        case readExisting = "r"
        case readAndWriteExisting = "r+"
        case overwriteOrCreate = "w"
        case appendOrCreate = "a"
        case readAndOverwriteOrCreate = "w+"
        case readAndAppendOrCreate = "a+"
    }

    init?(path: String, mode: Mode) {
        guard
            var filePath = (path as NSString).expandingTildeInPath.cString(using: .utf8),
            var mode = mode.rawValue.cString(using: .utf8)?.first,
            let handlePointer = fopen(&filePath, &mode)
        else { return nil }

        self.handle = handlePointer
    }

    func write(_ message: String) {
        let format = "%s".withCString { $0 }

        let arguments: [CVarArg] = [ message.cString(using: .utf8)! ]
        let argumentsPointer = withVaList(arguments) { $0 }
        vfprintf(self.handle, format, argumentsPointer)
    }

    deinit {
        fclose(self.handle)
    }
}


extension Date {
    func formattedTimeStamp(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let string = dateFormatter.string(from: self)
        return string
    }
}
