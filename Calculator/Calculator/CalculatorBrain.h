//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorErrors.h"

@interface CalculatorBrain : NSObject
{
	NSString *waitingOperation;
	double waitingOperand;
	double valueStoredInMemory;
	double internalOperand;
	NSMutableArray *internalExpression;
}

@property double operand;
@property (readonly) id expression;

- (void)setVariableAsOperand:(NSString *)variableName;
- (double)performOrAppendOperation:(NSString *)operation withError:(NSError **)myError;
- (NSDictionary *)exportMemory;
- (void)clearAll;

+ (double)evaluateExpression:(id)anExpression
		 usingVariableValues:(NSDictionary *)variables;
+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;
//+ (id)propertyListForExpression:(id)anExpression;
//+ (id)expressionForPropertyList:(id)propertyList;


@end
