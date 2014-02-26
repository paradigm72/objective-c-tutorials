//
//  PsychologistViewController.m
//  Psychologist
//
//  Created by Paul Romine on 2/20/14.
//  Copyright (c) 2014 Paul Romine. All rights reserved.
//

#import "PsychologistViewController.h"
#import "HappinessViewController.h"

@interface PsychologistViewController ()

@end

@implementation PsychologistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)happy:(id)sender
{
	[self showDiagnosis:100];
}

-(IBAction)soso:(id)sender
{
	[self showDiagnosis:50];
}

-(IBAction)sad:(id)sender
{
	[self showDiagnosis:0];
}

- (void)showDiagnosis:(int)diagnosisValue
{
	HappinessViewController *hvc = [[HappinessViewController alloc] init];
	hvc.happiness = diagnosisValue;
	[self.navigationController pushViewController:hvc animated:YES];
	[hvc release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationController.navigationBar.translucent = NO;
	self.title = @"Psychologist";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
