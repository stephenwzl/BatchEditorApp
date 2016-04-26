//
//  JSONTree.m
//  BatchEditor
//
//  Created by 王志龙 on 16/4/12.
//  Copyright © 2016年 ele.me. All rights reserved.
//

#import "JSONTree.h"
#import "NSString+JSON.h"
@implementation JSONTree

- (instancetype)initWithObject:(id)object {
  self = [super init];
  if (self) {
    _rawValue = object;
    [self loopParseObject:object];
  }
  return self;
}

- (void)loopParseObject:(id)obj {
  if ([obj isKindOfClass:[NSString class]] && [obj isJSON]) {
    self.rawType = JSONTreeTypeBatch;
    [self loopParseObject:[obj toJSON]];
  }
  else if ([obj isKindOfClass:[NSArray class]]) {
    if (self.rawType == JSONTreeTypeBatch) {
      self.rawType = JSONTreeTypeBatchArray;
    }else {
      self.rawType = JSONTreeTypeArray;
    }
    for (int i = 0; i < [obj count]; ++i) {
      JSONTree *node = [[JSONTree alloc] initWithObject:obj[i]];
      node.rawKey = [NSString stringWithFormat:@"array object[%d]",i];
      [self.children addObject:node];
    }
  }
  else if ([obj isKindOfClass:[NSDictionary class]]) {
    if (self.rawType == JSONTreeTypeBatch) {
      self.rawType = JSONTreeTypeBatchDictonary;
    }else {
      self.rawType = JSONTreeTypeDictionary;
    }
    for (NSString *key in [obj allKeys]) {
      JSONTree *node = [[JSONTree alloc] initWithObject:obj[key]];
      node.rawKey = key;
      [self.children addObject:node];
    }
  }
  else {
    self.rawType = JSONTreeTypeKV;
  }
}

- (NSMutableArray *)children {
  if (!_children) {
    _children = [NSMutableArray new];
  }
  return _children;
}

- (NSString *)description {
  if (self.children.count > 0) {
    return self.rawKey;
  }
  if ([self.rawKey containsString:@"array object"]) {
    return [NSString stringWithFormat:@"%@",self.rawValue];
  }
  if ([self.rawValue isKindOfClass:[NSArray class]] && [self.rawValue count] == 0) {
    return [NSString stringWithFormat:@"%@ : 0 elements", self.rawKey];
  }
  return [NSString stringWithFormat:@"%@ : %@",self.rawKey, self.rawValue];
}

- (id)jsonObject {
  switch (self.rawType) {
    case JSONTreeTypeKV:
      return self.rawValue;
    case JSONTreeTypeArray:{
      NSMutableArray *array = [NSMutableArray new];
      for (JSONTree *item in self.children) {
        [array addObject:[item jsonObject]];
      }
      return array;
    }
    case JSONTreeTypeDictionary:{
      NSMutableDictionary *dict = [NSMutableDictionary new];
      for (JSONTree *item in self.children) {
        [dict setObject:[item jsonObject] forKey:[item rawKey]];
      }
      return dict;
    }
    case JSONTreeTypeBatchArray:{
      NSMutableArray *array = [NSMutableArray new];
      for (JSONTree *item in self.children) {
        [array addObject:[item jsonObject]];
      }
      NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
      NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      return str;
    }
    case JSONTreeTypeBatchDictonary:{
      NSMutableDictionary *dict = [NSMutableDictionary new];
      for (JSONTree *item in self.children) {
        [dict setObject:[item jsonObject] forKey:[item rawKey]];
      }
      NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
      NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      return str;
    }
    default:
      break;
  }
  return nil;
}

- (NSString *)jsonTextWithPretty:(NSJSONWritingOptions)option {
  NSData *data;
  if (self.rawType == JSONTreeTypeArray || self.rawType == JSONTreeTypeDictionary) {
    data = [NSJSONSerialization dataWithJSONObject:[self jsonObject] options:option error:nil];
  }
  else {
    data = [NSJSONSerialization dataWithJSONObject:@{self.rawKey: [self jsonObject]} options:option error:nil];
  }
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  return string;
}
- (void)deleteNode:(JSONTree *)node parent:(JSONTree *)parent {
  if (!parent) {
    [self.children removeObject:node];
    return;
  }
  JSONTree *originNode = [self findNodeInChildren:node parent:parent];
  if (!originNode) {
    for (JSONTree * item in self.children) {
      [item deleteNode:node parent:parent];
    }
  }
  else {
    [self.children removeObject:originNode];
  }
  
}

- (JSONTree *)findNodeInChildren:(JSONTree *)node parent:(JSONTree *)parent {
  for (JSONTree *item in self.children) {
    if (item.rawType == node.rawType && [item.rawValue isEqual:node.rawValue] && [item.rawKey isEqualToString:node.rawKey] && [parent isEqual:self]) {
      return item;
    }
  }
  return nil;
}

@end
