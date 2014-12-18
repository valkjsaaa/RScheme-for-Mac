//
//  RSchemeBox.h
//  RScheme for Mac
//
//  Created by cuty-lewiwi on 12/17/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSchemeBox : NSBox

@property (strong) IBOutlet NSTextField *titleTextField;
@property (strong) IBOutlet NSTextField *contentTextField;
@property (nonatomic, getter=isNumeric) BOOL numeric;
@property (strong) IBOutlet NSPanGestureRecognizer *panGestureRecognizer;

+ (RSchemeBox *)newRSchemeBox;

@end
