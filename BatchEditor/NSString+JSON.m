//
//  NSString+JSON.m
//  BatchEditor
//
//  Created by 王志龙 on 16/4/11.
//  Copyright © 2016年 ele.me. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString(JSON)

- (BOOL)isJSON {
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error;
  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
  if (error == nil) {
    return YES;
  }
  return NO;
}

- (id)toJSON {
  if ([self isJSON]) {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableLeaves error:nil];
  }
  return nil;
}

@end
