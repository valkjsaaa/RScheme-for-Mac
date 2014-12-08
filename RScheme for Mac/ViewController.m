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

- (void)test{
    //NSString *str = [NSString stringWithUTF8String:yytext+2]
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
}

@end
