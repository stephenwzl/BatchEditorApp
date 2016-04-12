//
//  MainViewController.m
//  BatchEditor
//
//  Created by 王志龙 on 16/4/11.
//  Copyright © 2016年 ele.me. All rights reserved.
//

#import "MainViewController.h"
#import "NSString+JSON.h"
#import "JSONTree.h"
#import "EditViewController.h"
@interface MainViewController ()<NSOutlineViewDataSource,NSOutlineViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, strong) JSONTree *data;
@property (weak) IBOutlet NSButton *isPretty;
@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.textView.automaticQuoteSubstitutionEnabled = NO;
  [self.outlineView setDoubleAction:@selector(doubleClicked)];
  [self.outlineView setDelegate:self];
  [self.outlineView setDataSource:self];
}

- (void)doubleClicked {
  NSInteger row = [self.outlineView clickedRow];
  __block JSONTree *node = [self.outlineView itemAtRow:row];
  EditViewController *editVC = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
  editVC.node = node;
  __weak typeof(self) weakSelf = self;
  __block JSONTree *data = weakSelf.data;
  [editVC setDidFinishBlock:^(JSONTree *newNode) {
    node = newNode;
    [weakSelf.outlineView reloadData];
    [weakSelf viewToJSONString];
  }];
  [editVC setDidDeleteBlock:^{
    [data deleteNode:node];
    [weakSelf.outlineView reloadData];
    [weakSelf viewToJSONString];
  }];
  [self presentViewControllerAsSheet:editVC];
}
- (void)viewToJSONString {
  NSJSONWritingOptions writeOption = self.isPretty.state == 1 ? NSJSONWritingPrettyPrinted : 0;
  NSData *data = [NSJSONSerialization dataWithJSONObject:[self.data jsonObject] options:writeOption error:nil];
  NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  self.textView.string = str;
}

- (IBAction)toVisualize:(id)sender {
  NSString *str = self.textView.string;
  if ([str isJSON]) {
    self.data = [[JSONTree alloc] initWithObject:[str toJSON]];
    [self.outlineView reloadData];
  }
}
- (IBAction)toJSONString:(id)sender {
  if (self.data) {
    [self viewToJSONString];
  }
}
- (IBAction)changePretty:(NSButton *)sender {
    NSString *str = self.textView.string;
    if (str.length > 0 && [str isJSON]) {
      if (self.isPretty.state == 0) {
        return;
      }
      NSData *data = [NSJSONSerialization dataWithJSONObject:[str toJSON] options:NSJSONWritingPrettyPrinted error:nil];
      NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      self.textView.string = str;
    }
}

#pragma mark datasource
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
  if (item == nil) {
    return self.data.children[index];
  }
  if ([item isKindOfClass:[JSONTree class]]) {
    return [item children][index];
  }
  return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
  if ([outlineView parentForItem:item] == nil) {
    return YES;
  }
  if ([item children].count > 0) {
    return YES;
  }
  return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
  if (item == nil) {
    return self.data.children.count;
  }
  NSArray *array = [item children];
  if (array) {
    return array.count;
  }
  return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
  return [item rawValue];
}
#pragma mark delegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
  NSTableCellView *view = [outlineView makeViewWithIdentifier:@"datacell" owner:self];

  view.textField.stringValue = [item description];
  return view;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
  if ([item children].count == 0 && [item rawType] == JSONTreeTypeKV) {
    NSLog(@"YES");
    return YES;
  }
  return NO;
}

@end
