//
//  AboutWindow.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/20.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa

class AboutWindow: NSWindowController {
  
  @IBOutlet weak var versionLabel: NSTextField!
  override func windowDidLoad() {
    super.windowDidLoad()
    self.versionLabel.stringValue = "Batch Editor v\(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!)"
  }
  @IBAction func checkUpdate(sender: AnyObject) {
    DataCenter.sharedDataCenter.checkforUpdate { (needUpdate, url) in
      if needUpdate {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: url)!)
      }else {
        let alert = NSAlert()
        alert.messageText = "This Version Maybe Uptodate"
        alert.runModal()
      }
    }
  }
}
