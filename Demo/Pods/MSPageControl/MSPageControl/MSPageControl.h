//
//  MSPageControl.h
//  MSPageControl
//
//  Created by lztb on 2019/6/27.
//  Copyright © 2019 lztbwlkj. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MSPageControlStyle) {
    MSPageControlStyleSystem,//系统样式 默认
    MSPageControlStyleNumber //带有数字样式
};

typedef NS_ENUM(NSInteger, MSPageControlAnimation) {
    MSPageControlAnimationNone,//没有动画
    MSPageControlAnimationSystem,
};

@class MSPageControl;
/**
 点击dotView的回调方法

 @param pageControl pageControl
 @param index 点击的当前下标
 */
typedef void(^didSelectPageAtIndex)(MSPageControl *pageControl,NSInteger index);

@protocol MSPageControlDelegate <NSObject>

@optional
- (void)pageControl:(MSPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end

@interface MSPageControl : UIControl

/**
 MSPageControl的样式 目前只支持两种样式
 */
@property(nonatomic,assign) MSPageControlStyle pageControlStyle;

/**
 MSPageControl的过渡动画 目前只支持两种样式 其他样式需要自定义（自定义样式暂未开放）
 */
@property(nonatomic,assign) MSPageControlAnimation pageControlAnimation;

/**
 pageControlAnimation为MSPageControlStyleNumber时字体设置
 */
@property(nonatomic,strong) UIFont *textFont;

/**
 pageControlAnimation为MSPageControlStyleNumber时文本颜色设置
 */
@property(nonatomic,strong) UIColor *textColor;

/**
 点击dotView的回调方法
 */
@property(nonatomic,copy) didSelectPageAtIndex didSelectPageAtIndexBlock;

/**
 协议属性
 */
@property(nonatomic,assign) id<MSPageControlDelegate> delegate;
/**
 分页数量 Default is 0.
 */
@property(nonatomic, assign) NSInteger numberOfPages;

/**
 当前活跃的小圆点的下标, Default is 0.
 */
@property(nonatomic, assign) NSInteger currentPage;

/**
 点的大小 设置了pagecControl图片属性 pageDotSize将失效
 */
@property(nonatomic, assign) CGSize pageDotSize;

/**
 点之间的间距 Default is 8.
 */
@property(nonatomic, assign) CGFloat spacingBetweenDots;

/**
 未选中点的颜色
 */
@property(nonatomic, strong) UIColor *dotColor;

/**
 当前点的颜色
 */
@property(nonatomic, strong) UIColor *currentDotColor;

/**
 其他页面小圆点的图片
 */
@property(nonatomic, strong) UIImage *dotImage;

/**
 当前点的图片
 */
@property(nonatomic, strong) UIImage *currentDotImage;

/**
 是否是方形点 默认NO 显示圆形
 */
@property(nonatomic, assign) BOOL dotsIsSquare;

/**
 当前选中点宽度与未选中点的宽度的倍数 默认是1
 * 计算方法 pageDotSize.width = pageDotSize.width * currentWidthMultiple；
 * 设置了pagecControl图片属性 currentWidthMultiple将失效
 */
@property(nonatomic, assign) CGFloat currentWidthMultiple;

/**
 未选中点的layerColor
 */
@property(nonatomic, strong) UIColor *dotBorderColor;

/**
 选中点的layerColor
 */
@property(nonatomic, strong) UIColor *currentDotBorderColor;

/**
 未选中点的layer宽度
 */
@property(nonatomic, assign) CGFloat dotBorderWidth;

/**
 选中点的layer宽度
 */
@property(nonatomic, assign) CGFloat currentDotBorderWidth;

/**
 如果只有一个页面，则隐藏该控件。Default is NO.
 */
@property (nonatomic) BOOL hidesForSinglePage;

/**
 让控制知道是否应该通过保持中心变大，或者只是变长（右侧扩张）。Default is YES.。
 */
@property (nonatomic) BOOL shouldResizeFromCenter;



- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;
/**
 提供系统样式的pageControl

 @param frame 位置
 @param numberOfPages page数量
 @param dotColor 其他页面的dot颜色
 @param currentDotColor 当前页面的dot颜色
 @return pageControl
 */
+ (instancetype)pageControlSystemWithFrame:(CGRect)frame numberOfPages:(NSInteger)numberOfPages otherDotColor:(UIColor *)dotColor currentDotColor:(UIColor *)currentDotColor;
@end

NS_ASSUME_NONNULL_END
