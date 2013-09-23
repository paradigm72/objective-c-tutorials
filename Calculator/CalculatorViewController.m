//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController


//lazy instantiation
- (CalculatorBrain *)brain
{
	if (!brain) {
		brain = [[CalculatorBrain alloc] init];
	}
	return brain;
}

- (BOOL)containsDecimalPoint:(NSString *)stringToCheck
{
	NSRange range = [stringToCheck rangeOfString:@"."];
	if (range.location == NSNotFound) {
		return NO;
	}
	else {
		return YES;
	}
}

- (IBAction)digitPressed:(UIButton *)sender
{
	//get the digit from the text of the button
	NSString *digit = [[sender titleLabel] text];
	
	//if we're just adding digits, append to display delegate
	if (userIsInTheMiddleOfTypingANumber) {
		[display setText:[[display text] stringByAppendingString:digit]];
	}
	//otherwise, set the display delegate and set flag
	else {
		[display setText:digit];
		userIsInTheMiddleOfTypingANumber = YES;
	}
}

- (IBAction)decimalPointPressed
{
	//check whether we already have a decimal point
	if (userIsInTheMiddleOfTypingANumber && [self containsDecimalPoint:[display text]])
	{
		return;
	}
	else {
		//if we're just adding digits, append to display delegate
		if (userIsInTheMiddleOfTypingANumber) {
			[display setText:[[display text] stringByAppendingString:@"."]];
		}
		//otherwise, set the display delegate and set flag
		else {
			[display setText:@"."];
			userIsInTheMiddleOfTypingANumber = YES;
		}
	}
}

- (IBAction)operationPressed:(UIButton *)sender
{
	//if we were typing digits, and now hit an operator, go to waiting state
	if (userIsInTheMiddleOfTypingANumber) {
		[[self brain] setOperand:[[display text] doubleValue]];
		userIsInTheMiddleOfTypingANumber = NO;
	}
	NSError *myError;
	NSString *operation = [[sender titleLabel] text];

	double result = [[self brain] performOperation:operation
										 withError:&myError];
	if (myError.code == 0) {
		[errors setText:[myError localizedDescription]];
	}
	[display setText:[NSString stringWithFormat:@"%g", result]];
}

- (IBAction)clearAll
{
	[[self brain] clearAll];
	[display setText:nil];
	userIsInTheMiddleOfTypingANumber = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
