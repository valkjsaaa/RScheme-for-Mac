//
//  ViewController.m
//  RScheme for Mac
//
//  Created by Jackie Yang on 11/1/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import "ViewController.h"
#import "RSchemeParser.h"

#define OUTPUTLINE

@interface ViewController ()
@property (strong, nonatomic) RSchemeParser *parser;
@property (strong, nonatomic) NSMutableString *output;

@property (strong) IBOutlet NSTextView *inputTextField;
@property (strong) IBOutlet NSTextView *outputTextView;
@property (nonatomic) NSUInteger nextParseHeadIndex;
//@property (nonatomic) NSUInteger nextResultHeadIndex;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.output = [[NSMutableString alloc] initWithString:@""];
    self.parser = [[RSchemeParser alloc] initWithFileHandle:self.output];
    self.nextParseHeadIndex = 0;
    //self.nextResultHeadIndex = 0;
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)parseButtonClicked:(NSButton *)sender
{
    NSString *parseString = [self.inputTextField.string substringFromIndex:self.nextParseHeadIndex];
    self.nextParseHeadIndex = self.inputTextField.string.length;
#ifdef DEBUG
    NSLog(@"%@", parseString);
#endif
    [self.output setString:@""];
    [self.parser parseMultiline:parseString error:nil];
#ifdef DEBUG
    NSLog(@"%@", self.output);
#endif
#ifdef OUTPUTLINE
    self.outputTextView.string = [self.outputTextView.string stringByAppendingFormat:@"%@\n", self.output];
#else
    self.outputTextView.string = [self.outputTextView.string stringByAppendingString:self.output];
#endif
}

@end
