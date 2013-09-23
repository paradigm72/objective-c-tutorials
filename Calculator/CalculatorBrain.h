//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
{
	double operand;
	NSString *waitingOperation;
	double waitingOperand;
	double valueStoredInMemory;
	
}

- (void)setOperand:(double)anOperand;
- (double)performOperation:(NSString *)operation withError:(NSError **)myError;
- (void)clearAll;

@end