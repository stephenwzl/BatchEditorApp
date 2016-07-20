//
//  DataCenter.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/19.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Foundation

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
  
}