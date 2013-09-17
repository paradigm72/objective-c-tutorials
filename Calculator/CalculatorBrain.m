//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain
- (void)setOperand:(double)anOperand
{
	operand = anOperand;
}

- (void)performWaitingOperation
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
	}
}

- (double)performOperation:(NSString *)operation
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
		//how to raise an error?
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
		[self performWaitingOperation];
	}
	else {
		[self performWaitingOperation];
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


@end
