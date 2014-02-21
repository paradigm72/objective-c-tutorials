//
//  HappinessViewController.m
//  Happiness
//
//  Created by CS193p Instructor on 10/5/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "HappinessViewController.h"

@implementation HappinessViewController

@synthesize faceView, slider;


- (int)happiness
{
	return happiness;
}

- (void)setHappiness:(int)newHappiness
{
	if (newHappiness < 0) newHappiness = 0;
	if (newHappiness > 100) newHappiness = 100;
	happiness = newHappiness;
	[self updateUI];
}


- (void)updateUI
{
	self.slider.value = self.happiness;
	[self.faceView setNeedsDisplay];
}


- (float)smileForFaceView:(FaceView *)requestor
{
	return (((float)happiness - 50) / 50);  //convert 0-100 scale to -1 to 1 scale.
}


- (IBAction)happinessChanged:(UISlider *)sender
{
	self.happiness = sender.value;
}


- (IBAction)engageRandomSmiling:(UIButton *)sender
{
	if (!myAlternateDelegate) {
		myAlternateDelegate = [[AlternateDelegate alloc] init];
		[self startTimer];
		myAlternateDelegate.myParentVC = self;
	}
	self.faceView.delegate = myAlternateDelegate;
}

-(void)startTimer
{
	myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
											   target:self
											 selector:@selector(processTimer:)
											 userInfo:nil
											  repeats:YES];
}

-(void)processTimer:(NSTimer *)caller
{
	[self updateUI];
	[myAlternateDelegate updateSmileValue];
}

- (IBAction)disengageRandomSmiling:(UIButton *)sender
{
	self.faceView.delegate = nil;
	self.faceView.delegate = self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.faceView.delegate = self;
	[self updateUI];
}


- (void)releaseOutlets
{
	self.faceView = nil;
	self.slider = nil;
}

- (void)viewDidUnload {
	[self releaseOutlets];
}


- (void)dealloc {
	[self releaseOutlets];
    //[super dealloc];
}

@end
