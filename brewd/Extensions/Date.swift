//
//  Date.swift
//  brewd
//
//  Created by mxa on 05.11.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Foundation

extension Date {
    func formattedTimeStamp(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let string = dateFormatter.string(from: self)
        return string
    }
}
