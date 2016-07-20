//
//  MainTextViewHintView.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/15.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa
import SnapKit

class MainTextViewHintView: NSView {
  
  var hintLabel:NSTextField?
  var hintImage:NSUIImageView?
  var helpImage:NSImage?
  var errorImage:NSImage?
  var successImage:NSImage?
  
  var backgroundColor:NSColor = NSColor.clearColor()
  
  var state:Bool = false
  var isPressed:Bool = false
  
  var clickAction:() -> Void = {}
  var errorAction:() -> Void = {}
  var successAction:() -> Void = {}
  
  convenience init() {
    self.init(frame: NSRect(origin: CGPointZero, size: CGSizeZero))
    loadSubViews()
    self.wantsLayer = true
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawPolicy.OnSetNeedsDisplay
  }
  
  func loadSubViews() {
    
    self.hintLabel = NSTextField()
    self.hintLabel?.bordered = false
    self.hintLabel?.backgroundColor = NSColor.clearColor()
    self.hintLabel?.placeholderString = "I have some error to handle..."
    self.hintLabel?.editable = false
    self.hintLabel?.lineBreakMode = .ByTruncatingTail
    self.hintLabel?.preferredMaxLayoutWidth = 320
    
    self.helpImage = NSImage(named: "icon-help")
    self.errorImage = NSImage(named: "icon-error")
    self.successImage = NSImage(named: "icon-success")
    
    self.hintImage = NSUIImageView(image: self.helpImage!)
    
    self.addSubview(self.hintImage!)
    self.addSubview(self.hintLabel!)
    self.hintImage?.snp_makeConstraints(closure: { (make) in
      make.centerY.equalTo(self)
      make.width.height.equalTo(16)
      make.left.equalTo(8)
    })
    self.hintLabel?.snp_makeConstraints(closure: { (make) in
      make.left.equalTo(self.hintImage!.snp_right).offset(8)
      make.right.equalTo(-16).priorityLow()
      make.centerY.equalTo(self)
    })
    self.backgroundColor = NSColor.yellowColor()
    self.needsDisplay = true
  }
  
  func setStateToError(error:NSError) {
    self.state = false
    self.backgroundColor = NSColor.greenColor()
    self.hintImage?.image = self.errorImage
    self.hintLabel?.stringValue = error.localizedDescription
    self.needsDisplay = true
  }
  
  func setStateToSuccess() {
    self.state = true
    self.backgroundColor = NSColor.elemeBlue()
    self.hintImage?.image = self.successImage
    self.hintLabel?.stringValue = "click me to see it now"
    self.needsDisplay = true
  }
  
  override var wantsUpdateLayer: Bool {
    return true
  }
  
  override func updateLayer() {
    if self.isPressed {
      self.layer?.backgroundColor = self.backgroundColor.colorWithAlphaComponent(0.7).CGColor
    }
    else {
      self.layer?.backgroundColor = self.backgroundColor.CGColor
    }
  }
  
  override func mouseDown(theEvent: NSEvent) {
    self.isPressed = true
    if self.state == true {
      self.successAction()
    }else {
      self.errorAction()
    }
    self.needsDisplay = true
  }
  
  override func mouseUp(theEvent: NSEvent) {
    self.isPressed = false
    self.needsDisplay = true
  }
  
  override func mouseEntered(theEvent: NSEvent) {
    super.mouseEntered(theEvent)
    NSCursor.pointingHandCursor().set()
  }
  
  override func mouseExited(theEvent: NSEvent) {
    super.mouseExited(theEvent)
    NSCursor.arrowCursor().set()
  }
  
}
