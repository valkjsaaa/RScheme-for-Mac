//
//  NSFileHandle+withGetc.m
//  RScheme for Mac
//
//  Created by cuty-lewiwi on 11/20/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "NSFileHandle+withGetc.h"

@implementation NSFileHandle (withGetc)

- (void)printString:(NSString*)output
{
    NSData* outputData = [output dataUsingEncoding:NSUTF8StringEncoding];
    [self writeData:outputData];
}

- (int)peek
{
    unsigned long long offset = self.offsetInFile;
    int ret = [self getc];
    [self seekToFileOffset:offset];
    return ret;
}

- (int)getc
{
    @try {
        NSData* data = [self readDataOfLength:1];
        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return [str characterAtIndex:0];
    }
    @catch (NSException* exception)
    {
        return EOF;
    }
}

- (void)ungetc:(int)character
{
    size_t offset = self.offsetInFile;
    NSData* oldData = [self readDataToEndOfFile];
    NSString* oldStr = [[NSString alloc] initWithData:oldData encoding:NSUTF8StringEncoding];
    NSString* newStr = [NSString stringWithFormat:@"%c%@", character, oldStr];
    NSData* newData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
    [self seekToFileOffset:offset];
    [self writeData:newData];
    [self seekToFileOffset:offset];
}

@end
