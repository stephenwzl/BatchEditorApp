//
//  NSUIButton.swift
//  eleme
//
//  Created by 王志龙 on 16/5/6.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa
import SnapKit

class NSUIButton: NSControl {
  
  var targetAction: () -> Void = {}
  
  var titleLabel: NSTextField?
  private var imageView: NSUIImageView?
  var image: NSImage? {
    get {
      return imageView?.image
    }
    set {
      if imageView == nil {
        imageView = NSUIImageView(image: newValue!)
        self.addSubview(imageView!)
        self.needsDisplay = true
      }
      else {
        imageView?.image = newValue
      }
    }
  }
  
  var isPressed: Bool = false
  private var _backgroundColor: NSColor?
  private var _titleColor: NSColor?
  var titleColor: NSColor? {
    set {
      _titleColor = newValue
      self.needsDisplay = true
    }
    get {
      return _titleColor
    }
  }
  var backgroundColor: NSColor? {
    set {
      _backgroundColor = newValue
      self.needsDisplay = true
    }
    get {
      return _backgroundColor
    }
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.wantsLayer = true
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawPolicy.OnSetNeedsDisplay
    loadSubViews()
  }
  
  func loadSubViews() {
    NSTextField.setCellClass(VerticallyCenteredTextfieldCell.classForCoder())
    self.titleLabel = NSTextField(frame: self.frame)
    self.addSubview(self.titleLabel!)
    self.titleLabel?.drawsBackground = false
    self.titleLabel?.bordered = false
    self.titleLabel?.editable = false
    self.titleLabel?.alignment = .Center
  }
  
  override func layout() {
    let size = self.titleLabel!.attributedStringValue.size()
    self.titleLabel?.snp_makeConstraints(closure: { (make) in
      make.centerX.centerY.equalTo(self)
      make.width.equalTo(size.width + 8)
      make.height.equalTo(size.height + 8)
    })
    if self.imageView != nil {
      self.imageView?.snp_makeConstraints(closure: { (make) in
        make.right.equalTo(self.titleLabel!.snp_left)
        make.centerY.equalTo(self.titleLabel!.snp_centerY)
        make.height.equalTo(self.imageView!.frame.size.width)
        make.width.equalTo(self.imageView!.frame.size.height)
      })
    }
    super.layout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override var wantsUpdateLayer: Bool {
    return true
  }
  
  override func updateLayer() {
    if self.isPressed {
      self.layer?.backgroundColor = self.backgroundColor?.colorWithAlphaComponent(0.7).CGColor
    }
    else {
      self.layer?.backgroundColor = self.backgroundColor?.CGColor
    }
  }
  
  override func mouseDown(theEvent: NSEvent) {
    self.isPressed = true
    self.sendAction(self.action, to: self.target)
    self.targetAction()
    self.needsDisplay = true
  }
  
  override func mouseUp(theEvent: NSEvent) {
    self.isPressed = false
    self.needsDisplay = true
  }
  
  
  func setBorderColor(color: NSColor) {
    self.layer?.borderColor = color.CGColor
    self.needsDisplay = true
  }
  
  func setBorderWidth(width: CGFloat)  {
    self.layer?.borderWidth = width
    self.needsDisplay = true
  }
  
}
