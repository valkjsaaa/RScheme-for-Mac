//
//  ViewController.m
//  RScheme for Mac
//
//  Created by Jackie Yang on 11/1/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "ViewController.h"
#import "RSchemeParser.h"
#import "y.tab.h"
#import "MessageBlocks.h"
#import "RSchemeBox.h"

#define OUTPUTLINE

@interface ViewController ()
@property (strong, nonatomic) RSchemeParser* parser;
@property (strong, nonatomic) NSMutableString* output;

@property (nonatomic) NSPoint origin;

@property (strong) IBOutlet NSTextView* inputTextField;
@property (strong) IBOutlet NSTextView* outputTextView;
@property (nonatomic) NSUInteger nextParseHeadIndex;
//@property (nonatomic) NSUInteger nextResultHeadIndex;
@property (strong) IBOutlet NSView* GUIView;
@property NSMutableArray* boxArray;
@property BOOL isLocked;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.output = [[NSMutableString alloc] initWithString:@""];
    self.parser = [[RSchemeParser alloc] initWithFileHandle:self.output];
    self.nextParseHeadIndex = 0;
    _boxArray = [NSMutableArray new];
    RSchemeBox* test = [RSchemeBox newRSchemeBox];
    //test.frame = NSRectFromCGRect(CGRectMake(10, 10, 108, 109));
    //self.nextResultHeadIndex = 0;
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)test
{
    //NSString *str = [NSString stringWithUTF8String:yytext+2]
}

#pragma mark - IBActions

- (IBAction)dragging:(NSPanGestureRecognizer*)sender
{
    //NSLog(@"dragging");
    if (sender.state == NSGestureRecognizerStateBegan) {
        self.origin = sender.view.frame.origin;
    }
    else if (sender.state == NSGestureRecognizerStateChanged || sender.state == NSGestureRecognizerStateEnded) {
        NSPoint offset = [sender translationInView:self.GUIView];
        sender.view.frame = NSRectFromCGRect(CGRectMake(self.origin.x + offset.x, self.origin.y + offset.y, sender.view.frame.size.width, sender.view.frame.size.height));
    }
}

- (IBAction)addRschemeBoxView:(id)sender
{
    //RSchemeBox *newBox = [RSchemeBox newRSchemeBox];
    RSchemeBox* newBox = [[RSchemeBox alloc] initWithFrame:NSRectFromCGRect(CGRectMake(10, 10, 108, 109)) Handler:^(NSString* signalName, RSchemeBox* box) {
        RSObject*signal =make_symbol([@"$" stringByAppendingString:signalName]);
        signal.isSignal = YES;
        RSObject* signalVal = lookup_variable_value(signal,_parser.the_global_environment);
        if (signalVal) {
            if (box.isNumeric) {
                RSObject * newSignal;
                long long temp1;
                double temp2;
                
                NSScanner* scanner = [NSScanner scannerWithString:box.contentTextField.stringValue];
                [scanner scanLongLong:&temp1];
                if (box.contentTextField.stringValue.length<=[scanner scanLocation] || [box.contentTextField.stringValue characterAtIndex:[scanner scanLocation]] != '.') {
                    newSignal = make_fixnum(temp1);
                }
                else {
                    scanner = [NSScanner scannerWithString:box.contentTextField.stringValue];
                    [scanner scanDouble:&temp2];
                    newSignal =  make_floatnum(temp2);
                }
                set_variable_value(signal, newSignal, [_parser the_global_environment]);
            }else{
                RSObject * newSignal;
                newSignal = make_string(box.contentTextField.stringValue);
                set_variable_value(signal, newSignal, [_parser the_global_environment]);

            }
            [_output setString:@""];
            [_parser propagate];
            [self appendOutput:_output cause:@"-From GUI\n"];
            [self updateUISignals];
        }
    }];
    //newBox.frame = NSRectFromCGRect(CGRectMake(10, 10, 108, 109));
    newBox.titleTextField.stringValue = @"";
    [self.GUIView addSubview:newBox];
    [_boxArray addObject:newBox];
}

- (IBAction)parseButtonClicked:(NSButton*)sender
{
    //NSString *parseString = [self.inputTextField.string substringFromIndex:self.nextParseHeadIndex];
    NSString* parseString = self.inputTextField.string;
//self.nextParseHeadIndex = self.inputTextField.string.length;
#ifdef DEBUG
    NSLog(@"%@", parseString);
#endif
    [self.output setString:@""];
    //[self.parser parseMultiline:parseString error:nil];
    [self.parser parse:parseString error:nil];
#ifdef DEBUG
    NSLog(@"%@", self.output);
#endif
    NSMutableString* statements = [NSMutableString new];
    for (NSString* line in [parseString componentsSeparatedByString:@"\n"]) {
        [statements appendString:[NSString stringWithFormat:@">%@\n", line]];
    }
    [self appendOutput:self.output cause:statements];
    [self.inputTextField selectAll:self];
    [self updateUISignals];
}

- (void)appendOutput:(NSString*)output cause:(NSString*)cause
{
    NSString* currentString = self.outputTextView.string;
    NSString* currentStatement = [NSString stringWithFormat:@"%@%@\n", cause, output];
    self.outputTextView.string = [currentString stringByAppendingString:currentStatement];
}

- (IBAction)LockClicked:(id)sender
{
    _isLocked = !_isLocked;
}

- (void)updateUISignals
{
    for (RSchemeBox* box in _boxArray) {
        RSObject* signal = make_symbol([@"$" stringByAppendingString:box.titleTextField.stringValue]);
        signal.isSignal = YES;
        RSObject* signalVal = lookup_variable_value(signal, _parser.the_global_environment);
        if (signalVal) {
            if (signalVal.type == STRING) {
                box.contentTextField.stringValue = signalVal.data.string.value;
            }
            else if (signalVal.type == FLOATNUM) {
                box.contentTextField.stringValue = [NSString stringWithFormat:@"%f", signalVal.data.floatnum.value];
            }
            else if (signalVal.type == FIXNUM) {
                box.contentTextField.stringValue = [NSString stringWithFormat:@"%ld", signalVal.data.fixnum.value];
            }
            else {
                box.contentTextField.stringValue = @"N/A";
            }
        }
    }
}

@end
