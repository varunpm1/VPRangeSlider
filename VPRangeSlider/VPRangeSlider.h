//
//  VPRangeSlider.h
//  VPSliderViewExample
//
//  Created by Varun P M on 13/12/15.
//  Copyright © 2015 VPN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPRangeSlider : UIView

// Bool value representing whether segments is needed or not. If NO, then simple 2 way slider will be generated. If YES, then numberOfSegments should be specified. Default is YES.
@property (nonatomic, assign) BOOL requireSegments;

// The number of points in slider (Including the extreme points).
@property (nonatomic, assign) NSInteger numberOfSegments;

// If the reuiqreSegments is set no NO, then this value should be set to define minimum distance between the range sliders. Default to 44.
@property (nonatomic, assign) CGFloat sliderSepertorWidth;

// The color for the extrem slider points. Default is redColor
@property (nonatomic, strong) UIColor *rangeSliderButtonColor;

// The color that is used for rangeSlider unselected range view. (i.e., the view that is not within the slider points). Default is grayColor.
@property (nonatomic, strong) UIColor *rangeSliderBackgroundColor;

// The color that is used for rangeSlider selected range view. (i.e., the view that is between the slider points). Default is greenColor.
@property (nonatomic, strong) UIColor *rangeSliderForegroundColor;

@end
