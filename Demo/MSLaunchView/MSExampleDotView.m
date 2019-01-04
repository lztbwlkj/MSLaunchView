//
//  TAExampleDotView.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-23.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "MSExampleDotView.h"

static CGFloat const kAnimateDuration = 1;

@implementation MSExampleDotView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
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

//初始化的样式
- (void)initialization{
    self.backgroundColor = [UIColor purpleColor];
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
}


- (void)changeActivityState:(BOOL)active dotView:(nonnull MSAbstractDotView *)dotView pageDotSize:(CGSize)pageDotSize
{
    if (active) {
        [self animateToActiveState:dotView pageDotSize:pageDotSize];
    } else {
        
        [self animateToDeactiveState:dotView otherPageDotSize:pageDotSize];
    }
}


- (void)animateToActiveState:(MSAbstractDotView *)dotView pageDotSize:(CGSize)pageDotSize
{

    //需要什么样式，或者什么样式的动画可自定义
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.backgroundColor = [UIColor yellowColor];

        CGRect frame = dotView.frame;
        //此处修改线条的长度（或者高度，你可以随便玩）
        frame.size.width = 15;
        //放在frame.size之前修改x的坐标；
        frame.origin.x = dotView.frame.origin.x - (frame.size.width - pageDotSize.width)/2;
        dotView.frame = frame;
        dotView.layer.cornerRadius = pageDotSize.height/2;
    } completion:nil];
}

- (void)animateToDeactiveState:(MSAbstractDotView *)dotView otherPageDotSize:(CGSize)pageDotSize{
    
    //需要什么样式，或者什么样式的动画可自定义
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.backgroundColor = [UIColor purpleColor];

        CGRect frame = dotView.frame;
        //放在frame.size之前修改x的坐标；
        frame.origin.x = dotView.frame.origin.x + (frame.size.width - pageDotSize.width)/2;
        frame.size = pageDotSize;
        dotView.frame = frame;
        dotView.layer.cornerRadius = CGRectGetHeight(dotView.frame)/2;
        
    } completion:nil];
}

@end
