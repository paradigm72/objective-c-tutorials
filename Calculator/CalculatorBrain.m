//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import "CalculatorBrain.h"
#import "CalculatorErrors.h"
#import <Foundation/Foundation.h>

@implementation CalculatorBrain
@synthesize operand;

- (void)performWaitingOperation:(NSError **)myError
{
	if ([@"+" isEqual:waitingOperation]) {
		operand = waitingOperand + operand;
	} else if ([@"-" isEqual:waitingOperation]) {
		operand = waitingOperand - operand;
	} else if ([@"*" isEqual:waitingOperation]) {
		operand = waitingOperand * operand;
	} else if ([@"/" isEqual:waitingOperation]) {
		if (operand) {
			operand = waitingOperand / operand;
		}
		else {
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Tried to divide by zero"};
			*myError = [NSError errorWithDomain:CalculatorErrorDomain
										  code:DivideByZeroError
									  userInfo:userInfo];
		}
	}
}

- (double)performOperation:(NSString *)operation withError:(NSError **)myError
{
	if ([operation isEqual:@"sqrt(x)"]) {
		operand = sqrt(operand);
	}
	else if ([operation isEqual:@"x^2"]) {
		operand = operand * operand;
	}
	else if ([operation isEqual:@"1/x"]) {
		if (operand) {
			operand = 1 / operand;
		}
		else {
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Tried to divide by zero"};
			*myError = [NSError errorWithDomain:CalculatorErrorDomain
												 code:DivideByZeroError
											 userInfo:userInfo];
		}

	}
	else if ([operation isEqual:@"STORE"]) {
		valueStoredInMemory = operand;
	}
	else if ([operation isEqual:@"RECALL"]) {
		operand = valueStoredInMemory;
	}
	else if ([operation isEqual:@"MEM +"]) {
		waitingOperation = @"+";
		waitingOperand = valueStoredInMemory;
		[self performWaitingOperation:myError];
	}
	else {
		[self performWaitingOperation:myError];
		waitingOperation = operation;
		waitingOperand = operand;
	}
	return operand;
}

- (void)clearAll
{
	operand = 0.0;
	waitingOperation = nil;
	waitingOperand = 0.0;
	valueStoredInMemory = 0.0;
}

- (NSDictionary *)exportMemory
{
	if (((operand != 0.0) || (waitingOperand != 0.0)) && (waitingOperation != nil)) {
		NSDictionary *myMemoryContents = [[NSDictionary alloc] initWithObjectsAndKeys:
										  [NSString stringWithFormat:@"%g", operand], @"operand",
										  [NSString stringWithFormat:@"%g", waitingOperand], @"waiting operand",
										  [NSString stringWithString:waitingOperation], @"waiting operation",
										  nil];

		return myMemoryContents;
	}
	return nil;
}


@end
