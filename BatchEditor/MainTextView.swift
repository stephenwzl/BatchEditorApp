//
//  MainTextView.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/15.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa

class MainTextView: NSTextView {
  typealias ActionBlock = () -> Void
  var becomeFirstResponderAction:ActionBlock?
  var resignFirstResponderAction:ActionBlock?
  
  override func becomeFirstResponder() -> Bool {
    guard self.becomeFirstResponderAction == nil else {
      self.becomeFirstResponderAction!()
      return true
    }
    return true
  }
  
  override func resignFirstResponder() -> Bool {
    guard self.resignFirstResponderAction == nil else {
      self.resignFirstResponderAction!()
      return true
    }
    return true
  }
  
}
