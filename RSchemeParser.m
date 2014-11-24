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

@property NSMutableString* output;

@property RSObject* exp;

@end

@implementation RSchemeParser

- (instancetype)initWithFileHandle:(NSMutableString*)output
{
    self = [super init];
    if (self) {
        _output = [NSMutableString new];
        _output = output;
        init(output);
    }
    return self;
}

- (void)parse:(NSString*)string error:(NSError* __autoreleasing*)error
{
    _exp = _read([string mutableCopy]);
    RSObject* result = eval(_exp, the_global_environment);
    _write(_output, result);
}

- (void)parseMultiline: (NSString *)string error: (NSError * __autoreleasing*)error
{
    NSUInteger i = 0;
    NSUInteger bracket_count = 0;
    //BOOL hasInput = NO;
    NSUInteger start = 0;
    NSUInteger length = string.length;
    while (i < length){
        if ([string characterAtIndex:i] == '('){
            bracket_count++;
            if (bracket_count == 1){
                start = i;
            }
        }
        else if ([string characterAtIndex:i] == ')'){
            bracket_count--;
            if (!bracket_count){
                NSString *parseLine = [string substringWithRange:NSMakeRange(start, i-start+1)];
#ifdef DEBUG
                NSLog(@"%@", parseLine);
#endif
                [self parse:parseLine error:error];
            }
        }
        i++;
    }
}

@end
