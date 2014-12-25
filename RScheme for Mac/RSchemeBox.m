//
//  RSchemeBox.m
//  RScheme for Mac
//
//  Created by cuty-lewiwi on 12/17/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "RSchemeBox.h"

@interface RSchemeBox ()
@property (strong) IBOutlet NSButton* numericCheckBox;
@property (nonatomic) NSPoint origin;
@end

@implementation RSchemeBox

- (id)initWithFrame:(NSRect)frameRect Handler:(SignalChangedHandler)handler
{
    _handler = handler;
    self = [super initWithFrame:frameRect];
    if (self) {
        self.titlePosition = NSNoTitle;
        self.titleTextField = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(13, 69, 70, 22))];
        self.contentTextField = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(13, 37, 70, 22))];
        self.numericCheckBox = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(11, 8, 74, 18))];
        self.numericCheckBox.state = 1;
        [self.numericCheckBox setTarget:self];
        [self.numericCheckBox setAction:@selector(checkBoxClick:)];
        [self.numericCheckBox setButtonType:NSSwitchButton];
        self.panGestureRecognizer = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
        self.numeric = self.numericCheckBox.state;
        self.titlePosition = NSNoTitle;
        self.numericCheckBox.title = @"Numeric";
        [self addSubview:self.titleTextField];
        [self addSubview:self.contentTextField];
        [self addSubview:self.numericCheckBox];
        [self addGestureRecognizer:self.panGestureRecognizer];
        self.contentTextField.delegate = self;

    }
    return self;
}

- (IBAction)textChanged:(id)sender
{
    _handler(_titleTextField.stringValue, self);
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    // Drawing code here.
}

+ (RSchemeBox*)newRSchemeBox
{
    NSArray* array = @[];
    [[NSBundle mainBundle] loadNibNamed:@"RSchemeBox" owner:nil topLevelObjects:&array];
    //NSLog(@"%ld", array.count);
    return array.firstObject;
}

- (IBAction)checkBoxClick:(NSButton*)sender
{
    self.numeric = sender.state;
    NSLog(@"%d", self.isNumeric);
}

- (IBAction)dragging:(NSPanGestureRecognizer*)sender
{
    NSView* superView = self.superview;
    if (sender.state == NSGestureRecognizerStateBegan) {
        self.origin = sender.view.frame.origin;
    }
    else if (sender.state == NSGestureRecognizerStateChanged) {
        NSPoint offset = [sender translationInView:superView];
        sender.view.frame = NSRectFromCGRect(CGRectMake(self.origin.x + offset.x, self.origin.y + offset.y, sender.view.frame.size.width, sender.view.frame.size.height));
    }
    else if (sender.state == NSGestureRecognizerStateEnded) {
    }
}

-(void)controlTextDidChange:(NSNotification *)obj{
    _handler(_titleTextField.stringValue, self);
}

- (BOOL)control:(NSControl*)control textShouldEndEditing:(NSText*)fieldEditor
{
    _handler(_titleTextField.stringValue, self);
    return YES;
}
- (BOOL)control:(NSControl*)control textShouldBeginEditing:(NSText*)fieldEditor
{
    return YES;
}

@end
