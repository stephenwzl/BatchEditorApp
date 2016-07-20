//
//  NSString+JSON.h
//  BatchEditor
//
//  Created by 王志龙 on 16/4/11.
//  Copyright © 2016年 ele.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(JSON)

- (BOOL)isJSON;
- (void)judgeIsJsonWithBlock:(void(^)(BOOL, NSError *))block;
- (id)toJSON;

@end
