//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphAndZoomViewController.h"
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
	
	//add the digit to the operand and the display
	[self refreshDisplay:digit];
	userIsInTheMiddleOfTypingANumber = YES;
	[self addDigitToInputBuffer:digit];
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
		//add the decimal point to the operand and the display
		[self refreshDisplay:@"."];
	}
	[self updateMemoryDisplay];
}

- (IBAction)binaryOperationPressed:(UIButton *)sender
{
	//filters out repeated presses of a binary operation, since there will not be two operands in that case
	//behavior of repeated presses for those is undefined
	if (!justPressedBinaryOperation)
	{
		[self operationPressed:sender];
		justPressedBinaryOperation = YES;
	}
}

- (IBAction)operationPressed:(UIButton *)sender
{
	//if we were typing digits, and now hit an operator, go to waiting state
	if (userIsInTheMiddleOfTypingANumber) {
		
		//*pmr++ 3/1/14 - I think this is wrong, because the variables come in via variablePressed
		//should never need to call setVariableAsOperand outside of that action
		/*if ([self inVariableMode])
		{
			//if we're in variable mode, append to expression
			[self.brain setVariableAsOperand:inputBuffer];
			inputBuffer = nil;
		}
		else
		{*/
			//otherwise, set as the operand
			if (inputBuffer != nil)
			{
				self.brain.operand = [inputBuffer doubleValue];
				inputBuffer = nil;
			}
		/*}*/
		userIsInTheMiddleOfTypingANumber = NO;
	}
	NSError *myError;
	myError = [[NSError alloc] init];

	NSString *operation = sender.titleLabel.text;

	[self.brain performOrAppendOperation:operation
					   withError:&myError];
	if (myError.code == DivideByZeroError) {
		errors.text = myError.localizedDescription;
	}
	
	//update the primary display to show the result, but only if not in "variable mode"
	if (![self inVariableMode])
	{
		display.text = [NSString stringWithFormat:@"%g", self.brain.operand];
	}
	else
	{
		//if we are in variable mode, update the display
		[self refreshDisplay:nil];
	}
	[self updateMemoryDisplay];
	[myError release];
}

- (IBAction)variablePressed:(UIButton *)sender
{
	[self.brain setVariableAsOperand:sender.titleLabel.text];
	userIsInTheMiddleOfTypingANumber = YES;
	[self refreshDisplay:nil];
	
	//since the memory display is not active in variable mode, need to update it now
	[self updateMemoryDisplay];
}

- (IBAction)evaluateTestExpressionPressed;
{
	//set up a dictionary of test values
	NSArray *objects = [NSArray arrayWithObjects:@"2", @"3", @"1.756", nil];
	NSArray *keys = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@x", VARIABLE_PREFIX],
											  [NSString stringWithFormat:@"%@a", VARIABLE_PREFIX],
											  [NSString stringWithFormat:@"%@b", VARIABLE_PREFIX],
											  nil];
	NSDictionary *testValues = [[NSDictionary alloc] initWithObjects:objects
															 forKeys:keys];
	
	//run the evaluation (class method)
	
	double evaluationResult = [CalculatorBrain evaluateExpression:[self.brain expression]
					usingVariableValues:testValues];
	display.text = [NSString stringWithFormat:@"%g", evaluationResult];
	
	//[objects release];  //why don't these require releasing? Because we didn't use "init..."?
	//[keys release];
	[testValues release];
	
	//once evaluation is done, clear the memory in the brain so that the next keypress will start a new workflow
	[self.brain clearAll];
}

- (IBAction)graphPressed
{
	GraphAndZoomViewController *myGVC = [[GraphAndZoomViewController alloc] init];
	myGVC.title = [CalculatorBrain descriptionOfExpression:[self.brain expression]];
	myGVC.expression = [self.brain expression];
	self.navigationController.navigationBarHidden = NO;
	[self.navigationController pushViewController:myGVC animated:YES];
	[myGVC release];
}

- (IBAction)clearAll
{
	[self.brain clearAll];
	display.text = nil;
	userIsInTheMiddleOfTypingANumber = NO;
	[self updateMemoryDisplay];
}


- (void)refreshDisplay:(NSString *)appendNewText
{
	//if we're in variable mode, refresh the expression in the primary display slot:
	if ([self inVariableMode]) {
		display.text = [CalculatorBrain descriptionOfExpression:[self.brain expression]];
	}
	
	//if we're just adding digits/decimalpoint, append to display delegate
	else if (userIsInTheMiddleOfTypingANumber) {
		display.text  = [display.text stringByAppendingString:appendNewText];
	}
	//otherwise, set the display delegate and set flag
	else {
		display.text = appendNewText;
	}
}

- (void)addDigitToInputBuffer:(NSString *)digitToAdd
{
	//for either mode, add the new text to the input buffer
	if (!(digitToAdd == nil))
	{
		if (!inputBuffer)
		{
			inputBuffer = [[NSMutableString alloc] initWithString:digitToAdd];
		}
		else
		{
			[inputBuffer appendString:digitToAdd];
		}
	}
}


- (BOOL)inVariableMode
{
	if ([self.brain expression] == nil)
	{
		return NO;
	}
	else
	{
		return ([[CalculatorBrain variablesInExpression:[self.brain expression]] count] > 0);
	}
}

- (void)updateMemoryDisplay
{
	//Only show anything for memory if we're not in 'variable mode'. Haven't yet defined what memory would mean
	//in that mode since we really only use the primary display.
	if ([self inVariableMode])
	{
		memoryContents.text = @"";
	}
	else
	{
		NSDictionary *myMemoryCopy = [self.brain exportMemory];
		NSString *composedMemory = myMemoryCopy[@"operand"];
		composedMemory = [composedMemory stringByAppendingString:@" "];
		composedMemory = [composedMemory stringByAppendingString:myMemoryCopy[@"waiting operation"]];
		memoryContents.text = composedMemory;
	}
	
	//since this is triggered after an action that causes the board state to advance (display should change), now accept a binary operator:
	justPressedBinaryOperation = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
	self.navigationController.navigationBarHidden = YES;
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
