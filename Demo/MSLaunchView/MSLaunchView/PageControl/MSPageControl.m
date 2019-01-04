//
//  MSPageControl.m
//  MSCycleScrollView
//
//  Created by TuBo on 2018/12/26.
//  Copyright © 2018 turBur. All rights reserved.
//

#import "MSPageControl.h"
#import "MSAnimatedDotView.h"

/**
 *  Default number of pages for initialization
 */
static NSInteger const kDefaultNumberOfPages = 0;

/**
 *  Default current page for initialization
 */
static NSInteger const kDefaultCurrentPage = 0;

/**
 *  Default setting for hide for single page feature. For initialization
 */
static BOOL const kDefaultHideForSinglePage = NO;

/**
 *  Default setting for shouldResizeFromCenter. For initialiation
 */
static BOOL const kDefaultShouldResizeFromCenter = YES;

/**
 *  Default spacing between dots
 */
static NSInteger const kDefaultSpacingBetweenDots = 8;

/**
 *  Default dot size
 */
static CGSize const kDefaultDotSize = {8, 8};

@interface MSPageControl()
/**
 *  Array of dot views for reusability and touch events.
 */
@property (strong, nonatomic) NSMutableArray *dots;

@end
@implementation MSPageControl
#pragma mark - Lifecycle
- (id)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}

-(void)initialization{
    
    self.dotViewClass           = [MSAnimatedDotView class];
    self.spacingBetweenDots     = kDefaultSpacingBetweenDots;
    self.numberOfPages          = kDefaultNumberOfPages;
    self.currentPage            = kDefaultCurrentPage;
    self.hidesForSinglePage     = kDefaultHideForSinglePage;
    self.shouldResizeFromCenter = kDefaultShouldResizeFromCenter;
    self.pageDotSize = kDefaultDotSize;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount{
    return CGSizeMake((self.pageDotSize.width + self.spacingBetweenDots) * pageCount - self.spacingBetweenDots , self.pageDotSize.height);
}

#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        NSInteger index = [self.dots indexOfObject:touch.view];
        if ([self.delegate respondsToSelector:@selector(pageControl:didSelectPageAtIndex:)]) {
            [self.delegate pageControl:self didSelectPageAtIndex:index];
        }
    }
}


#pragma mark - Layout
/**
 *  Resizes and moves the receiver view so it just encloses its subviews.
 */
- (void)sizeToFit
{
    [self updateFrame:YES];
}


#pragma mark - Setters
- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    // Update dot position to fit new number of pages
    [self resetDotViews];
}


- (void)setDotImage:(UIImage *)dotImage
{
    _dotImage = dotImage;
    [self resetDotViews];
    self.dotViewClass = nil;
}

- (void)setCurrentDotImage:(UIImage *)currentDotimage
{
    _currentDotImage = currentDotimage;
    [self resetDotViews];
    self.dotViewClass = nil;
}

-(void)setPageDotSize:(CGSize)pageDotSize{
    _pageDotSize = pageDotSize;
    if (self.dotImage && self.currentDotImage) {
        _pageDotSize = self.dotImage.size;
    }
    [self resetDotViews];
}


- (void)setDotViewClass:(Class)dotViewClass
{
    _dotViewClass = dotViewClass;
    self.pageDotSize = CGSizeZero;
    [self resetDotViews];
}

-(void)setHidesForSinglePage:(BOOL)hidesForSinglePage{
    _hidesForSinglePage = hidesForSinglePage;
    if (self.dots.count == 1 && hidesForSinglePage) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

- (void)setSpacingBetweenDots:(NSInteger)spacingBetweenDots
{
    _spacingBetweenDots = spacingBetweenDots;
    
    [self resetDotViews];
}


- (void)setCurrentPage:(NSInteger)currentPage
{
    // If no pages, no current page to treat.
    if (self.numberOfPages == 0 || currentPage == _currentPage) {
        _currentPage = currentPage;
        return;
    }
    
    // Pre set
    [self changeActivity:NO atIndex:_currentPage];
    _currentPage = currentPage;
    // Post set
    [self changeActivity:YES atIndex:_currentPage];
}


#pragma mark ================== dotView 添加 ==================
-(void)resetDotViews{
    for (UIView *dotView in self.dots) {
        [dotView removeFromSuperview];
    }
    
    [self.dots removeAllObjects];
    [self updateDots];
}

-(void)updateDots{
    if (self.numberOfPages == 0) {
        return;
    }
    
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        
        UIView *dotView;
        if (i < self.dots.count) {
            dotView = [self.dots objectAtIndex:i];
        } else {
            dotView = [self generateDotView];
        }
        [self updateDotFrame:dotView atIndex:i];
    }
    [self changeActivity:YES atIndex:self.currentPage];
    
    [self hidesForSinglePage];
}

- (UIView *)generateDotView
{
    UIView *dotView;
    
    if (self.dotViewClass) {
        dotView = [[self.dotViewClass alloc] initWithFrame:CGRectMake(0, 0, self.pageDotSize.width, self.pageDotSize.height)];
        if ([dotView isKindOfClass:[MSAnimatedDotView class]] && self.dotColor) {
            ((MSAnimatedDotView *)dotView).dotColor = self.dotColor;
        }
    } else {
        dotView = [[UIImageView alloc] initWithImage:self.dotImage];
        dotView.frame = CGRectMake(0, 0, self.pageDotSize.width, self.pageDotSize.height);
    }
    
    if (dotView) {
        [self addSubview:dotView];
        [self.dots addObject:dotView];
    }
    
    dotView.userInteractionEnabled = YES;
    
    return dotView;
}


- (void)updateDotFrame:(UIView *)dot atIndex:(NSInteger)index{
    
    // Dots are always centered within view
//    CGFloat width = (index == _currentPage)? self.currentPageDotSize.width:self.pageDotSize.width;
    
    CGFloat x = (self.pageDotSize.width + self.spacingBetweenDots) * index + ( (CGRectGetWidth(self.frame) - [self sizeForNumberOfPages:self.numberOfPages].width ) / 2);
    
    CGFloat y = (CGRectGetHeight(self.frame) - self.pageDotSize.height) / 2;
    
    dot.frame = CGRectMake(x, y, self.pageDotSize.width, self.pageDotSize.height);
}



#pragma mark - Utils
- (void)changeActivity:(BOOL)active atIndex:(NSInteger)index
{
    if (self.dotViewClass) {
        MSAbstractDotView *abstractDotView = (MSAbstractDotView *)[self.dots objectAtIndex:index];
        if ([abstractDotView respondsToSelector:@selector(changeActivityState:dotView:pageDotSize:)]) {
            [abstractDotView changeActivityState:active dotView:abstractDotView pageDotSize:_pageDotSize];
        } else {
            NSLog(@"Custom view : %@ must implement an 'changeActivityState' method or you can subclass %@ to help you.", self.dotViewClass, [MSAbstractDotView class]);
        }
    } else if (self.dotImage && self.currentDotImage) {
        UIImageView *dotView = (UIImageView *)[self.dots objectAtIndex:index];
        dotView.image = (active) ? self.currentDotImage : self.dotImage;
    }
}

- (void)updateFrame:(BOOL)overrideExistingFrame
{
    CGPoint center = self.center;
    CGSize requiredSize = [self sizeForNumberOfPages:self.numberOfPages];
    
    // We apply requiredSize only if authorize to and necessary
    if (overrideExistingFrame || ((CGRectGetWidth(self.frame) < requiredSize.width || CGRectGetHeight(self.frame) < requiredSize.height) && !overrideExistingFrame)) {
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), requiredSize.width, requiredSize.height);
        if (self.shouldResizeFromCenter) {
            self.center = center;
        }
    }
    
    [self resetDotViews];
}

#pragma mark - Getters
- (NSMutableArray *)dots
{
    if (!_dots) {
        _dots = [[NSMutableArray alloc] init];
    }
    
    return _dots;
}

@end
