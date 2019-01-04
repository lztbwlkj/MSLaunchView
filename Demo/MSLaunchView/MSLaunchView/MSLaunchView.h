//
//  MSLaunchView.h
//  MSLaunchView
//
//  Created by TuBo on 2018/11/8.
//  Copyright © 2018 TuBur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    kMSPageContolStyleClassic,        // 系统自带经典样式
    kMSPageContolStyleAnimated,       // 动画效果pagecontrol
    kMSPageContolStyleCustomer,       // 自定义动画效果pagecontrol
    kMSPageContolStyleNone            // 不显示pagecontrol
} kMSPageContolStyle;


@interface MSLaunchView : UIView


/**
 立即体验按钮的标题设置 默认“立即体验” 比较简陋 可以使用guideBtnCustom:自行定义
 */
@property (nonatomic, copy) NSString *guideTitle;

/**
 立即体验按钮的标题颜色设置 默认black
 */
@property (nonatomic, strong) UIColor *guideTitleColor;

/**
 跳过按钮文字 比较简陋 可以使用skipBtnCustom:自行定义样式
 */
@property (nonatomic, copy) NSString *skipTitle;

/**
 跳过按钮背景颜色
 */
@property (nonatomic, strong) UIColor *skipBackgroundClolr;

/**
 是否隐藏跳过按钮
 */
@property (nonatomic, assign) BOOL isHiddenSkipBtn;

#pragma mark - >>PageControl属性简单设置
/**
 定制PageControl的样式 继承MSAbstractDotView类可自行定义pageControl的样式、动画；
 ⚠️：如果调用该属性自定义了pageControl的样式，则关于pageControl颜色属性将失效；
 */
@property (nonatomic) Class dotViewClass;

/**
 pagecontrol 样式，默认为动画样式
 */
@property (nonatomic, assign) kMSPageContolStyle pageControlStyle;

/**
 是否显示PageControl
 */
@property (nonatomic, assign) BOOL showPageControl;

/**
 是否在只有一张图时隐藏pagecontrol，默认为YES
 */
@property(nonatomic) BOOL hidesForSinglePage;

/**
 相邻两个小圆点间的间隔大小 Default is 8.
 */
@property (nonatomic,assign) CGFloat spacingBetweenDots;

/**
 分页控件距离轮播图的下边间距（在默认间距基础上）的偏移量 默认为15；
 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/**
 分页控件小圆标大小
 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/**
 当前分页控件小圆标颜色 ⚠️：如果调用了dotViewClass的属性，则该属性失效
 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/**
 其他分页控件小圆标颜色 ⚠️：如果调用了dotViewClass的属性，则该属性失效
 */
@property (nonatomic, strong) UIColor *pageDotColor;

/**
 当前分页控件小圆标图片 ⚠️：如果调用了dotViewClass的属性，则该属性失效
 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/**
 其他分页控件小圆标图片 ⚠️：如果调用了dotViewClass的属性，则该属性失效
 */
@property (nonatomic, strong) UIImage *pageDotImage;

/**
 * 自定义立即体验按钮()
 * 如果使用launchWithImages:guideFrame:gImage:方法初始化,该方法将会失效
 * @param btn 自定义按钮块
 */
-(void)guideBtnCustom:(UIButton *(^)(void))btn;


/**
 自定义跳过按钮

 @param btn 自定义按钮块
 */
-(void)skipBtnCustom:(UIButton *(^)(void))btn;

#pragma mark ----可自动识别动态图片和静态图片
#pragma 图片引导页
/**
 *  不带按钮的引导页，滑动到最后一页，再向右滑直接隐藏引导页
 *
 *  @param images 背景图片数组
 *
 *  @return   MSLaunchView对象
 */
+(instancetype)launchWithImages:(NSArray <NSString *>*)images;
/**
 *  带按钮的引导页(如果使用该方法初始化,guideBtnCustom将会失效)
 *
 *  @param images 背景图片数组
 *  @param gframe 按钮的frame
 *  @param gImage 按钮的图片
 *
 *  @return MSLaunchView对象
 */
+(instancetype)launchWithImages:(NSArray <NSString *>*)images guideFrame:(CGRect)gframe  gImage:(UIImage *)gImage;

/**
 用storyboard创建的project调用此方法
 @param images 图片名字数组
 @param sbName storyboardName 默认为@"Main"
 @return MSLaunchView对象
 */
+(instancetype)launchWithImages:(NSArray <NSString *>*)images sbName:(NSString *)sbName;
    
/**
 * 用storyboard创建的project调用此方法
 * (如果使用该方法初始化,guideBtnCustom将会失效)
 * @param images 图片名字数组
 * @param sbName storyboardName 默认为@"Main"
 * @param gframe 按钮的frame
 * @param gImage 按钮图片名字
 * @return MSLaunchView对象
 */
+(instancetype)launchWithImages:(NSArray <NSString *>*)images sbName:(NSString *)sbName guideFrame:(CGRect)gframe gImage:(UIImage *)gImage;


#pragma 视频引导页 目前仅支持单个视频

/**
 是否播放完成后自动推出 默认：YES
 */
@property (nonatomic, assign) BOOL isPalyEndOut;

/**
 视频拉伸方式  默认:AVLayerVideoGravityResizeAspectFill
 */
@property (nonatomic, copy) AVLayerVideoGravity videoGravity;

/**
 *  MSLaunchView(视频引导页)
 *
 *  @param videoFrame  位置大小
 *  @param videoURL 引导页视频地址
 *
 *  @return MSLaunchView对象
 */
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL;


/**
 带按钮的视频引导页(如果使用该方法初始化,guideBtnCustom将会失效)

 @param videoFrame 位置大小
 @param videoURL 引导页视频地址
 @param gframe 按钮的frame
 @param gImage 按钮图片名字
 @return MSLaunchView对象
 */
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL guideFrame:(CGRect)gframe gImage:(UIImage *)gImage;


/**
 用storyboard创建的project调用此方法

 @param videoFrame 位置大小
 @param videoURL  引导页视频地址
 @param sbName storyboardName 默认为@"Main"
 @return MSLaunchView对象
 */
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL sbName:(NSString *)sbName;


/**
 用storyboard创建的project调用此方法 (如果使用该方法初始化,guideBtnCustom将会失效)

 @param videoFrame 位置大小
 @param videoURL 引导页视频地址
 @param sbName storyboardName 默认为@"Main"
 @param gframe 按钮的frame
 @param gImage 按钮图片名字
 @return MSLaunchView对象
 */
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL sbName:(NSString *)sbName guideFrame:(CGRect)gframe gImage:(UIImage *)gImage;

/**
 隐藏引导页面
 */
-(void)hideGuidView;
@end

NS_ASSUME_NONNULL_END
