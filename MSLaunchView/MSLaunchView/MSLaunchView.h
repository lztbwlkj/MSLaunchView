//
//  MSLaunchView.h
//  MSLaunchView
//
//  Created by TuBo on 2018/11/8.
//  Copyright © 2018 TuBur. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSLaunchView : UIView

/**
 立即体验按钮的标题设置 默认“立即体验”
 */
@property (nonatomic, copy) NSString *guideTitle;

/**
 立即体验按钮的标题颜色设置 默认black
 */
@property (nonatomic, strong) UIColor *guideTitleColor;

/**
 跳过按钮文字
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


/**
 *  选中page的指示器颜色，默认白色
 */
@property (nonatomic, strong) UIColor *currentColor;
/**
 *  其他状态下的指示器的颜色，默认
 */
@property (nonatomic, strong) UIColor *nomalColor;

/**
 自定义立即体验按钮
 
 @param btn 自定义按钮块
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
 *  @param imageNames 背景图片数组
 *
 *  @return   LaunchIntroductionView对象
 */
+(instancetype)sharedWithImages:(NSArray *)imageNames;
/**
 *  带按钮的引导页
 *
 *  @param imageNames      背景图片数组
 *  @param buttonImageName 按钮的图片
 *  @param frame           按钮的frame
 *
 *  @return LaunchIntroductionView对象
 */
+(instancetype)sharedWithImages:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame;

/**
 用storyboard创建的project调用此方法
 @param storyboardName storyboardName
 @param imageNames 图片名字数组
 @return LaunchIntroductionView对象
 */
+ (instancetype)sharedWithStoryboardName:(NSString *)storyboardName images:(NSArray *)imageNames;

/**
 用storyboard创建的project调用此方法
 @param storyboardName storyboardName
 @param imageNames 图片名字数组
 @param buttonImageName 按钮图片名字
 @param frame 按钮的frame
 @return LaunchIntroductionView对象
 */
+(instancetype)sharedWithStoryboardName:(NSString *)storyboardName images:(NSArray *) imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect )frame;


#pragma 视频引导页

/**
 *  MSLaunchView(视频引导页)
 *
 *  @param frame    位置大小
 *  @param videoURL 引导页视频地址
 *
 *  @return MSLaunchView对象
 */
- (instancetype)videoWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL;


/**
 隐藏引导页面
 */
-(void)hideGuidView;
@end

NS_ASSUME_NONNULL_END
