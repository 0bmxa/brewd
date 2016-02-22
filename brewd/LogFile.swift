//
//  LogFile.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

extension LogFile {
    class func log(format: String, _ args: CVarArgType...) {
        LogFile.logFormat(format, andArguments: getVaList(args))
    }
}