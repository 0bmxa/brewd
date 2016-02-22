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
        
//        let 🍺 = "🍺" as NSString
        let 🍺 = "🍻" as NSString
        
        self.lockFocus()
        let fontAttributes = [NSFontAttributeName: NSFont.systemFontOfSize(size.height)]
        🍺.drawInRect(NSMakeRect(0, 0, size.width, size.height), withAttributes: fontAttributes)
        self.unlockFocus()
    }
    
    
    // MARK: Required shit
    
    required init(imageLiteral name: String) {
        super.init()
    }
    required init?(pasteboardPropertyList propertyList: AnyObject, ofType type: String) {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
}