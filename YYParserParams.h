//
//  YYParserParams.h
//  RScheme for Mac
//
//  Created by cuty-lewiwi on 12/2/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYParserParams : NSObject
@property (strong, nonatomic) NSMutableString *output;
@property (strong, nonatomic) RSObject *env;

- (instancetype) initWithOut: (NSMutableString *)output Env: (RSObject *)env;
@end
