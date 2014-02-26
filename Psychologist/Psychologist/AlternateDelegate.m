//
//  AlternateDelegate.m
//  Happiness
//
//  Created by Paul Romine on 1/26/14.
//
//

#import "AlternateDelegate.h"
#include <stdlib.h>

@implementation AlternateDelegate

-(float)smileForFaceView:(FaceView *)requestor
{
	return smileValue;
}

-(void)updateSmileValue
{
	int r;
	r = arc4random() % 100;
	smileValue = ((float)r-50) / 50;
}



@end
