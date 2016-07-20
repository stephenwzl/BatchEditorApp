//
//  DragView.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/13.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa
import SnapKit

class DragView: NSView {
  var dragHintLabel:NSTextField?
  
  convenience init() {
    self.init(frame: NSRect(origin: CGPointZero, size: CGSizeZero))
    self.registerForDraggedTypes([NSFilenamesPboardType])
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    loadSubView()
  }
  
  func loadSubView() {
    self.dragHintLabel = NSTextField()
    self.dragHintLabel?.backgroundColor = NSColor.clearColor()
    let attributeStr = NSMutableAttributedString(string: "Drag .json File Here",
                                                 attributes: [NSForegroundColorAttributeName: NSColor.whiteColor(), NSFontAttributeName: NSFont.systemFontOfSize(22)])
    attributeStr.addAttribute(NSForegroundColorAttributeName, value: NSColor.elemeBlue(), range:NSMakeRange(5, 5))
    self.dragHintLabel?.attributedStringValue = attributeStr
    self.dragHintLabel?.bordered = false
    self.dragHintLabel?.editable = false
    self.addSubview(self.dragHintLabel!)
    self.dragHintLabel?.snp_makeConstraints(closure: { (make) in
      make.centerY.equalTo(self)
      make.centerX.equalTo(self)
    })
  }
  
  override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
    return true
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
  }
    
}
