//
//  VPRangeSlider.m
//  Version 0.0.1
//
//  Created by Varun P M on 13/12/15.
//

#import "VPRangeSlider.h"

#define SLIDER_BUTTON_WIDTH         44.0f

#define DEFAULT_SLIDER_FRAME               CGRectMake(SLIDER_BUTTON_WIDTH/2, CGRectGetMidY(self.bounds), CGRectGetWidth(self.bounds) - SLIDER_BUTTON_WIDTH, 2)

@interface VPRangeSlider ()

@property (nonatomic, assign) CGFloat segmentWidth;

// The backgroundView represent unselected/outside range view
@property (nonatomic, strong) UIView *sliderBackgroundView;

// The foregroundView represent selected/inside range view
@property (nonatomic, strong) UIView *sliderForegroundView;

// Represent the range slider on either side of the slider
@property (nonatomic, strong) UIButton *startSliderButton;
@property (nonatomic, strong) UIButton *endSliderButton;

// The label placed below the min and max sliders
@property (nonatomic, strong) UILabel *minRangeLabel;
@property (nonatomic, strong) UILabel *maxRangeLabel;

@end

@implementation VPRangeSlider

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        // Custom Initialization
        [self setDefaultValues];
        [self initSliderViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        // Custom Initialization
        [self setDefaultValues];
        [self initSliderViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Custom Initialization
        [self setDefaultValues];
        [self initSliderViews];
    }
    
    return self;
}

#pragma mark - Update the frames
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.numberOfSegments >= 2)
    {
        // If the range selectors are at the extreme points, then reset the frame. Else fo nothing
        if ([self isRangeSlidersPlacedAtExtremePosition])
        {
            self.sliderBackgroundView.frame = DEFAULT_SLIDER_FRAME;
            self.sliderForegroundView.frame = DEFAULT_SLIDER_FRAME;
            
            self.sliderBackgroundView.backgroundColor = self.rangeSliderBackgroundColor;
            self.sliderForegroundView.backgroundColor = self.rangeSliderForegroundColor;
            
            self.segmentWidth = [self getSegmentWidthForSegmentCount:self.numberOfSegments];
            
            self.startSliderButton.center = CGPointMake(SLIDER_BUTTON_WIDTH/2, CGRectGetMidY(self.sliderBackgroundView.frame));
            self.endSliderButton.center = [self getSegmentCenterPointForSegmentIndex:self.numberOfSegments];
            
            self.minRangeLabel.center = CGPointMake(SLIDER_BUTTON_WIDTH / 2, CGRectGetMidY(self.bounds) + SLIDER_BUTTON_WIDTH);
            self.maxRangeLabel.center = CGPointMake(CGRectGetMaxX(self.bounds) - SLIDER_BUTTON_WIDTH / 2, CGRectGetMidY(self.bounds) + SLIDER_BUTTON_WIDTH);

            [self setImageForSegmentOrSliderButton:self.startSliderButton isSlider:YES];
            [self setImageForSegmentOrSliderButton:self.endSliderButton isSlider:YES];
            
            // Reset the frame of all the intermediate buttons
            for (NSInteger segmentIndex = 1; segmentIndex <= self.numberOfSegments; segmentIndex++)
            {
                UIButton *segmentButton = [self viewWithTag:segmentIndex];
                segmentButton.center = [self getSegmentCenterPointForSegmentIndex:segmentIndex];
                [self setImageForSegmentOrSliderButton:segmentButton isSlider:NO];
            }
            
            // Call the delegate to set the initial label for min range and max range
            if ([self.delegate respondsToSelector:@selector(sliderScrolledToMinIndex:andMaxIndex:)])
            {
                [self.delegate sliderScrolledToMinIndex:0 andMaxIndex:self.numberOfSegments - 1];
                self.minRangeLabel.text = self.minRangeText;
                self.maxRangeLabel.text = self.maxRangeText;
            }
        }
    }
}

- (BOOL)isRangeSlidersPlacedAtExtremePosition
{
    return (CGRectGetMinX(self.startSliderButton.frame) == 0.0f && CGRectGetMaxX(self.endSliderButton.frame) == (CGRectGetMaxX(self.sliderBackgroundView.frame) + SLIDER_BUTTON_WIDTH/2));
}

#pragma mark - Setter methods
- (void)setNumberOfSegments:(NSInteger)numberOfSegments
{
    _numberOfSegments = numberOfSegments;
    
    // After setting the numberOfSegments, set all the necessary views
    self.segmentWidth = [self getSegmentWidthForSegmentCount:_numberOfSegments];
    
    if (self.requireSegments)
    {
        [self addSegmentButtons];
    }
}

#pragma mark - Default Initializaer
- (void)setDefaultValues
{
    self.requireSegments = NO;
    self.numberOfSegments = 2;
    
    self.rangeSliderBackgroundColor = [UIColor grayColor];
    self.rangeSliderForegroundColor = [UIColor greenColor];
    
    self.rangeDisplayLabelFont = [UIFont systemFontOfSize:15.0f];
    self.rangeDisplayLabelColor = [UIColor redColor];
    
    self.segmentSelectedColor = [UIColor blueColor];
    self.segmentUnSelectedColor = [UIColor grayColor];
    
    self.minRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.minRangeLabel.center = CGPointMake(SLIDER_BUTTON_WIDTH / 2, CGRectGetMidY(self.bounds) + SLIDER_BUTTON_WIDTH);
    [self.minRangeLabel setTextColor:self.rangeDisplayLabelColor];
    [self.minRangeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.minRangeLabel setFont:self.rangeDisplayLabelFont];
    [self addSubview:self.minRangeLabel];
    
    self.maxRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.maxRangeLabel.center = CGPointMake(CGRectGetMaxX(self.bounds) - SLIDER_BUTTON_WIDTH / 2, CGRectGetMidY(self.bounds) + SLIDER_BUTTON_WIDTH);
    [self.maxRangeLabel setTextColor:self.rangeDisplayLabelColor];
    [self.maxRangeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.maxRangeLabel setFont:self.rangeDisplayLabelFont];
    [self addSubview:self.maxRangeLabel];
    
    self.sliderSepertorWidth = SLIDER_BUTTON_WIDTH;
    self.segmentWidth = [self getSegmentWidthForSegmentCount:_numberOfSegments];
    
    self.sliderSize = CGSizeMake(20, 20);
    self.segmentSize = CGSizeMake(20, 20);
}

- (void)initSliderViews
{
    // Init the sliding representing views
    self.sliderBackgroundView = [[UIView alloc] initWithFrame:DEFAULT_SLIDER_FRAME];
    self.sliderBackgroundView.backgroundColor = self.rangeSliderBackgroundColor;
    [self addSubview:self.sliderBackgroundView];
    
    self.sliderForegroundView = [[UIView alloc] initWithFrame:DEFAULT_SLIDER_FRAME];
    self.sliderForegroundView.backgroundColor = self.rangeSliderForegroundColor;
    [self addSubview:self.sliderForegroundView];
    
    self.startSliderButton = [self getSegmentButtonWithSegmentIndex:1 isSlider:YES];
    self.endSliderButton = [self getSegmentButtonWithSegmentIndex:self.numberOfSegments isSlider:YES];
    
    [self addSubview:self.startSliderButton];
    [self addSubview:self.endSliderButton];
    
    // Pan gesture for identifying the sliding (More accurate than touchesMoved).
    [self addPanGestureRecognizer];
}

- (void)addSegmentButtons
{
    for (NSInteger segmentIndex = 1; segmentIndex <= self.numberOfSegments; segmentIndex++)
    {
        UIButton *segmentButton = [self getSegmentButtonWithSegmentIndex:segmentIndex isSlider:NO];
        segmentButton.tag = segmentIndex;
        [self addSubview:segmentButton];
    }
}

- (UIButton *)getSegmentButtonWithSegmentIndex:(NSInteger)segmentIndex isSlider:(BOOL)isSlider
{
    // Create rounded button for representing slider segments
    UIButton *segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    segmentButton.frame = CGRectMake(0, 0, SLIDER_BUTTON_WIDTH, SLIDER_BUTTON_WIDTH);
    segmentButton.center = [self getSegmentCenterPointForSegmentIndex:segmentIndex];
    [self setImageForSegmentOrSliderButton:segmentButton isSlider:isSlider];
    
    return segmentButton;
}

- (UIImage *)getImageWithSize:(CGSize)size withColor:(UIColor *)backgroundColor
{
    UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.backgroundColor = backgroundColor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 1.0);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setImageForSegmentOrSliderButton:(UIButton *)button isSlider:(BOOL)isSlider
{
    [button setImage:[self getImageWithSize:isSlider ? self.sliderSize : self.segmentSize withColor:self.segmentSelectedColor] forState:UIControlStateNormal];
    button.imageView.layer.masksToBounds = YES;
    button.imageView.layer.cornerRadius = button.imageView.frame.size.width/2;
}

#pragma mark - Pan Gesture for handling slider movements
- (void)addPanGestureRecognizer
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.maximumNumberOfTouches = 1;
    
    [self addGestureRecognizer:panGesture];
}

#pragma mark - Pan Gesture selector method
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture locationInView:self];
    
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        [self setSelectedStateForSlidingButtonForPoint:point];
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        [self sliderDidSlideForPoint:point];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateFailed || panGesture.state == UIGestureRecognizerStateCancelled)
    {
        if (self.requireSegments)
        {
            // Move the slider to nearest segment
            [self moveSliderToNearestSegmentWithEndingPoint:point];
        }
        
        [self resetSelectedStateForSlidingButtons];
    }
}

#pragma mark - Helper methods
- (void)setSelectedStateForSlidingButtonForPoint:(CGPoint)point
{
    // If sliding began, check if startSlider is moved or endSlider is moved
    if (CGRectContainsPoint(self.startSliderButton.frame, point))
    {
        self.startSliderButton.selected = YES;
        self.endSliderButton.selected = NO;
    }
    else if (CGRectContainsPoint(self.endSliderButton.frame, point))
    {
        self.endSliderButton.selected = YES;
        self.startSliderButton.selected = NO;
    }
    else
    {
        self.startSliderButton.selected = NO;
        self.endSliderButton.selected = NO;
    }
}

- (void)resetSelectedStateForSlidingButtons
{
    // After ending, reset the selected state of both buttons
    self.startSliderButton.selected = NO;
    self.endSliderButton.selected = NO;
}

#pragma mark - Calculations for moving the rangeSliders
- (void)sliderDidSlideForPoint:(CGPoint)point
{
    // Check if startButton is moved or endButton is moved. Based on the moved button, set the frame of the slider button and foregroundSliderView
    if ([self.startSliderButton isSelected])
    {
        if ([self shouldStartButtonSlideForPoint:point])
        {
            [UIView animateWithDuration:0.1 animations:^{
                // Change only the x value for startbutton
                [self.startSliderButton setFrame:CGRectMake([self sliderMidPointForPoint:point], self.startSliderButton.frame.origin.y, self.startSliderButton.frame.size.width, self.startSliderButton.frame.size.height)];
                
                // Change the x and width for slider foreground view
                self.sliderForegroundView.frame = CGRectMake(self.startSliderButton.frame.origin.x + SLIDER_BUTTON_WIDTH/2, self.sliderForegroundView.frame.origin.y, [self getSliderViewWidth], self.sliderForegroundView.frame.size.height);
                
                self.minRangeLabel.center = CGPointMake(CGRectGetMidX(self.startSliderButton.frame), CGRectGetMaxY(self.startSliderButton.frame) + SLIDER_BUTTON_WIDTH / 2);
                
                if (self.requireSegments)
                {
                    // Update the intermediate segment colors
                    [self updateSegmentColorForPoint:point];
                }
            }];
        }
    }
    else if ([self.endSliderButton isSelected])
    {
        if ([self shouldEndButtonSlideForPoint:point])
        {
            [UIView animateWithDuration:0.1 animations:^{
                // Change only the x value for endbutton
                [self.endSliderButton setFrame:CGRectMake([self sliderMidPointForPoint:point], self.endSliderButton.frame.origin.y, self.endSliderButton.frame.size.width, self.endSliderButton.frame.size.height)];
                
                // Change the width for slider foreground view
                self.sliderForegroundView.frame = CGRectMake(self.sliderForegroundView.frame.origin.x, self.sliderForegroundView.frame.origin.y, [self getSliderViewWidth], self.sliderForegroundView.frame.size.height);
                
                self.maxRangeLabel.center = CGPointMake(CGRectGetMidX(self.endSliderButton.frame), CGRectGetMaxY(self.endSliderButton.frame) + SLIDER_BUTTON_WIDTH / 2);
                
                if (self.requireSegments)
                {
                    // Update the intermediate segment colors
                    [self updateSegmentColorForPoint:point];
                }
            }];
        }
    }
}

// Slide to nearest position
- (void)moveSliderToNearestSegmentWithEndingPoint:(CGPoint)point
{
    NSInteger nearestSegmentIndex = round((point.x - SLIDER_BUTTON_WIDTH / 2) / self.segmentWidth);
    [self sliderDidSlideForPoint:CGPointMake(SLIDER_BUTTON_WIDTH/2 + nearestSegmentIndex * self.segmentWidth, point.y)];
    
    NSInteger startIndex = CGRectGetMinX(self.startSliderButton.frame) / self.segmentWidth;
    NSInteger endIndex = CGRectGetMinX(self.endSliderButton.frame) / self.segmentWidth;
    
    if ([self.startSliderButton isSelected])
    {
        startIndex = nearestSegmentIndex;
    }
    else if ([self.endSliderButton isSelected])
    {
        endIndex = nearestSegmentIndex;
    }
    
    if ([self.delegate respondsToSelector:@selector(sliderScrolledToMinIndex:andMaxIndex:)])
    {
        [self.delegate sliderScrolledToMinIndex:startIndex andMaxIndex:endIndex];
        self.minRangeLabel.text = self.minRangeText;
        self.maxRangeLabel.text = self.maxRangeText;
    }
}

- (BOOL)shouldStartButtonSlideForPoint:(CGPoint)point
{
    CGFloat endButtonMidPoint = CGRectGetMidX(self.endSliderButton.frame);
    if (self.requireSegments)
    {
        endButtonMidPoint -= self.segmentWidth;
    }
    else
    {
        endButtonMidPoint -= self.sliderSepertorWidth;
    }
    
    return (round(point.x) <= round(endButtonMidPoint) && point.x >= SLIDER_BUTTON_WIDTH/2);
}

- (BOOL)shouldEndButtonSlideForPoint:(CGPoint)point
{
    CGFloat startButtonMidPoint = CGRectGetMidX(self.startSliderButton.frame);
    if (self.requireSegments)
    {
        startButtonMidPoint += self.segmentWidth;
    }
    
    return (round(point.x) >= round(startButtonMidPoint) && point.x <= self.frame.size.width - SLIDER_BUTTON_WIDTH/2);
}

#pragma mark - Update the segments color on scrolling slider
- (void)updateSegmentColorForPoint:(CGPoint)point
{
    if ([self.startSliderButton isSelected])
    {
        [self updateSegmentColorWithStartIndex:ceil((CGRectGetMidX(self.startSliderButton.frame) - SLIDER_BUTTON_WIDTH / 2) / self.segmentWidth) + 1 andEndIndex:ceil((CGRectGetMidX(self.endSliderButton.frame) - SLIDER_BUTTON_WIDTH / 2) / self.segmentWidth) + 1];
    }
    else if ([self.endSliderButton isSelected])
    {
        [self updateSegmentColorWithStartIndex:ceil(CGRectGetMinX(self.startSliderButton.frame) / self.segmentWidth) + 1 andEndIndex:floor(CGRectGetMinX(self.endSliderButton.frame) / self.segmentWidth) + 1];
    }
}

- (void)updateSegmentColorWithStartIndex:(NSInteger)startIndex andEndIndex:(NSInteger)endIndex
{
    // Segments before startSegment slider
    for (NSInteger segmentIndex = 1; segmentIndex < startIndex; segmentIndex++)
    {
        UIButton *segmentButton = [self viewWithTag:segmentIndex];
        [segmentButton setImage:[self getImageWithSize:self.segmentSize withColor:self.segmentUnSelectedColor] forState:UIControlStateNormal];
    }
    
    // Segments between startSegment slider and endSegment slider
    for (NSInteger segmentIndex = startIndex; segmentIndex <= endIndex; segmentIndex++)
    {
        UIButton *segmentButton = [self viewWithTag:segmentIndex];
        [segmentButton setImage:[self getImageWithSize:self.segmentSize withColor:self.segmentSelectedColor] forState:UIControlStateNormal];
    }
    
    // Segments after endSegment slider
    for (NSInteger segmentIndex = endIndex + 1; segmentIndex <= self.numberOfSegments; segmentIndex++)
    {
        UIButton *segmentButton = [self viewWithTag:segmentIndex];
        [segmentButton setImage:[self getImageWithSize:self.segmentSize withColor:self.segmentUnSelectedColor] forState:UIControlStateNormal];
    }
}

#pragma mark - Calculation for slider frame
- (CGFloat)sliderMidPointForPoint:(CGPoint)point
{
    return (point.x - SLIDER_BUTTON_WIDTH/2);
}

- (CGFloat)getSliderViewWidth
{
    return (CGRectGetMidX(self.endSliderButton.frame) - CGRectGetMidX(self.startSliderButton.frame));
}

#pragma mark - Calculation for segment button frame
- (CGPoint)getSegmentCenterPointForSegmentIndex:(NSInteger)segmentIndex
{
    return CGPointMake((segmentIndex - 1) * self.segmentWidth + SLIDER_BUTTON_WIDTH/2, CGRectGetMidY(self.sliderBackgroundView.frame));
}

- (CGFloat)getSegmentWidthForSegmentCount:(NSInteger)segmentCount
{
    return (CGRectGetWidth(self.frame) - SLIDER_BUTTON_WIDTH) / (segmentCount - 1);
}

@end
