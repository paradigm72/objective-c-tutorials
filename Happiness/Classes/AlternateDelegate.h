//
//  AlternateDelegate.h
//  Happiness
//
//  Created by Paul Romine on 1/26/14.
//
//

#import <Foundation/Foundation.h>
#import "FaceView.h"


@interface AlternateDelegate : NSObject <FaceViewDelegate>
{

	float smileValue;
}


@property (assign) UIViewController *myParentVC;

- (void)updateSmileValue;


@end
