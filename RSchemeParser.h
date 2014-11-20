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

- (instancetype)initWithFileHandle:(NSFileHandle*)output;

- (void)parse:(NSString*)string error:(NSError**)error;

@end

/***************************** REPL ******************************/
//
//int main(void) {
//    RSObject *exp;
//
//    printf("Welcome to Bootstrap Scheme. "
//           "Use ctrl-c to exit.\n");
//
//    init();
//
//    while (1) {
//        printf("> ");
//        exp = read(stdin);
//        if (exp == NULL) {
//            break;
//        }
//        write(stdout, eval(exp, the_global_environment));
//        printf("\n");
//    }
//
//    printf("Goodbye\n");
//
//    return 0;
//}