//
//  BeerImage.swift
//  brewd
//
//  Created by mxa on 22.02.16.
//  Copyright © 2016 mxa. All rights reserved.
//

import Cocoa

class BeerImage: NSImage {
    override init(size: NSSize) {
        super.init(size: size)

        let 🍺 = "🍻" as NSString

        self.lockFocus()
        let fontAttributes = [NSFontAttributeName: NSFont.systemFont(ofSize: size.height)]
        🍺.draw(in: NSRect(origin: CGPoint.zero, size: size), withAttributes: fontAttributes)
        self.unlockFocus()
    }


    required init?(pasteboardPropertyList propertyList: Any, ofType type: String) {
        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
