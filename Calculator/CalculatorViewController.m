//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import "CalculatorViewController.h"
#define VARIABLE_PREFIX @"%"

@interface CalculatorViewController()
@property (readonly) CalculatorBrain *brain;
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
	NSString *digit = sender.titleLabel.text;
	
	//if we're just adding digits, append to display delegate
	if (userIsInTheMiddleOfTypingANumber) {
		display.text = [display.text stringByAppendingString:digit];
	}
	//otherwise, set the display delegate and set flag
	else {
		display.text = digit;
		userIsInTheMiddleOfTypingANumber = YES;
	}
	[self updateMemoryDisplay];
}

- (IBAction)decimalPointPressed
{
	//check whether we already have a decimal point
	if (userIsInTheMiddleOfTypingANumber && [self containsDecimalPoint:display.text])
	{
		return;
	}
	else {
		//if we're just adding digits, append to display delegate
		if (userIsInTheMiddleOfTypingANumber) {
			display.text  = [display.text stringByAppendingString:@"."];
		}
		//otherwise, set the display delegate and set flag
		else {
			display.text = @".";
			userIsInTheMiddleOfTypingANumber = YES;
		}
	}
	[self updateMemoryDisplay];
}

- (IBAction)operationPressed:(UIButton *)sender
{
	//if we were typing digits, and now hit an operator, go to waiting state
	if (userIsInTheMiddleOfTypingANumber) {
		self.brain.operand = display.text.doubleValue;
		userIsInTheMiddleOfTypingANumber = NO;
	}
	NSError *myError;
	myError = [[NSError alloc] init];

	NSString *operation = sender.titleLabel.text;

	[self.brain performOperation:operation
					   withError:&myError];
	if (myError.code == DivideByZeroError) {
		errors.text = myError.localizedDescription;
	}
	display.text = [NSString stringWithFormat:@"%g", self.brain.operand];
	[self updateMemoryDisplay];
	[myError release];
}

- (IBAction)setVariableAsOperand:(UIButton *)sender
{
	[self.brain setVariableAsOperand:sender.titleLabel.text];
}

- (IBAction)evaluateTestExpressionPressed;
{
	//set up a dictionary of test values
	NSArray *objects = [NSArray arrayWithObjects:@"2", @"3", @"1.756", nil];
	NSArray *keys = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@x", VARIABLE_PREFIX],
											  [NSString stringWithFormat:@"%@x", VARIABLE_PREFIX],
											  [NSString stringWithFormat:@"%@x", VARIABLE_PREFIX],
											  nil];
	NSDictionary *testValues = [[NSDictionary alloc] initWithObjects:objects
															 forKeys:keys];
	
	//run the evaluation (class method)
	[CalculatorBrain evaluateExpression:[self.brain expression]
					usingVariableValues:testValues];
	
	[objects release];
	[keys release];
	[testValues release];
}

- (IBAction)clearAll
{
	[self.brain clearAll];
	display.text = nil;
	userIsInTheMiddleOfTypingANumber = NO;
}

- (void)updateMemoryDisplay
{
	NSDictionary *myMemoryCopy = [self.brain exportMemory];
	NSString *composedMemory = myMemoryCopy[@"operand"];
	composedMemory = [composedMemory stringByAppendingString:myMemoryCopy[@"waiting operation"]];
	memoryContents.text = composedMemory;
	
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

- (void)dealloc
{
	[brain release];
	[super dealloc];
}

@end
