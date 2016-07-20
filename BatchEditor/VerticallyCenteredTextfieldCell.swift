//
//  VerticallyCenteredTextfieldCell.swift
//  eleme
//
//  Created by 王志龙 on 16/5/6.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa

class VerticallyCenteredTextfieldCell: NSTextFieldCell {
  
  override func titleRectForBounds(theRect: NSRect) -> NSRect {
    let stringHeight = self.attributedStringValue.size().height
    var titleRect = super.titleRectForBounds(theRect)
    let oldOriginY = theRect.origin.y
    titleRect.origin.y = theRect.origin.y + (theRect.size.height - stringHeight) / 2.0
    titleRect.size.height = titleRect.size.height - (titleRect.origin.y - oldOriginY)
    return titleRect
  }
  
  override func drawInteriorWithFrame(cellFrame: NSRect, inView controlView: NSView) {
    let rect = titleRectForBounds(cellFrame)
    super.drawInteriorWithFrame(rect, inView: controlView)
  }
}
