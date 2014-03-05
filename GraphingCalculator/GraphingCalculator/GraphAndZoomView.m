//
//  GraphAndZoomView.m
//  GraphingCalculator
//
//  Created by Paul Romine on 3/2/14.
//  Copyright (c) 2014 Paul Romine. All rights reserved.
//

#import "GraphAndZoomView.h"

@implementation GraphAndZoomView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGPoint centerPoint;
	centerPoint.x = self.bounds.size.width / 2;
	centerPoint.y = self.bounds.size.height / 2;
	[AxesDrawer drawAxesInRect:self.frame originAtPoint:centerPoint scale:[self.delegate scaleForView:self]];
}


@end
