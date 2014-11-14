//
//  RSchemeParser.h
//  RScheme for Mac
//
//  Created by Jackie Yang on 11/1/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "RSSchemeParserInternal.h"
@import Cocoa;
@import Foundation;

@interface RSchemeParser : NSObject

- (instancetype)init;

- (void)parse:(NSString*)string error:(NSError**)error;

@end
