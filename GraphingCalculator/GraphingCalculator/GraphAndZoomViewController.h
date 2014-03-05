//
//  GraphAndZoomViewController.h
//  GraphingCalculator
//
//  Created by Paul Romine on 3/1/14.
//  Copyright (c) 2014 Paul Romine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphAndZoomView.h"
#import "CalculatorBrain.h"

@interface GraphAndZoomViewController : UIViewController <GraphAndZoomViewDelegate>
@property (strong, nonatomic) id expression;  //TODO double-check these modifiers
@property (nonatomic) double scale;
@property (retain) IBOutlet GraphAndZoomView *myGraphZoomView;

- (float)scaleForView:(GraphAndZoomView *)requestor;
- (float)Yvalue:(GraphAndZoomView *)requestor forXValue:(float)xValue;

-(IBAction)scaleDown;
-(IBAction)scaleUp;

@end
