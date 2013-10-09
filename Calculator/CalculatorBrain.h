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
	NSString *waitingOperation;
	double waitingOperand;
	double valueStoredInMemory;
}

@property double operand;
- (double)performOperation:(NSString *)operation withError:(NSError **)myError;
- (NSDictionary *)exportMemory;
- (void)clearAll;

@end
