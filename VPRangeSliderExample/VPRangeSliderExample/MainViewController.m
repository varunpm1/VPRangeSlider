//
//  MainViewController.m
//  VPRangeSliderExample
//
//  Created by Varun P M on 19/12/15.
//  Copyright © 2015 VPN. All rights reserved.
//

#import "MainViewController.h"
#import "VPRangeSlider.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet VPRangeSlider *rangeSliderView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.rangeSliderView.requireSegments = YES;
    self.rangeSliderView.numberOfSegments = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
