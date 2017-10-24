//
//  LogFile.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

@objc class LogFile: NSObject {
    private let executableName: String

    let file: File

    init(path: String, executableName: String) {
        self.executableName = executableName
        self.file = File(path: path, mode: .appendOrCreate)!
    }

    func log(format: String, _ arguments: CVarArg...) {
        let message = String(format: format, arguments: arguments)
        self.log(message)
    }

    func log(_ messages: String...) {
        let message = messages.reduce("") { $0.0 + " " + $0.1 }
        let timeStamp = Date().formattedTimeStamp()
        let processID = getpid()
        let logString = String(format: "%@ <%s>[%d] %@\n", timeStamp, self.executableName, processID, message)
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
        return dateFormatter.string(from: self)
    }
}
