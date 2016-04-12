//
//  AppDelegate.m
//  BatchEditor
//
//  Created by 王志龙 on 16/4/11.
//  Copyright © 2016年 ele.me. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self configWindow];
}

- (void)configWindow {
  self.window.titlebarAppearsTransparent = YES;
  self.window.contentViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
  NSRect originRect = self.window.frame;
  originRect.size = CGSizeMake(160 * 6, 90 * 6);
  [self.window setFrame:originRect display:YES];
}
@end