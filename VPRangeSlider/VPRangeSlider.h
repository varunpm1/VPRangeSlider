//
//  VPRangeSlider.h
//  Version 0.0.1
//
//  Created by Varun P M on 13/12/15.
//

// The MIT License (MIT)
//
// Copyright (c) 2015 Varun P M
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@protocol VPRangeSliderDelegate <NSObject>

@optional
// Called when the user is panning. Used to update the display label while moving the slider. minPercent and maxPercent represents the percentage the slider has covered. (Between 0% and 100%)
- (void)sliderScrollingWithMinPercent:(CGFloat)minPercent andMaxPercent:(CGFloat)maxPercent;

// Called after the segment reaches it's nearest point (In other words, when touch ends).
- (void)sliderScrolledToMinIndex:(NSInteger)minIndex andMaxIndex:(NSInteger)maxIndex;

@end

@interface VPRangeSlider : UIView

// Bool value representing whether segments is needed or not. If NO, then simple 2 way slider will be generated. If YES, then numberOfSegments should be specified. Default is YES.
@property (nonatomic, assign) BOOL requireSegments;

// The number of points in slider (Including the extreme points).
@property (nonatomic, assign) NSInteger numberOfSegments;

// If the reuiqreSegments is set no NO, then this value should be set to define minimum distance between the range sliders. Default to 44.
@property (nonatomic, assign) CGFloat sliderSepertorWidth;

// The image used for displaying slider buttons. By default not set. rangeSliderButtonColor will be used if not set
@property (nonatomic, strong) UIImage *rangeSliderButtonImage;

// The color for the extreme slider points. Default is redColor
@property (nonatomic, strong) UIColor *rangeSliderButtonColor;

// The image for segment button when it is within the selected range. If not set, segmentSelectedColor will be used.
@property (nonatomic, strong) UIImage *segmentSelectedImage;

// The color for segment button when it is within the selected range. Default is blueColor.
@property (nonatomic, strong) UIColor *segmentSelectedColor;

// The image for segment button when it is outside the selected range. If not set, segmentUnSelectedColor will be used.
@property (nonatomic, strong) UIImage *segmentUnSelectedImage;

// The color for segment button when it is outside the selected range. Default is grayColor.
@property (nonatomic, strong) UIColor *segmentUnSelectedColor;

// The color that is used for rangeSlider unselected range view. (i.e., the view that is not within the slider points). Default is grayColor.
@property (nonatomic, strong) UIColor *rangeSliderBackgroundColor;

// The color that is used for rangeSlider selected range view. (i.e., the view that is between the slider points). Default is greenColor.
@property (nonatomic, strong) UIColor *rangeSliderForegroundColor;

// The size of the slider button. If not set, defaults to (20,20).
@property (nonatomic, assign) CGSize sliderSize;

// The size of the segments. If not set, defaults to (20,20).
@property (nonatomic, assign) CGSize segmentSize;

// The label font to be used for min/max range display. Default is system font with fontSize 15.
@property (nonatomic, strong) UIFont *rangeDisplayLabelFont;

// The label color to be used for min range display. Default is red Color.
@property (nonatomic, strong) UIColor *rangeDisplayLabelColor;

// The min and max range label text to be set by caller
@property (nonatomic, strong) NSString *minRangeText;
@property (nonatomic, strong) NSString *maxRangeText;

// The delegate property
@property (nonatomic, weak) id<VPRangeSliderDelegate> delegate;

@end
