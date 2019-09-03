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
#import "MSPageControl.h"

NS_ASSUME_NONNULL_BEGIN

#define kisFirstLaunch [MSLaunchView isFirstLaunch]

@class MSLaunchView;

typedef void (^launchViewLoadFinish)(MSLaunchView *launchView);

@protocol MSLaunchViewDeleagte <NSObject>

-(void)launchViewLoadFinish:(MSLaunchView *)launchView;

@end

@interface MSLaunchView : UIView

/**
 加载完成的代理
 */
@property (nonatomic, weak) id <MSLaunchViewDeleagte> delegate;

/**
    加载完成Block回调
 */
@property (nonatomic, copy) launchViewLoadFinish loadFinishBlock;

/**
 立即体验按钮的标题设置 默认“立即体验” 比较简陋 可以使用guideBtnCustom:自行定义
 */
@property (nonatomic, copy) NSString *guideTitle;

/**
 立即体验按钮的标题颜色设置 默认black
 */
@property (nonatomic, strong) UIColor *guideTitleColor;

/**
 立即体验按钮文字字体
 */
@property (nonatomic, strong) UIFont *guideTitleFont;

/**
 跳过按钮文字 比较简陋 可以使用skipBtnCustom:自行定义样式
 */
@property (nonatomic, copy) NSString *skipTitle;

/**
 跳过按钮背景颜色
 */
@property (nonatomic, strong) UIColor *skipBackgroundColor;

/**
 跳过按钮背景图片
 */
@property (nonatomic, strong) UIImage *skipBackgroundImage;

/**
 跳过按钮文字颜色
 */
@property (nonatomic, strong) UIColor *skipTitleColor;

/**
 跳过按钮文字字体
 */
@property (nonatomic, strong) UIFont *skipTitleFont;

/**
 是否隐藏跳过按钮
 */
@property (nonatomic, assign) BOOL isHiddenSkipBtn;

#pragma mark - >>PageControl属性简单设置

/**
 MSPageControl的样式 目前只支持两种样式
 */
@property(nonatomic,assign) MSPageControlStyle pageControlStyle;

/**
 MSPageControl的过渡动画 目前只支持两种样式 其他样式需要自定义（自定义样式暂未开放）
 */
@property(nonatomic,assign) MSPageControlAnimation pageControlAnimation;

/**
 是否显示分页控件 默认为YES
 */
@property (nonatomic, assign) BOOL showPageControl;

/**
 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量
 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/**
 相邻两个小圆点间的间隔大小 Default is 8.
 */
@property (nonatomic,assign) CGFloat spacingBetweenDots;

/**
 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量
 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/**
 * 分页控件小圆标大小
 * 如果设置了 currentPageDotImage 和 pageDotImage 则pageControlDotSize将失效
 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/**
 当前分页控件小圆标颜色
 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/**
 其他分页控件小圆标颜色
 */
@property (nonatomic, strong) UIColor *pageDotColor;

/**
 * 当前分页控件小圆标图片 设置图片后
 * 设置图片后currentWidthMultiple和pageControlDotSize属性失效
 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/**
 * 其他分页控件小圆标图片
 * 设置图片后currentWidthMultiple和pageControlDotSize属性失效
 */
@property (nonatomic, strong) UIImage *pageDotImage;

#pragma mark - 新增属性

/**
 是否为方形点，默认为NO
 */
@property(nonatomic, assign) BOOL dotsIsSquare;


/**
 最后一页是否隐藏pageControl 默认为NO 不隐藏
 */
@property(nonatomic, assign) BOOL lastDotsIsHidden;

/**
 当前选中点宽度与未选中点的宽度的倍数 默认是1
 * 计算方法 pageDotSize.width = pageDotSize.width * currentWidthMultiple；
 * 设置currentPageDotImage或者pageDotImage图片后currentWidthMultiple失效
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
 轮播文字label对齐方式
 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;


/**
 pageControlAnimation为MSPageControlStyleNumber时字体设置
 */
@property(nonatomic,strong) UIFont *textFont;

/**
 pageControlAnimation为MSPageControlStyleNumber时文本颜色设置
 */
@property(nonatomic,strong) UIColor *textColor;


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
 APP 是否是首次进入
 
 @return YES 是首次进入（首次进入定义：APP第一次安装打开或者版本更新后第一次进入）
 */
+ (BOOL)isFirstLaunch;

/**
 不带按钮的引导页，滑动到最后一页，再向右滑直接隐藏引导页

 @param images 背景图片数组（支持gif）
 @param isScrollOut 最后一页面是否自动退出
 @return MSLaunchView对象
 */
+(instancetype) launchWithImages:(NSArray <NSString *>*)images isScrollOut:(BOOL)isScrollOut;

/**
 *  带按钮的引导页(如果使用该方法初始化,guideBtnCustom将会失效)
 *
 *  @param images 背景图片数组
 *  @param gframe 按钮的frame
 *  @param gImage 按钮的图片
 *  @param isScrollOut 是否最后一页左滑自动退出
 *  @return MSLaunchView对象
 */
+(instancetype) launchWithImages:(NSArray <NSString *>*)images guideFrame:(CGRect)gframe gImage:(UIImage *)gImage isScrollOut:(BOOL)isScrollOut;

    
/**
 * 用storyboard创建的project调用此方法
 * (如果使用该方法初始化,guideBtnCustom将会失效)
 * @param images 图片名字数组
 * @param sbName storyboardName 默认为@"Main"
 * @param gframe 按钮的frame
 * @param gImage 按钮图片名字
 * @param isScrollOut 是否最后一页左滑自动退出
 * @return MSLaunchView对象
 */
+(instancetype) launchWithImages:(NSArray <NSString *>*)images sbName:(NSString *)sbName guideFrame:(CGRect)gframe gImage:(UIImage *)gImage isScrollOut:(BOOL)isScrollOut;
/**
 用storyboard创建的project调用此方法(不带t立即体验按钮)

 @param images 图片名字数组
 @param sbName storyboardName 默认为@"Main"
 @param isScrollOut 是否最后一页左滑自动退出
 @return MSLaunchView对象
 */
+(instancetype)launchWithImages:(NSArray <NSString *>*)images sbName:(NSString *)sbName isScrollOut:(BOOL)isScrollOut;

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
