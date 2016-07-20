//
//  ModifyViewController.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/20.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa

class ModifyViewController: NSViewController {
  var key:String {
    get {
      if node == nil {
        return ""
      }
      return node!.rawKey
    }
    set {
      if node == nil {
        return
      }
      node!.rawKey = newValue
    }
  }
  var value:String {
    get {
      if node == nil {
        return ""
      }
      if node!.rawType != .KV {
        return ""
      }
      return "\(node!.rawValue)"
    }
    set {
      if node == nil {
        return
      }
      if node!.rawType != .KV {
        return
      }
      node?.rawValue = newValue
    }
  }
  var node:JSONTree?
  var deleteBlock: () -> Void = {}
  var confirmBlock: (node:JSONTree) -> Void = { node in }
  
  @IBOutlet weak var keyField: NSTextField!
  @IBOutlet weak var valueField: NSTextField!
  @IBOutlet weak var cancelBtn: NSButton!
  @IBOutlet weak var confirmBtn: NSButton!
  @IBOutlet weak var deleteBtn: NSButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if node != nil {
      if node!.rawType != .KV {
        self.keyField.enabled = false
        self.valueField.enabled = false
        self.confirmBtn.enabled = false
      }else {
        self.keyField.stringValue = key
        self.valueField.stringValue = value
      }
    }
  }
  @IBAction func cancelAction(sender: AnyObject) {
    self.dismissController(self)
  }
  @IBAction func confirmAction(sender: AnyObject) {
    key = self.keyField.stringValue
    value = self.valueField.stringValue
    self.confirmBlock(node: node!)
    self.dismissController(self)
  }
  @IBAction func trashAction(sender: AnyObject) {
    self.deleteBlock()
    self.dismissController(self)
  }
}
