//
//  AppDelegate.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/13.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  var aboutWindow:NSWindowController?

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    configWindowAppearance()
    DataCenter.sharedDataCenter.checkforUpdate { (needUpdate, url) in
      
    }
  }
  
  func configWindowAppearance() {
    self.window.restorable = true
    self.window.titlebarAppearsTransparent = true
    self.window.contentViewController = EditorViewController(nibName: "EditorViewController", bundle: nil)
  }
  
  func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if flag {
      return false
    } else {
      self.window.makeKeyAndOrderFront(self)
      return true
    }
  }
  @IBAction func showAboutWindow(sender: AnyObject) {
    if self.aboutWindow == nil {
      self.aboutWindow = AboutWindow(windowNibName: "AboutWindow")
      self.aboutWindow?.window?.titlebarAppearsTransparent = true
    }
    self.aboutWindow?.window?.makeKeyAndOrderFront(self)
  }
}

