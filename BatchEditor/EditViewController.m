//
//  EditViewController.m
//  BatchEditor
//
//  Created by 王志龙 on 16/4/12.
//  Copyright © 2016年 ele.me. All rights reserved.
//

#import "EditViewController.h"
#import "JSONTree.h"

@interface EditViewController ()
@property (weak) IBOutlet NSTextField *keyField;
@property (weak) IBOutlet NSTextField *valueField;
@property (weak) IBOutlet NSButton *confirmButton;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  if (self.node.rawType != JSONTreeTypeKV) {
    self.keyField.enabled = NO;
    self.valueField.enabled = NO;
    self.confirmButton.enabled = NO;
  }else {
    self.keyField.stringValue = self.node.rawKey;
    self.valueField.stringValue = self.node.rawValue;
  }
}
- (IBAction)deleteAction:(id)sender {
  if (self.didDeleteBlock) {
    self.didDeleteBlock();
    [self dismissController:self];
  }
}
- (IBAction)cancelAction:(id)sender {
  [self dismissController:self];
}
- (IBAction)confirmAction:(id)sender {
  if (self.didFinishBlock) {
    self.node.rawKey = self.keyField.stringValue;
    self.node.rawValue = self.valueField.stringValue;
    self.didFinishBlock(self.node);
    [self dismissController:self];
  }
}

@end
