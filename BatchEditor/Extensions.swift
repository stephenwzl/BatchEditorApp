//
//  Extensions.swift
//  eleme
//
//  Created by 王志龙 on 16/5/6.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa

extension NSColor {
  static func elemeBlue() -> NSColor {
    return NSColor(deviceRed: 49 / 255.0, green: 144 / 255.0, blue: 232 / 255.0, alpha: 1.0)
  }
  
  static func selectionGray() -> NSColor {
    return NSColor(deviceRed: 236 / 255.0, green: 236 / 255.0, blue: 236 / 255.0, alpha: 1.0)
  }
  static func RGBColor(R:CGFloat,G:CGFloat,B:CGFloat) -> NSColor {
    return NSColor(deviceRed: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: 1.0)
  }
  static func textLight() -> NSColor {
    return self.RGBColor(227, G: 227, B: 227)
  }
  static func textGreen() -> NSColor {
    return self.RGBColor(50, G: 205, B: 50)
  }
}

extension NSImage {
  func setCornerRadius(radius: CGFloat) -> NSImage {
    let size = self.size
    let newImage = NSImage(size: size)
    newImage.lockFocus()
    
    let ctx = NSGraphicsContext.currentContext()
    ctx?.imageInterpolation = .High
    
    let clipPath = NSBezierPath(roundedRect: NSMakeRect(0, 0, size.width, size.height), xRadius: radius, yRadius: radius)
    clipPath.windingRule = .EvenOddWindingRule
    clipPath.addClip()
    
    [self .drawAtPoint(NSZeroPoint, fromRect: NSMakeRect(0,0,size.width, size.height), operation:.CompositeSourceOver, fraction: 1)]
    newImage.unlockFocus()
    
    return newImage
  }
}

extension String {
  static func isAbsoluteEmpty(str:String?) -> Bool {
    if str == nil {
      return true
    }
    return str!.isEmpty
  }
}

extension NSViewController {
  func window() -> NSWindow? {
    return self.view.window
  }
}