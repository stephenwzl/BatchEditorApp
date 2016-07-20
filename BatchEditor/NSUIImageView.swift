//
//  NSUIImageView.swift
//  eleme
//
//  Created by 王志龙 on 16/5/6.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa

class NSUIImageView: NSControl {
  private var _image: NSImage?
  var image: NSImage? {
    get {
      return _image
    }
    set {
      _image = newValue
      self.needsDisplay = true
    }
  }
  
  init(image: NSImage) {
    super.init(frame: NSMakeRect(0, 0, image.size.width, image.size.height))
    self.wantsLayer = true
    self.layerContentsRedrawPolicy = .OnSetNeedsDisplay
    self.image = image
  }
  
  override var wantsUpdateLayer: Bool {
    return true
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func updateLayer() {
    self.layer?.contents = self.image
  }
  
  func setBorderColor(color: NSColor) {
    self.layer?.borderColor = color.CGColor
    self.needsDisplay = true
  }
  
  func setBorderWidth(width: CGFloat)  {
    self.layer?.borderWidth = width
    self.needsDisplay = true
  }
  
//  func setCornerRadius(radius: CGFloat) {
//    self.layer?.cornerRadius = radius
//    self.needsDisplay = true
//  }
  
}
