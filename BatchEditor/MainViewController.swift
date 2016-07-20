//
//  MainViewController.swift
//  BatchEditor
//
//  Created by 王志龙 on 16/7/13.
//  Copyright © 2016年 stephenw.cc. All rights reserved.
//

import Cocoa
import SnapKit

class MainViewController: NSViewController, NSTextViewDelegate {
  
  var dragView:DragView?
  var hintView:MainTextViewHintView?
  
  var hasShowHintView:Bool = false
  
  @IBOutlet weak var hintLabel: NSTextField!
  @IBOutlet var textView: MainTextView!
  
  @IBOutlet weak var backgroundView: NSVisualEffectView!
  @IBOutlet weak var backgroundBottomView: NSVisualEffectView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadSubViews()
  }
  
  func loadSubViews() {
    self.dragView = DragView()
    self.backgroundView.addSubview(self.dragView!)
    self.dragView?.snp_makeConstraints(closure: { (make) in
      make.top.equalTo(44)
      make.left.equalTo(20)
      make.right.equalTo(-20)
      make.height.equalTo(100)
    })
    self.textView.backgroundColor = NSColor.clearColor()
    self.textView.delegate = self
    self.textView.becomeFirstResponderAction = {
      self.hintLabel.hidden = true
    }
    
    self.hintView = MainTextViewHintView()
    self.hintView?.successAction = {
      let viewController = EditorViewController(nibName: "EditorViewController", bundle: nil)
      viewController?.jsonString = self.textView.string
      self.presentViewController(viewController!, animator: ReplacePresentationAnimator())
    }
    self.backgroundBottomView.addSubview(self.hintView!)
    self.hintView?.snp_makeConstraints(closure: { (make) in
      make.left.right.equalTo(0)
      make.top.equalTo(self.backgroundBottomView.snp_bottom)
      make.height.equalTo(28)
    })
    
//    properties below has been set in nib
    self.textView.automaticQuoteSubstitutionEnabled = false
//    self.textView.automaticTextReplacementEnabled = false
//    self.textView.automaticDashSubstitutionEnabled = false
  }
}

extension MainViewController {
  
  func showHintView() {
    if self.hasShowHintView == false {
      self.hintView?.snp_updateConstraints(closure: { (make) in
        make.top.equalTo(self.backgroundBottomView.snp_bottom).offset(-28)
      })
      NSAnimationContext.runAnimationGroup({ (context) in
        context.allowsImplicitAnimation = true
        self.backgroundBottomView.layoutSubtreeIfNeeded()
        }, completionHandler: { 
          self.hasShowHintView = true
      })
    }
  }
  
  func dismissHintView() {
    if self.hasShowHintView == true {
      self.hintView?.snp_updateConstraints(closure: { (make) in
        make.top.equalTo(self.backgroundBottomView.snp_bottom)
      })
      NSAnimationContext.runAnimationGroup({ (context) in
        context.allowsImplicitAnimation = true
        self.backgroundBottomView.layoutSubtreeIfNeeded()
        }, completionHandler: {
          self.hasShowHintView = false
      })
    }
  }
  
  func textDidChange(notification: NSNotification) {
    if self.textView.string?.isEmpty == true {
      self.dismissHintView()
    } else {
      let str = NSString(string: self.textView.string!)
      str.judgeIsJsonWithBlock { (isJson, error) in
        if isJson == false {
          self.hintView?.setStateToError(error)
          self.showHintView()
          debugPrint(error)
        } else {
          self.hintView?.setStateToSuccess()
          self.showHintView()
        }
      }
      return
    }
    return
  }
  
}

class ReplacePresentationAnimator: NSObject, NSViewControllerPresentationAnimator {
  func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
    if let window = fromViewController.view.window {
      NSAnimationContext.runAnimationGroup({ (context) -> Void in
        fromViewController.view.animator().alphaValue = 0
        viewController.view.animator().alphaValue = 0
        context.duration = 0.5
        }, completionHandler: { () -> Void in
          window.contentViewController = viewController
          viewController.view.alphaValue = 1
      })
    }
  }
  
  func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
    if let window = viewController.view.window {
      NSAnimationContext.runAnimationGroup({ (context) -> Void in
        viewController.view.animator().alphaValue = 0
        }, completionHandler: { () -> Void in
          fromViewController.view.alphaValue = 0
          window.contentViewController = fromViewController
          fromViewController.view.animator().alphaValue = 1.0
      })
    }
  }
}
