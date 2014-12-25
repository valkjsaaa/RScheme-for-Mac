//
//  RSchemeParser.m
//  RScheme for Mac
//
//  Created by Jackie Yang on 11/1/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "RSchemeParser.h"
#import "MessageBlocks.h"

@interface RSchemeParser ()

@property NSMutableString* output;

@property NSMutableArray* all_expression;

@end

@implementation RSchemeParser

- (instancetype)initWithFileHandle:(NSMutableString*)output
{
    self = [super init];
    if (self) {
        _output = [NSMutableString new];
        _output = output;
        RSObject* the_global_environment;
        init(output, &the_global_environment);
        _the_global_environment = the_global_environment;
        tmpRSObjectRetainedBuffer = [[NSMutableArray alloc] init];
        _all_expression = [NSMutableArray new];
    }
    return self;
}

- (void)parse:(NSString*)string error:(NSError* __autoreleasing*)error
{
    //RSObject* _exp = _read([string mutableCopy]);
    //RSObject* result = eval(_exp, _the_global_environment);
    //_write(_output, result);
    changedSignal = [NSMutableSet new];
    YY_BUFFER_STATE buf;
    buf = yy_scan_string(string.UTF8String);
    //outputString = _output;
    //env = _the_global_environment;
    //YYParserParams* params = [[YYParserParams alloc] initWithOut:_output Env:_the_global_environment];
    //yyparse(params);
    NSMutableArray* expressions = [[NSMutableArray alloc] init];
    yyparse(&expressions);
    [_all_expression addObjectsFromArray:expressions];
    for (RSObject* obj in expressions) {
#ifdef DEBUG
        NSLog(@"%@", obj);
#endif
        RSObject* result = eval(obj, _the_global_environment);
        _write(_output, result);
        [self propagate];
    }
    //yyparse();
    yy_delete_buffer(buf);
}

- (void)propagate
{
    while (changedSignal.count) {
        RSObject* currentSignal = [changedSignal anyObject];
        [changedSignal removeObject:currentSignal];
        for (RSObject* obj2 in _all_expression) {
            if ([obj2.sensitiveSignals containsObject:currentSignal]) {
                RSObject* result = eval(obj2, _the_global_environment);
                _write(_output, result);
            }
        }
    }
}

- (void)parseMultiline:(NSString*)string error:(NSError* __autoreleasing*)error
{
    //    NSUInteger i = 0;
    //    NSUInteger bracket_count = 0;
    //    //BOOL hasInput = NO;
    //    NSUInteger start = 0;
    //    NSUInteger length = string.length;
    //    while (i < length){
    //        if ([string characterAtIndex:i] == '('){
    //            bracket_count++;
    //            if (bracket_count == 1){
    //                start = i;
    //            }
    //        }
    //        else if ([string characterAtIndex:i] == ')'){
    //            bracket_count--;
    //            if (!bracket_count){
    //                NSString *parseLine = [string substringWithRange:NSMakeRange(start, i-start+1)];
    //#ifdef DEBUG
    //                NSLog(@"%@", parseLine);
    //#endif
    //                [self parse:parseLine error:error];
    //            }
    //        }
    //        i++;
    //    }
    [self parse:string error:error];
}

@end
