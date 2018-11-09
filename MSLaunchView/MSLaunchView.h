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
 *  选中page的指示器颜色，默认白色
 */
@property (nonatomic, strong) UIColor *currentColor;
/**
 *  其他状态下的指示器的颜色，默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *nomalColor;

/**
    是否显示PageControl
 */
@property (nonatomic, assign) BOOL isHiddenPageControl;

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
