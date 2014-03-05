//
//  GraphAndZoomView.h
//  GraphingCalculator
//
//  Created by Paul Romine on 3/2/14.
//  Copyright (c) 2014 Paul Romine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@class GraphAndZoomView;

@protocol GraphAndZoomViewDelegate
- (float)scaleForView:(GraphAndZoomView *)requestor;
@end



@interface GraphAndZoomView : UIView
{
	id <GraphAndZoomViewDelegate> delegate;
}

@property (retain) id <GraphAndZoomViewDelegate> delegate;

@end
