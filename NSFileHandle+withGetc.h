//
//  NSFileHandle+withGetc.h
//  RScheme for Mac
//
//  Created by cuty-lewiwi on 11/20/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileHandle (withGetc)
- (int) getc;
- (int) peek;
- (void) ungetc: (int) character;
//- (void) eatWhiteSpace;

- (void) printString: (NSString *)output;
@end
