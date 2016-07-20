//
//  EditorViewController.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/15.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa

class EditorViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate, NSSearchFieldDelegate {
  
  var fliter:String?
  var _jsonString:String?
  var jsonString:String? {
    set {
      _jsonString = newValue
      DataCenter.sharedDataCenter.jsonString = newValue
      self.outlineView.reloadData()
    }
    get {
      return self.textView.string
    }
  }
  var data:JSONTree? {
    get {
      return DataCenter.sharedDataCenter.tableData
    }
  }

  @IBOutlet weak var searchField: NSSearchField!
  @IBOutlet weak var rightScrollVIew: NSScrollView!
  @IBOutlet weak var rightView: NSView!
  @IBOutlet weak var splitView: NSSplitView!
  @IBOutlet var textView: NSTextView!
  @IBOutlet weak var outlineView: NSOutlineView!
  
  var leftButton:NSButton?
  var rightButton:NSButton?
  var expandButton:NSButton?
  
  var isExpanded:Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadSubviews()
  }
  
  func loadSubviews() {
    
    self.textView.richText = false
    self.textView.backgroundColor = NSColor.clearColor()
    self.textView.textColor = NSColor.textLight()
    self.textView.automaticQuoteSubstitutionEnabled = false
    self.outlineView.backgroundColor = NSColor.clearColor()
    self.outlineView.setDelegate(self)
    self.outlineView.setDataSource(self)
    self.outlineView.doubleAction = #selector(EditorViewController.doubleClicked)
    self.rightScrollVIew.scrollerStyle = .Overlay
    
    self.leftButton = NSButton()
    self.leftButton?.image = NSImage(named: "icon-left")
    self.leftButton?.setButtonType(.MomentaryChangeButton)
    self.leftButton?.bordered = false
    self.leftButton?.target = self
    self.leftButton?.action = #selector(EditorViewController.leftButtonClicked)
    self.rightView.addSubview(self.leftButton!)
    self.leftButton?.snp_makeConstraints(closure: { (make) in
      make.left.equalTo(self.rightView)
      make.centerY.equalTo(self.rightView).offset(-60)
    })
    
    self.rightButton = NSButton()
    self.rightButton?.setButtonType(.MomentaryChangeButton)
    self.rightButton?.bordered = false
    self.rightButton?.image = NSImage(named: "icon-right")
    self.rightButton?.target = self
    self.rightButton?.action = #selector(EditorViewController.rightButtonClicked)
    self.rightView.addSubview(self.rightButton!)
    self.rightButton?.snp_makeConstraints(closure: { (make) in
      make.centerY.equalTo(self.rightView).offset(60)
      make.left.equalTo(self.rightView)
    })
    
    self.expandButton = NSButton()
    self.expandButton?.setButtonType(.MomentaryChangeButton)
    self.expandButton?.bordered = false
    self.expandButton?.image = NSImage(named: "expand")
    self.expandButton?.target = self
    self.expandButton?.action = #selector(EditorViewController.toggleExpand)
    self.rightView.addSubview(self.expandButton!)
    self.expandButton?.snp_makeConstraints(closure: { (make) in
      make.centerY.equalTo(self.rightView)
      make.left.equalTo(self.rightView)
    })
    
    self.searchField.target = self
    self.searchField.action = #selector(EditorViewController.doSearch)
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    if self._jsonString?.isEmpty == false {
      self.jsonString = _jsonString
    }
    self.splitView.setPosition(160, ofDividerAtIndex: 0)
    resizeWindow()
  }
  
  func resizeWindow() {
    self.view.window?.styleMask = NSResizableWindowMask | (self.view.window?.styleMask)!
  }
    
}

extension EditorViewController {
  func leftButtonClicked() {
    if self.data == nil {
      return
    }
    self.textView.string = self.data!.jsonTextWithPretty(.PrettyPrinted)
  }
  func rightButtonClicked() {
    self.jsonString = self.textView.string
  }
  func toggleExpand() {
    if isExpanded {
      self.outlineView.collapseItem(nil, collapseChildren: true)
      self.expandButton?.image = NSImage(named: "expand")
    }else {
      self.outlineView.expandItem(nil, expandChildren: true)
      self.expandButton?.image = NSImage(named: "collpase")
    }
    isExpanded = !isExpanded
  }
  
  func doubleClicked() {
    let row = self.outlineView.clickedRow
    var item = self.outlineView.itemAtRow(row) as? JSONTree
    let parent = self.outlineView.parentForItem(item) as? JSONTree
    let modifyViewcontroller = ModifyViewController(nibName: "ModifyViewController", bundle: nil)
    modifyViewcontroller?.node = item
    modifyViewcontroller?.confirmBlock = {[weak self] (node:JSONTree) in
      item = node
      self?.outlineView.reloadData()
      self?.textView.string = self?.data?.jsonTextWithPretty(.PrettyPrinted)
    }
    modifyViewcontroller?.deleteBlock = {[weak self] () in
      self?.data?.deleteNode(item, parent: parent)
      self?.outlineView.reloadData()
      self?.textView.string = self?.data?.jsonTextWithPretty(.PrettyPrinted)
    }
    self.presentViewControllerAsSheet(modifyViewcontroller!)
  }
}

extension EditorViewController {
  
  func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
    if item.isKindOfClass(JSONTree.classForCoder()) == false {
      return false
    }
    return (item as! JSONTree).children.count > 0
  }
  
  func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
    if self.data == nil {
      return NSObject()
    }
    if item == nil {
      return self.data!.children[index]
    }
    if item?.isKindOfClass(JSONTree.classForCoder()) == true {
      return (item as! JSONTree).children[index]
    }
    return NSObject()
  }
  
  func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
    if self.data == nil {
      return 0
    }
    if item == nil {
      return self.data!.children.count
    }
    if item?.isKindOfClass(JSONTree.classForCoder()) == true {
      return (item as! JSONTree).children.count
    }
    return 0
  }
  //delegate
  func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
    let view = outlineView.makeViewWithIdentifier("dataView", owner: self) as? NSTableCellView
    guard view == nil else {
      view?.textField?.stringValue = (item as! JSONTree).description
      view?.wantsLayer = true
      if String.isAbsoluteEmpty(self.fliter) {
        view?.layer?.backgroundColor = NSColor.clearColor().CGColor
        view?.textField?.textColor = NSColor.blackColor()
      }
      else if (item as! JSONTree).description.containsString(self.fliter!) {
        view?.layer?.backgroundColor = NSColor.elemeBlue().CGColor
        view?.textField?.textColor = NSColor.whiteColor()
      }else {
        view?.layer?.backgroundColor = NSColor.clearColor().CGColor
        view?.textField?.textColor = NSColor.blackColor()
      }
      return view
    }
    return nil
  }
}

extension EditorViewController {
  func search(sender:AnyObject?) {
    self.window()?.makeFirstResponder(self.searchField)
  }
  
  func doSearch() {
    if self.searchField.stringValue.isEmpty {
      self.outlineView.reloadData()
      return
    }
    self.fliter = self.searchField.stringValue
    self.isExpanded = false
    self.outlineView.reloadData()
    self.toggleExpand()
  }
}