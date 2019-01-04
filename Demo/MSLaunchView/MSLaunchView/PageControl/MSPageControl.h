//
//  MSPageControl.h
//  MSCycleScrollView
//
//  Created by TuBo on 2018/12/26.
//  Copyright © 2018 turBur. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MSPageControl;
@protocol MSPageControlDelegate <NSObject>

@optional
- (void)pageControl:(MSPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end

@interface MSPageControl : UIControl

/**
 协议属性
 */
@property(nonatomic,assign) id<MSPageControlDelegate> delegate;

/**
 * Dot view customization properties
 */

/**
 dot视图自定义属性
 */
@property (nonatomic) Class dotViewClass;

/**
 *  其他页面小圆点的图片
 */
@property (nonatomic,strong) UIImage *dotImage;


/**
 *  当前页面小圆点的图片
 */
@property (nonatomic,strong) UIImage *currentDotImage;

/**
 *  当前页面小圆点的Size大小  ⚠️(该属性如需自定义,init完成后请先添加)  Default is CGSize(8,8).
 */
@property (nonatomic) CGSize pageDotSize;


@property (nonatomic, strong) UIColor *dotColor;

/**
 *  相邻两个小圆点间的间隔大小 Default is 8.
 */
@property (nonatomic,assign) NSInteger spacingBetweenDots;


/**
 *  小圆点的个数, Default is 0.
 */
@property (nonatomic,assign) NSInteger numberOfPages;

/**
 * 当前活跃的小圆点的下标, Default is 0.
 */
@property (nonatomic) NSInteger currentPage;


/**
 如果只有一个页面，则隐藏该控件。Default is NO.
 */
@property (nonatomic) BOOL hidesForSinglePage;


/**
 让控制知道是否应该通过保持中心变大，或者只是变长（右侧扩张）。Default is YES.。
 */
@property (nonatomic) BOOL shouldResizeFromCenter;


/**
 返回pageControl显示所需的最小大小。

 @param pageCount 需要显示的点数
 @return CGSize是所需的最小大小。
 */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;


@end



NS_ASSUME_NONNULL_END
