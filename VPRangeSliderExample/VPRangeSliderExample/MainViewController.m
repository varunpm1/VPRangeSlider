//
//  MainViewController.m
//  VPRangeSliderExample
//
//  Created by Varun P M on 19/12/15.
//  Copyright © 2015 VPN. All rights reserved.
//

#import "MainViewController.h"
#import "VPRangeSlider.h"

NSString * const SliderValue [] = {
    [0] = @"<25",
    [1] = @"25-50",
    [2] = @"50-75",
    [3] = @"75-100"
};

@interface MainViewController () <VPRangeSliderDelegate>

@property (weak, nonatomic) IBOutlet VPRangeSlider *rangeSliderView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.rangeSliderView.requireSegments = YES;
    self.rangeSliderView.numberOfSegments = 4;
    self.rangeSliderView.sliderSize = CGSizeMake(10, 10);
    self.rangeSliderView.segmentSize = CGSizeMake(10, 10);
    
    self.rangeSliderView.rangeSliderForegroundColor = [UIColor redColor];
    [self.rangeSliderView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VPRangeSliderDelegate
- (void)sliderScrolledToMinIndex:(NSInteger)minIndex andMaxIndex:(NSInteger)maxIndex
{
    self.rangeSliderView.minRangeText = SliderValue[minIndex];
    self.rangeSliderView.maxRangeText = SliderValue[maxIndex];
}

@end
