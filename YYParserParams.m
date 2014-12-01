//
//  YYParserParams.m
//  RScheme for Mac
//
//  Created by cuty-lewiwi on 12/2/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "YYParserParams.h"

@implementation YYParserParams

- (instancetype)initWithOut:(NSMutableString *)output Env:(RSObject *)env
{
    if (self = [super init]){
        self.output = output;
        self.env = env;
    }
    return self;
}

@end
