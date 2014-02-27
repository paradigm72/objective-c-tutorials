//
//  HappinessViewController.h
//  Happiness
//
//  Created by CS193p Instructor on 10/5/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
#import "AlternateDelegate.h"

@interface HappinessViewController : UIViewController <FaceViewDelegate>
{
	int happiness;  //0=unhappy, 100=happy
	BOOL allowSmileChanges;
	UISlider *slider;
	FaceView *faceView;
	
	AlternateDelegate<FaceViewDelegate> *myAlternateDelegate;
	NSTimer *myTimer;
}

@property int happiness;

@property (retain) IBOutlet UISlider *slider;
@property (retain) IBOutlet FaceView *faceView;
@property (retain) IBOutlet UIButton *randomButton;
@property (retain) IBOutlet UIButton *controlledButton;

- (id)initWithHardcodedSmile:(int)initialHappiness;

- (void)processTimer:(NSTimer *)caller;
- (IBAction)happinessChanged:(UISlider *)sender;
- (IBAction)engageRandomSmiling:(UIButton *)sender;
- (IBAction)disengageRandomSmiling:(UIButton *)sender;

@end

