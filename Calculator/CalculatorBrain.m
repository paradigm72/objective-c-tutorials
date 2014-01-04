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
	if (!internalExpression) { internalExpression = [[NSMutableArray alloc] init]; }
	[internalExpression addObject:[NSString stringWithFormat:@"%g", operand]];
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

- (double)performOrAppendOperation:(NSString *)operation withError:(NSError **)myError
{
	//throw the operation into the expression array in case we later switch to variable mode
	if (!internalExpression) { internalExpression = [[NSMutableArray alloc] init]; }
	if  (!([operation isEqual:@"="])) {   //if this is an equals sign, just skip it - has no meaning in an expression
		[internalExpression addObject:operation];
	}
	
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
	internalExpression = nil;
	[internalExpression release];
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
				[mutableSetOfVariables addObject:tempString];  //% marker is pulled out in the display
			}
		}
	}
	[mutableSetOfVariables autorelease];
	return mutableSetOfVariables;
}

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables
{
	//can we actually instantiate an instance of the class inside a class method?
	CalculatorBrain *myTempBrain = [[CalculatorBrain alloc] init];
	NSError *myError;
	myError = [[NSError alloc] init];
	
	//loop through the expression looking for variables
	for (id thisElement in anExpression) {
		if ([thisElement isKindOfClass:[NSString class]]) {
			NSString *thisElementAsString = [NSString stringWithString:thisElement];
			
			//if this is a variable,
			if ([thisElementAsString characterAtIndex:0] == '%') {    //TODO switch this over to the C constant
				//find the object in the dictionary that matches the key
				NSString *thisValue = [variables objectForKey:thisElementAsString];
				[myTempBrain setOperand:thisValue.doubleValue];
			}
			//if this is an operation,
			else
			{
				//actually perform it on our instance of the brain
				[myTempBrain performOrAppendOperation:thisElementAsString withError:&myError];
			}
		}
	}
	double returnValue = [myTempBrain operand];
	[myTempBrain release];
	return returnValue;
}

+ (NSString *)descriptionOfExpression:(id)anExpression
{
	NSString* composedDescription = [[NSString alloc] init];
	
	for (id expressionElement in anExpression) {
		//assuming that we can treat each id as an NSString...
		NSString* stringToAppend = [NSString stringWithString:expressionElement];
		
		//strip off the leading % character
		if ([stringToAppend characterAtIndex:0] == '%') {
			stringToAppend = [stringToAppend stringByReplacingOccurrencesOfString:@"%" withString:@""];
		}
		
		composedDescription = [composedDescription stringByAppendingString:stringToAppend];
		composedDescription	= [composedDescription stringByAppendingString:@" "];
	}
	//[composedDescription autorelease];  Do not auto-release this, it's an NSString which is immutable and auto-released already
	return composedDescription;
}

- (id) expression {
	NSMutableArray *expressionArrayCopy = [internalExpression copy];
	//[expressionArrayCopy autorelease];
	return expressionArrayCopy;
}

- (void) dealloc {
	[waitingOperation release];
	[internalExpression release];
	[super dealloc];
}


@end
