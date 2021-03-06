//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Paul Romine on 9/15/13.
//  Copyright (c) 2013 Paul Romine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"


@interface CalculatorViewController : UIViewController
{
	IBOutlet UILabel *display;
	IBOutlet UILabel *errors;
	IBOutlet UILabel *memoryContents;
	CalculatorBrain *brain;
	BOOL userIsInTheMiddleOfTypingANumber;
	BOOL justPressedBinaryOperation;
}

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)binaryOperationPressed:(UIButton *)sender;
- (IBAction)setVariableAsOperand:(UIButton *)sender;
- (IBAction)evaluateTestExpressionPressed;
- (IBAction)decimalPointPressed;
- (IBAction)clearAll;

@end
