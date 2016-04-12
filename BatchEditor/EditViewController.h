//
//  EditViewController.h
//  BatchEditor
//
//  Created by 王志龙 on 16/4/12.
//  Copyright © 2016年 ele.me. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JSONTree;

@interface EditViewController : NSViewController

@property (nonatomic, strong) JSONTree *node;
@property (nonatomic, copy) void(^didFinishBlock)(JSONTree *);
@property (nonatomic, copy) void(^didDeleteBlock)();
@end
