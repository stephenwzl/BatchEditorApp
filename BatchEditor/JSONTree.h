//
//  JSONTree.h
//  BatchEditor
//
//  Created by 王志龙 on 16/4/12.
//  Copyright © 2016年 ele.me. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , JSONTreeType) {
  JSONTreeTypeDictionary = 1,
  JSONTreeTypeArray,
  JSONTreeTypeKV,
  JSONTreeTypeBatch,
  JSONTreeTypeBatchArray,
  JSONTreeTypeBatchDictonary
};

@interface JSONTree : NSObject

@property (nonatomic, strong) NSMutableArray<JSONTree *> *children;
//3 types
//Array (Dictionary,single K/V)
//Dictionary => K/V Array
//single K/V
@property (nonatomic, assign) JSONTreeType rawType;
@property (nonatomic, strong) id rawValue;
@property (nonatomic, strong) NSString *rawKey;

- (instancetype)initWithObject:(id)object;
- (id)jsonObject;
- (NSString *)jsonTextWithPretty:(NSJSONWritingOptions)option;
- (void)deleteNode:(JSONTree *)node parent:(JSONTree *)parent;
@end
