//
//  MSPageControl.m
//  MSPageControl
//
//  Created by lztb on 2019/6/27.
//  Copyright © 2019 lztbwlkj. All rights reserved.
//

#import "MSPageControl.h"
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


static BOOL const kDefaultDotsIsSquare = NO;


static NSInteger const kDefaultCurrentWidthMultiple = 1;

@interface MSPageControl ()
/**
 *  Array of dot views for reusability and touch events.
 */
@property (strong, nonatomic) NSMutableArray *dots;

@end

@implementation MSPageControl
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

+ (instancetype)pageControlSystemWithFrame:(CGRect)frame numberOfPages:(NSInteger)numberOfPages otherDotColor:(UIColor *)dotColor currentDotColor:(UIColor *)currentDotColor{
    MSPageControl *pageControl = [[MSPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages = numberOfPages;
    pageControl.dotColor = dotColor;
    pageControl.currentDotColor = currentDotColor;
    return pageControl;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    self.spacingBetweenDots     = kDefaultSpacingBetweenDots;//默认点的间距为8
    self.numberOfPages          = kDefaultNumberOfPages;//默认点的间距为8
    self.currentPage            = kDefaultCurrentPage;//默认当前页数为第一页
    self.hidesForSinglePage     = kDefaultHideForSinglePage;//如果只有一个页面 默认是不隐藏
    self.dotColor = [UIColor colorWithWhite:1 alpha:0.5];//默认未选中点的颜色为白色，透明度50%
    self.currentDotColor = [UIColor whiteColor];//默认选中点的颜色为白色
    self.pageDotSize = kDefaultDotSize;//默认点的宽高分别为8
    self.currentWidthMultiple = kDefaultCurrentWidthMultiple;//当前选中点宽度与未选中点的宽度的倍数，默认为1倍
    self.dotsIsSquare = kDefaultDotsIsSquare;//默认是圆点
    self.shouldResizeFromCenter = kDefaultShouldResizeFromCenter;
    
    self.currentDotBorderWidth = 0;
    self.currentDotBorderColor = [UIColor clearColor];
    
    self.dotBorderColor = [UIColor whiteColor];
    self.dotBorderWidth = 0;
    
    self.pageControlStyle = MSPageControlStyleSystem;
    self.pageControlAnimation = MSPageControlAnimationSystem;
    
    self.textFont = [UIFont systemFontOfSize:9];
    self.textColor = [UIColor blackColor];
}


#pragma mark - Layout
/**
 *  Resizes and moves the receiver view so it just encloses its subviews.
 */
- (void)sizeToFit{
    [self updateFrame:YES];
}

- (void)updateFrame:(BOOL)overrideExistingFrame{
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


#pragma mark - Setters
- (void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    // Update dot position to fit new number of pages
    [self resetDotViews];
}


- (void)setDotImage:(UIImage *)dotImage{
    _dotImage = dotImage;
    [self resetDotViews];
}

- (void)setCurrentDotImage:(UIImage *)currentDotimage{
    _currentDotImage = currentDotimage;
    [self resetDotViews];
}

-(void)setPageDotSize:(CGSize)pageDotSize{
    _pageDotSize = pageDotSize;
//    if (self.dotImage && self.currentDotImage) {
//        _pageDotSize = self.dotImage.size;
//    }
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

- (void)setSpacingBetweenDots:(CGFloat)spacingBetweenDots{
    if (_spacingBetweenDots == spacingBetweenDots) return;
    _spacingBetweenDots = spacingBetweenDots;
    [self resetDotViews];
}


-(void)setDotColor:(UIColor *)dotColor{
    if (_dotColor == dotColor) return;

    _dotColor = dotColor;
    [self resetDotViews];
}

-(void)setCurrentDotColor:(UIColor *)currentDotColor{
    if (self.currentDotColor == currentDotColor) return;
    
    _currentDotColor = currentDotColor;
    [self resetDotViews];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    if (_currentPage == currentPage || self.numberOfPages == 0 ) return;
    [self changeWithOldIndex:_currentPage atNewIndex:currentPage];

    _currentPage = currentPage;
}

- (void)setDotBorderWidth:(CGFloat)dotBorderWidth{
    if (_dotBorderWidth == dotBorderWidth) return;

    _dotBorderWidth = dotBorderWidth;
    [self resetDotViews];
}

-(void)setCurrentDotBorderWidth:(CGFloat)currentDotBorderWidth{
    if (_currentDotBorderWidth == currentDotBorderWidth) return;
    _currentDotBorderWidth = currentDotBorderWidth;
   
    [self resetDotViews];
}

-(void)setDotBorderColor:(UIColor *)dotBorderColor{
    if (_dotBorderColor == dotBorderColor) return;
    _dotBorderColor = dotBorderColor;
    [self resetDotViews];
}

-(void)setCurrentDotBorderColor:(UIColor *)currentDotBorderColor{
    if (_currentDotBorderColor == currentDotBorderColor) return;

    _currentDotBorderColor = currentDotBorderColor;
    [self resetDotViews];
}

-(void)setCurrentWidthMultiple:(CGFloat)currentWidthMultiple{
    if (_currentWidthMultiple == currentWidthMultiple) return;

    _currentWidthMultiple = currentWidthMultiple;
    [self resetDotViews];
}

-(void)setDotsIsSquare:(BOOL)dotsIsSquare{
    if (_dotsIsSquare == dotsIsSquare) return;
    _dotsIsSquare = dotsIsSquare;
    [self resetDotViews];
}

-(void)setPageControlStyle:(MSPageControlStyle)pageControlStyle{
    if (_pageControlStyle == pageControlStyle) return;
    _pageControlStyle = pageControlStyle;
    [self resetDotViews];
}

-(void)setPageControlAnimation:(MSPageControlAnimation)pageControlAnimation{
    if (_pageControlAnimation == pageControlAnimation) return;
    _pageControlAnimation = pageControlAnimation;
    [self resetDotViews];
}


-(void)setTextFont:(UIFont *)textFont{
    if (_textFont == textFont) return;
    _textFont = textFont;
    [self resetDotViews];
}

-(void)setTextColor:(UIColor *)textColor{
    if (_textColor == textColor) return;
    _textColor = textColor;
    [self resetDotViews];
}

#pragma mark ================== dotView 添加 ==================
-(void)resetDotViews{
    for (UIView *dotView in self.dots) {
        [dotView removeFromSuperview];
    }
    if (self.dotImage || self.currentDotImage) {
        _currentWidthMultiple = 1;
        _pageDotSize = self.currentDotImage.size;
    }
    
    [self.dots removeAllObjects];
    [self updateDots];
}

-(void)updateDots{
    if (self.numberOfPages == 0) {
        return;
    }
    
    CGFloat startX = 0.0, startY = 0.0;
    CGFloat mainWidth = self.numberOfPages * (self.pageDotSize.width + self.spacingBetweenDots);

    if (self.frame.size.width > mainWidth) {
        startX = (self.frame.size.width - mainWidth) / 2;
    }
    
    startY = (CGRectGetHeight(self.frame) - self.pageDotSize.height) / 2;
    //创建dotView
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        UIView *dotView;
        if (i < self.dots.count) {
            dotView = [self.dots objectAtIndex:i];
        } else {
            
            if (i == _currentPage) {
                CGFloat currentPointViewWidth = self.pageDotSize.width * self.currentWidthMultiple;
                dotView = [[UIImageView alloc] initWithImage:self.currentDotImage];
                if (self.currentDotImage) {
                    dotView.backgroundColor = [UIColor clearColor];
                }else{
                    dotView.backgroundColor = self.currentDotColor;
                }
                dotView.frame = CGRectMake(startX, startY, currentPointViewWidth, self.pageDotSize.height);
                dotView.layer.borderColor = self.currentDotBorderColor.CGColor;
                dotView.layer.borderWidth = self.currentDotBorderWidth;
                dotView.layer.cornerRadius = self.dotsIsSquare ? 0 : self.pageDotSize.height / 2;
            }else{
                dotView = [[UIImageView alloc] initWithImage:self.dotImage];
                if (self.dotImage) {
                    dotView.backgroundColor = [UIColor clearColor];
                }else{
                    dotView.backgroundColor = self.dotColor;
                }
                dotView.frame = CGRectMake(startX, startY, self.pageDotSize.width, self.pageDotSize.height);
                dotView.layer.borderColor = self.dotBorderColor.CGColor;
                dotView.layer.borderWidth = self.dotBorderWidth;
                dotView.layer.cornerRadius = self.dotsIsSquare ? 0 : self.pageDotSize.height / 2;
            }
            
            startX = CGRectGetMaxX(dotView.frame) + self.spacingBetweenDots;
            
            //数字样式
            if (self.pageControlStyle == MSPageControlStyleNumber) {
                UILabel *indexLbl = [[UILabel alloc] initWithFrame:dotView.bounds];
                indexLbl.text = [NSString stringWithFormat:@"%ld",(long)i+1];
                indexLbl.textAlignment = NSTextAlignmentCenter;
                indexLbl.font = self.textFont;
                indexLbl.textColor = self.textColor;
                [dotView addSubview:indexLbl];
            }
         
            if (dotView) {
                [self addSubview:dotView];
                [self.dots addObject:dotView];
            }
            
            dotView.userInteractionEnabled = YES;
            dotView.clipsToBounds = YES;
            dotView.layer.masksToBounds = YES;
        }
    }
    
    [self hidesForSinglePage];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    if (self.currentWidthMultiple != kDefaultCurrentWidthMultiple) {
        CGFloat currentPointViewWidth = self.pageDotSize.width * self.currentWidthMultiple;
        CGFloat width = self.pageDotSize.width;
        return CGSizeMake(((currentPointViewWidth + self.spacingBetweenDots) + (width + self.spacingBetweenDots) * (pageCount-1)) - self.spacingBetweenDots , self.pageDotSize.height);
    }
    return CGSizeMake((self.pageDotSize.width + self.spacingBetweenDots) * pageCount - self.spacingBetweenDots , self.pageDotSize.height);
}

#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        NSInteger index = [self.dots indexOfObject:touch.view];
        if (self.didSelectPageAtIndexBlock) {
            self.didSelectPageAtIndexBlock(self, index);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageControl:didSelectPageAtIndex:)]) {
            [self.delegate pageControl:self didSelectPageAtIndex:index];
        }
    }
}


- (void)changeWithOldIndex:(NSInteger)oldIndex atNewIndex:(NSInteger)newIndex{
    
    UIImageView *oldDotView = (UIImageView *)[self.dots objectAtIndex:oldIndex];
    UIImageView *newDotView = (UIImageView *)[self.dots objectAtIndex:newIndex];
  
    //切换选中图片和未选中图片
    if (self.currentDotImage != nil) {
        newDotView.image = self.currentDotImage;
    }
    
    if (self.dotImage != nil) {
        oldDotView.image = self.dotImage;
    }
    
    //动画过渡
    if (newDotView.image == nil && newDotView.image == nil) {
        //设置背景颜色
        oldDotView.backgroundColor = self.dotColor;
        newDotView.backgroundColor = self.currentDotColor;
    }
    
    oldDotView.layer.borderColor = self.dotBorderColor != nil ? [self.dotBorderColor CGColor] : self.dotColor.CGColor;
    oldDotView.layer.borderWidth = self.dotBorderWidth ? self.dotBorderWidth : 0;
    
    newDotView.layer.borderColor = self.currentDotBorderColor ? [self.currentDotBorderColor CGColor] : [self.currentDotColor CGColor];
    newDotView.layer.borderWidth = self.currentDotBorderWidth ? self.currentDotBorderWidth : 0;
    
    if (self.currentWidthMultiple != 1) {//如果当前选中点的宽度与未选中的点宽度不一样，则要改变选中前后两点的frame
        CGRect oldDotFrame = oldDotView.frame;
        if (newIndex < oldIndex) {
            oldDotFrame.origin.x += self.pageDotSize.width * (self.currentWidthMultiple - 1);
        }
        oldDotFrame.size.width = self.pageDotSize.width;
        
        CGRect newDotFrame = newDotView.frame;
        
        if (newIndex > oldIndex) {
            newDotFrame.origin.x -= self.pageDotSize.width * (self.currentWidthMultiple - 1);
        }
        newDotFrame.size.width = self.pageDotSize.width * self.currentWidthMultiple;

        if (self.pageControlAnimation == MSPageControlAnimationSystem) {
            
            [UIView animateWithDuration:0.3 animations:^{
                oldDotView.frame = oldDotFrame;
                newDotView.frame = newDotFrame;
            }];
            
        }else{
            oldDotView.frame = oldDotFrame;
            newDotView.frame = newDotFrame;
        }
    }

    if (newIndex - oldIndex > 1) {//点击圆点，中间有跳过的点
        for (NSInteger i = oldIndex + 1; i<newIndex; i++) {
            UIImageView *imageV = self.dots[i];
            CGRect frame = imageV.frame;
            frame.origin.x -= self.pageDotSize.width * (self.currentWidthMultiple - 1);
            frame.size.width = self.pageDotSize.width;
            imageV.frame = frame;
        }
    }
    
    if (newIndex - oldIndex < -1) {//点击圆点，中间有跳过的点
        for (NSInteger i = newIndex + 1; i< oldIndex; i++) {
            UIImageView *imageV = self.dots[i];
            CGRect frame = imageV.frame;
            frame.origin.x += self.pageDotSize.width * (self.currentWidthMultiple - 1);
            frame.size.width = self.pageDotSize.width;
            imageV.frame = frame;
        }
    }
}


#pragma mark - Getters
- (NSMutableArray *)dots{
    if (!_dots) {
        _dots = [[NSMutableArray alloc] init];
    }
    return _dots;
}


@end
