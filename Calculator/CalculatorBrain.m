//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import "CalculatorBrain.h"
#define VARIABLE_PREFIX @"%"

@implementation CalculatorBrain
//@synthesize operand;

- (void)setOperand:(double)operand
{
	//throw the operand into the expression array in case we later switch to variable mode
	[internalExpression addObject:[NSNumber numberWithDouble:operand]];
	internalOperand = operand;
}
- (double)operand
{
	return internalOperand;
}

- (void)performWaitingOperation:(NSError *)myError
{
	if ([@"+" isEqual:waitingOperation]) {
		internalOperand = waitingOperand + internalOperand;
	} else if ([@"-" isEqual:waitingOperation]) {
		internalOperand = waitingOperand - internalOperand;
	} else if ([@"*" isEqual:waitingOperation]) {
		internalOperand = waitingOperand * internalOperand;
	} else if ([@"/" isEqual:waitingOperation]) {
		if (internalOperand) {
			internalOperand = waitingOperand / internalOperand;
		}
		else {
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Tried to divide by zero"};
			myError = [NSError errorWithDomain:CalculatorErrorDomain
										  code:DivideByZeroError
									  userInfo:userInfo];
		}
	}
}

- (double)performOperation:(NSString *)operation withError:(NSError **)myError
{
	//throw the operation into the expression array in case we later switch to variable mode
	[internalExpression addObject:operation];
	
	if ([operation isEqual:@"sqrt(x)"]) {
		internalOperand = sqrt(internalOperand);
	}
	else if ([operation isEqual:@"x^2"]) {
		internalOperand = internalOperand * internalOperand;
	}
	else if ([operation isEqual:@"1/x"]) {
		if (internalOperand) {
			internalOperand = 1 / internalOperand;
		}
		else {
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Tried to divide by zero"};
			*myError = [NSError errorWithDomain:CalculatorErrorDomain
										   code:DivideByZeroError
									   userInfo:userInfo];
		}

	}
	else if ([operation isEqual:@"STORE"]) {
		valueStoredInMemory = internalOperand;
	}
	else if ([operation isEqual:@"RECALL"]) {
		internalOperand = valueStoredInMemory;
	}
	else if ([operation isEqual:@"MEM +"]) {
		waitingOperation = @"+";
		waitingOperand = valueStoredInMemory;
		[self performWaitingOperation:*myError];
	}
	else {
		[self performWaitingOperation:*myError];
		waitingOperation = operation;
		waitingOperand = internalOperand;
	}
	return internalOperand;
}

- (void)clearAll
{
	internalOperand = 0.0;
	waitingOperation = nil;
	waitingOperand = 0.0;
	valueStoredInMemory = 0.0;
}

- (NSDictionary *)exportMemory
{
	if (((internalOperand != 0.0) || (waitingOperand != 0.0)) && (waitingOperation != nil)) {
		NSDictionary *myMemoryContents = [[NSDictionary alloc] initWithObjectsAndKeys:
										  [NSString stringWithFormat:@"%g", internalOperand], @"operand",
										  [NSString stringWithFormat:@"%g", waitingOperand], @"waiting operand",
										  [NSString stringWithString:waitingOperation], @"waiting operation",
										  nil];

		return myMemoryContents;
	}
	return nil;
}

- (void)setVariableAsOperand:(NSString *)variableName
{
	NSString *stringForVariableOperand = VARIABLE_PREFIX;
	stringForVariableOperand = [stringForVariableOperand stringByAppendingString:variableName];
	//add this operand to the NSMutableArray representing our experession so far
	if (!internalExpression) { internalExpression = [[NSMutableArray alloc] init]; }
	[internalExpression addObject:stringForVariableOperand];
}

+ (NSSet *)variablesInExpression:(id)anExpression
{
	NSMutableSet *mutableSetOfVariables = [[NSMutableSet alloc] init];
	
	for (id thisElement in anExpression) {
		if ([thisElement isKindOfClass:[NSString class]]) {
			NSString *tempString = [NSString stringWithString:thisElement];
			if ([tempString characterAtIndex:0] == '%') {
				[mutableSetOfVariables addObject:tempString];
			}
		}
	}
	[mutableSetOfVariables autorelease];
	return mutableSetOfVariables;
}

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables
{
	//TODO return the value of the evaluation
	return 0.0;
}

+ (NSString *)descriptionOfExpression:(id)anExpression
{
	NSString* composedDescription = [[NSString alloc] init];
	
	for (id expressionElement in anExpression) {
		//assuming that we can treat each id as an NSString...
		composedDescription = [composedDescription stringByAppendingString:expressionElement];
		composedDescription	= [composedDescription stringByAppendingString:@" "];
	}
	[composedDescription autorelease];
	return composedDescription;
}

- (id) expression {
	NSMutableArray *expressionArrayCopy = [internalExpression copy];
	[expressionArrayCopy autorelease];
	return expressionArrayCopy;
}

- (void) dealloc {
	[waitingOperation release];
	[internalExpression release];
	[super dealloc];
}


@end
