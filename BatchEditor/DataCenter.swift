//
//  DataCenter.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/19.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Foundation
import Ji

class DataCenter {
  static let sharedDataCenter = DataCenter()
  private init() {}
  
  private var serializedJson:JSONTree?
  var fliteredJson:[JSONTree]?
  private var _fliter:String? = nil
  
  var tableData:JSONTree? {
    get {
      return self.serializedJson
    }
    set {
      serializedJson = newValue
    }
  }
  
  var jsonString:String? {
    get {
      if self.tableData == nil {
        return nil
      }
      return self.tableData!.jsonTextWithPretty(.PrettyPrinted)
    }
    set {
      let str = NSString(string: newValue!)
      if str.isJSON() {
        self.tableData = JSONTree(object: str.toJSON())
      }
    }
  }
  
  var fliter:String? {
    get {
      return _fliter
    }
    set {
      _fliter = newValue
      makeFliter()
    }
  }
  
  func makeFliter() {
    if fliter == nil || fliter!.isEmpty {
      return
    }
    fliteredJson = self.serializedJson?.flit(fliter) as? [JSONTree]
  }
  
  func checkforUpdate(completion:(needUpdate:Bool, url:String) -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      var update = false
      var url:String = ""
      let doc = Ji(htmlURL: NSURL(string: "https://github.com/stephenwzl/BatchEditorApp/releases")!)
      let lastReleaseNode = doc?.xPath("//*[@id=\"js-repo-pjax-container\"]/div[2]/div[1]/div[2]/div[1]/div[1]/ul/li[1]/a/span")
      if lastReleaseNode != nil && lastReleaseNode?.count != 0 {
        let last = lastReleaseNode![0]
        let content = last.content
        if content != nil {
          if content != "\(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!)" {
            update = true
            url = "https://github.com/stephenwzl/BatchEditorApp/releases"
          }
        }
      }
      dispatch_async(dispatch_get_main_queue(), {
        completion(needUpdate: update, url: url)
      })
      
    }
    
  }
  
}