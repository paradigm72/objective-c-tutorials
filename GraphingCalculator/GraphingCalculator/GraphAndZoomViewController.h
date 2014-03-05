//
//  GraphAndZoomViewController.h
//  GraphingCalculator
//
//  Created by Paul Romine on 3/1/14.
//  Copyright (c) 2014 Paul Romine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphAndZoomView.h"

@interface GraphAndZoomViewController : UIViewController <GraphAndZoomViewDelegate>
{
	GraphAndZoomView *myGraphZoomView;
}
@property (strong, nonatomic) id expression;
@property (nonatomic) double scale;
@property (retain) IBOutlet GraphAndZoomView *myGraphZoomView;

- (float)scaleForView:(GraphAndZoomView *)requestor;

-(IBAction)scaleDown;
-(IBAction)scaleUp;

@end
