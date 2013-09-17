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
	
	//note: nothing goes to brain on digit press
}
- (IBAction)operationPressed:(UIButton *)sender
{
	//if we were typing digits, and now hit an operator, go to waiting state
	if (userIsInTheMiddleOfTypingANumber) {
		[[self brain] setOperand:[[display text] doubleValue]];
		userIsInTheMiddleOfTypingANumber = NO;
	}
	NSString *operation = [[sender titleLabel] text];
	double result = [[self brain] performOperation:operation];
	[display setText:[NSString stringWithFormat:@"%g", result]];
}

- (IBAction)clearAll
{
	[[self brain] clearAll];
	[display setText:nil];
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
