//
//  RSchemeBox.h
//  RScheme for Mac
//
//  Created by cuty-lewiwi on 12/17/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class RSchemeBox;

typedef void (^SignalChangedHandler)(NSString* signalName, RSchemeBox* box);

@interface RSchemeBox : NSBox<NSControlTextEditingDelegate, NSTextFieldDelegate>

@property (strong) IBOutlet NSTextField *titleTextField;
@property (strong) IBOutlet NSTextField *contentTextField;
@property (nonatomic, getter=isNumeric) BOOL numeric;
@property (strong) IBOutlet NSPanGestureRecognizer *panGestureRecognizer;
@property (strong) SignalChangedHandler handler;

+ (RSchemeBox *)newRSchemeBox;

- (id)initWithFrame:(NSRect)frameRect Handler:(SignalChangedHandler)handler;
- (IBAction)textChanged:(id)sender;

@end
