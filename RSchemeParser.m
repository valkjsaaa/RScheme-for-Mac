//
//  RSchemeParser.m
//  RScheme for Mac
//
//  Created by Jackie Yang on 11/1/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "RSchemeParser.h"

@interface RSchemeParser ()

@property NSMutableString* output;

@property (strong) RSObject* the_global_environment;

@end

@implementation RSchemeParser

- (instancetype)initWithFileHandle:(NSMutableString*)output
{
    self = [super init];
    if (self) {
        _output = [NSMutableString new];
        _output = output;
        RSObject *the_global_environment;
        init(output, &the_global_environment);
        _the_global_environment = the_global_environment;
    }
    return self;
}

- (void)parse:(NSString*)string error:(NSError* __autoreleasing*)error
{
    RSObject* _exp = _read([string mutableCopy]);
    RSObject* result = eval(_exp, _the_global_environment);
    _write(_output, result);
}

@end
