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
@property (weak, nonatomic) IBOutlet VPRangeSlider *segmentedRangeSliderView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.rangeSliderView.requireSegments = NO;
    self.rangeSliderView.sliderSize = CGSizeMake(10, 10);
    self.rangeSliderView.segmentSize = CGSizeMake(10, 10);
    
    self.rangeSliderView.rangeSliderForegroundColor = [UIColor redColor];
    self.rangeSliderView.rangeSliderButtonImage = [UIImage imageNamed:@"slider"];
    [self.rangeSliderView setDelegate:self];
    
    self.segmentedRangeSliderView.requireSegments = YES;
    self.segmentedRangeSliderView.numberOfSegments = 4;
    self.segmentedRangeSliderView.sliderSize = CGSizeMake(10, 10);
    self.segmentedRangeSliderView.segmentSize = CGSizeMake(10, 10);
    
    self.segmentedRangeSliderView.rangeSliderForegroundColor = [UIColor greenColor];
    self.segmentedRangeSliderView.rangeSliderButtonImage = [UIImage imageNamed:@"slider"];
    [self.segmentedRangeSliderView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VPRangeSliderDelegate
- (void)sliderScrolling:(VPRangeSlider *)slider withMinPercent:(CGFloat)minPercent andMaxPercent:(CGFloat)maxPercent
{
    self.rangeSliderView.minRangeText = [NSString stringWithFormat:@"%.0f", minPercent];
    self.rangeSliderView.maxRangeText = [NSString stringWithFormat:@"%.0f", maxPercent];
}

- (void)sliderScrolled:(VPRangeSlider *)slider toMinIndex:(NSInteger)minIndex andMaxIndex:(NSInteger)maxIndex
{
    if (slider == self.segmentedRangeSliderView)
    {
        self.segmentedRangeSliderView.minRangeText = SliderValue[minIndex];
        self.segmentedRangeSliderView.maxRangeText = SliderValue[maxIndex];
    }
    else if (slider == self.rangeSliderView)
    {
        self.rangeSliderView.minRangeText = @"0";
        self.rangeSliderView.maxRangeText = @"100";
    }
}

@end
