//
//  RSchemeParser.m
//  RScheme for Mac
//
//  Created by Jackie Yang on 11/1/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "RSchemeParser.h"

//hahahahah

@interface RSchemeParser ()

@property NSFileHandle* output;

@property RSObject* exp;

@end

@implementation RSchemeParser

- (instancetype)initWithFileHandle:(NSFileHandle*)output
{
    self = [super init];
    if (self) {
        _output = output;
        init();
    }
    return self;
}

- (void)parse:(NSString*)string error:(NSError* __autoreleasing*)error
{
    NSFileHandle * temp = [NSFileHandle fileHandleForWritingAtPath:@"/Users/Jackie/Downloads/temp_RScheme"];
    [temp writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    temp = [NSFileHandle fileHandleForReadingAtPath:@"/Users/Jackie/Downloads/temp_RScheme"];
    _exp = _read(temp);
    _write(_output, eval(_exp, the_global_environment));
}

@end
