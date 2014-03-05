//
//  GraphAndZoomViewController.m
//  GraphingCalculator
//
//  Created by Paul Romine on 3/1/14.
//  Copyright (c) 2014 Paul Romine. All rights reserved.
//

#import "GraphAndZoomViewController.h"
#define VARIABLE_PREFIX @"%"

@interface GraphAndZoomViewController ()

@end

@implementation GraphAndZoomViewController
@synthesize myGraphZoomView;

#pragma delegate
- (float)scaleForView:(GraphAndZoomView *)requestor
{
	return self.scale;
}

- (float)Yvalue:(GraphAndZoomView *)requestor forXValue:(float)xValue
{
	//insert our current value for x as the test value for expression evaluation
	NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithFloat:xValue], nil];
	NSArray *keys = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@x", VARIABLE_PREFIX], nil];
	NSDictionary *testValues = [[NSDictionary alloc] initWithObjects:objects
															 forKeys:keys];
	
	//evaluate the expression (determing the y value) and return it to the view
	return [CalculatorBrain evaluateExpression:self.expression usingVariableValues:testValues];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.scale = 14;
	self.myGraphZoomView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBActions
- (IBAction)scaleUp
{
	self.scale = self.scale / 2;
	[self.view setNeedsDisplay];
}

- (IBAction)scaleDown
{
	self.scale = self.scale * 2;
	[self.view setNeedsDisplay];
}

@end
