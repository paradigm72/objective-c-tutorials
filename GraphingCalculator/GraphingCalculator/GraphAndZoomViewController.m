//
//  GraphAndZoomViewController.m
//  GraphingCalculator
//
//  Created by Paul Romine on 3/1/14.
//  Copyright (c) 2014 Paul Romine. All rights reserved.
//

#import "GraphAndZoomViewController.h"

@interface GraphAndZoomViewController ()

@end

@implementation GraphAndZoomViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
