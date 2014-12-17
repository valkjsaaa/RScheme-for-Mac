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
@property (strong, nonatomic) RSchemeParser *parser;
@property (strong, nonatomic) NSMutableString *output;

@property (nonatomic) NSPoint origin;

@property (strong) IBOutlet NSTextView *inputTextField;
@property (strong) IBOutlet NSTextView *outputTextView;
@property (nonatomic) NSUInteger nextParseHeadIndex;
//@property (nonatomic) NSUInteger nextResultHeadIndex;
@property (strong) IBOutlet NSView *GUIView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.output = [[NSMutableString alloc] initWithString:@""];
    self.parser = [[RSchemeParser alloc] initWithFileHandle:self.output];
    self.nextParseHeadIndex = 0;
    RSchemeBox *test = [RSchemeBox newRSchemeBox];
    //test.frame = NSRectFromCGRect(CGRectMake(10, 10, 108, 109));
    //self.nextResultHeadIndex = 0;
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)test{
    //NSString *str = [NSString stringWithUTF8String:yytext+2]
}

#pragma mark - IBActions

- (IBAction)dragging:(NSPanGestureRecognizer *)sender
{
    //NSLog(@"dragging");
    if (sender.state == NSGestureRecognizerStateBegan){
        self.origin = sender.view.frame.origin;
    }
    else if (sender.state == NSGestureRecognizerStateChanged || sender.state == NSGestureRecognizerStateEnded){
        NSPoint offset = [sender translationInView:self.GUIView];
        sender.view.frame = NSRectFromCGRect(CGRectMake(self.origin.x+offset.x, self.origin.y+offset.y, sender.view.frame.size.width, sender.view.frame.size.height));
    }
}

- (IBAction)addRschemeBoxView:(id)sender
{
    //RSchemeBox *newBox = [RSchemeBox newRSchemeBox];
    RSchemeBox *newBox = [[RSchemeBox alloc] initWithFrame:NSRectFromCGRect(CGRectMake(10, 10, 108, 109))];
    //newBox.frame = NSRectFromCGRect(CGRectMake(10, 10, 108, 109));
    newBox.titleTextField.stringValue = @"haha";
    [self.GUIView addSubview:newBox];
}


- (IBAction)parseButtonClicked:(NSButton *)sender
{
    //NSString *parseString = [self.inputTextField.string substringFromIndex:self.nextParseHeadIndex];
    NSString *parseString = self.inputTextField.string;
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
    self.outputTextView.string = self.output;
    [self.inputTextField selectAll:self];
}

@end
