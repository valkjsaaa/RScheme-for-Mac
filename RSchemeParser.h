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

typedef void (^ObjectChangeCallback)(NSString*);

@interface RSchemeParser : NSObject

- (instancetype)initWithFileHandle:(NSMutableString*)output;

//- (instancetype)initWithFileHandle:(NSMutableString*)output callback:(ObjectChangeCallback)callback;

- (void)parseMultiline:(NSString*)string error:(NSError**)error;

- (void)parse:(NSString*)string error:(NSError**)error;

//- (void)watch:(NSString*)name;

//- (void)setSignal:(id)value forKey:(NSString*)key;

- (void)propagate;

@property (strong) RSObject* the_global_environment;

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