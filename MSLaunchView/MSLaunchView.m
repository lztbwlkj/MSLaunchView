//
//  MSLaunchView.m
//  MSLaunchView
//
//  Created by TuBo on 2018/11/8.
//  Copyright © 2018 TuBur. All rights reserved.
//

#import "MSLaunchView.h"
#import "MSLaunchOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#define MSHidden_TIME 1.0
#define MSScreenW   [UIScreen mainScreen].bounds.size.width
#define MSScreenH   [UIScreen mainScreen].bounds.size.height

@interface MSLaunchView()<UIScrollViewDelegate>{
    CGFloat lastContentOffset;
    id launchView;
}
@property (nonatomic, strong) UIButton * skipButton;
@property (nonatomic, strong) UIButton * guideBtn;
@property (nonatomic, strong) UIPageControl           *imagePageControl;
@property (nonatomic, strong) MPMoviePlayerController *playerController;
@end

static NSString *const kAppVersion = @"appVersion";
@implementation MSLaunchView
NSArray *images;
BOOL isScrollOut;
CGRect enterBtnFrame;
NSString *enterBtnImage;
static MSLaunchView *launch = nil;
NSString *storyboard;

#pragma mark - 创建对象-->>不带button
+(instancetype)sharedWithImages:(NSArray *)imageNames{
    images = imageNames;
    isScrollOut = YES;
    launch = [[MSLaunchView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 创建对象-->>带button
+(instancetype)sharedWithImages:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    isScrollOut = NO;
    enterBtnFrame = frame;
    enterBtnImage = buttonImageName;
    launch = [[MSLaunchView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 用storyboard创建的项目时调用，不带button
+ (instancetype)sharedWithStoryboardName:(NSString *)storyboardName images:(NSArray *)imageNames {
    images = imageNames;
    storyboard = storyboardName;
    isScrollOut = YES;
    launch = [[MSLaunchView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}

#pragma mark - 用storyboard创建的项目时调用，带button
+ (instancetype)sharedWithStoryboardName:(NSString *)storyboardName images:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    isScrollOut = NO;
    enterBtnFrame = frame;
    storyboard = storyboardName;
    enterBtnImage = buttonImageName;
    launch = [[MSLaunchView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"currentColor" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"nomalColor" options:NSKeyValueObservingOptionNew context:nil];
        if ([self isFirstLauch]) {
            UIStoryboard *story;
            if (storyboard) {
                story = [UIStoryboard storyboardWithName:storyboard bundle:nil];
            }
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            if (story) {
                UIViewController * vc = story.instantiateInitialViewController;
                window.rootViewController = vc;
                [vc.view addSubview:self];
            }else {
                [window addSubview:self];
            }
            [self addImages];
        }else{
            [self removeGuidePageHUD];
        }
    }
    return self;
}

#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return YES;
    }
}

#pragma mark - 添加引导页图片
-(void)addImages{
    [self createScrollView];
}
#pragma mark - 创建滚动视图
-(void)createScrollView{
    
    UIScrollView *launchScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(MSScreenW * images.count, MSScreenH);
    [self addSubview:launchScrollView];
    
    for (int i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * MSScreenW, 0, MSScreenW, MSScreenH)];
        if ([[MSLaunchOperation ms_contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:images[i] ofType:nil]]] isEqualToString:@"gif"]) {
            NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:images[i] ofType:nil]];
            imageView = (UIImageView *)[[MSLaunchOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
            [launchScrollView addSubview:imageView];
        } else {
            imageView.image = [UIImage imageNamed:images[i]];
            [launchScrollView addSubview:imageView];
        }
        
        if (i == images.count - 1) {
            //拿到最后一个图片，添加自定义体验按钮
            launchView = imageView;
            
            //判断要不要添加button
            if (!isScrollOut) {
                [imageView setUserInteractionEnabled:YES];

                //CGRectMake(MSScreenW*0.3, MSScreenH*0.8, MSScreenW*0.4, MSScreenH*0.08)
                self.guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.guideBtn.frame = enterBtnFrame;
                [self.guideBtn setTitle:@"开始体验" forState:UIControlStateNormal];
                [self.guideBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.guideBtn setBackgroundImage:[UIImage imageNamed:enterBtnImage] forState:UIControlStateNormal];
                [self.guideBtn.titleLabel setFont:[UIFont systemFontOfSize:21]];
                [self.guideBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:self.guideBtn];
            }
        }
    }
    
    // 设置引导页上的跳过按钮
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.frame = CGRectMake(MSScreenW*0.8, MSScreenW*0.1, 50, 25);
    [self.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.skipButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.skipButton setBackgroundColor:[UIColor grayColor]];
    // [skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [skipButton.layer setCornerRadius:5.0];
    [self.skipButton.layer setCornerRadius:(self.skipButton.frame.size.height * 0.5)];
    [self.skipButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipButton];
   
    self.imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MSScreenH - 50, MSScreenW, 30)];
    self.imagePageControl.numberOfPages = images.count;
    self.imagePageControl.backgroundColor = [UIColor clearColor];
    self.imagePageControl.currentPage = 0;
    self.imagePageControl.defersCurrentPageDisplay = YES;
    [self addSubview:self.imagePageControl];
}

#pragma mark - 跳过按钮的简单设置
-(void)setSkipTitle:(NSString *)skipTitle{
    [self.skipButton setTitle:skipTitle forState:UIControlStateNormal];
}

-(void)setSkipBackgroundClolr:(UIColor *)skipBackgroundClolr{
    [self.skipButton setBackgroundColor:skipBackgroundClolr];
}

-(void)setIsHiddenSkipBtn:(BOOL)isHiddenSkipBtn{
    self.skipButton.hidden = isHiddenSkipBtn;
}

-(void)skipBtnCustom:(UIButton *(^)(void))btn{
    [self.skipButton removeFromSuperview];
    [self addSubview:btn()];   
}


#pragma mark - 立即体验按钮的简单设置
-(void)setGuideTitle:(NSString *)guideTitle{
    [self.guideBtn setTitle:guideTitle forState:UIControlStateNormal];
}

-(void)setGuideBackgroundImage:(UIImage *)guideBackgroundImage{
    [self.guideBtn setBackgroundImage:guideBackgroundImage forState:UIControlStateNormal];
}

-(void)setGuideTitleColor:(UIColor *)guideTitleColor{
    [self.guideBtn setTitleColor:guideTitleColor forState:UIControlStateNormal];
}

#pragma mark - 自定义进入按钮
-(void)guideBtnCustom:(UIButton *(^)(void))btn{
    //移除当前的体验按钮
    [self.guideBtn removeFromSuperview];
    [launchView addSubview:btn()];
}


#pragma mark - 进入按钮
-(void)enterBtnClick{
    [self hideGuidView];
}

#pragma mark - 隐藏引导页
-(void)hideGuidView{
    [UIView animateWithDuration:MSHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MSHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
}

- (void)removeGuidePageHUD {
    [self removeFromSuperview];
}


#pragma mark - APP视频新特性页面(新增测试模块内容)
- (instancetype)videoWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    return [self initWithFrame:frame videoURL:videoURL];
}

-(instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    if ([super initWithFrame:frame]) {
        self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        [self.playerController.view setFrame:frame];
        [self.playerController.view setAlpha:1.0];
        [self.playerController setControlStyle:MPMovieControlStyleNone];
        [self.playerController setRepeatMode:MPMovieRepeatModeOne];
        [self.playerController setShouldAutoplay:YES];
        [self.playerController prepareToPlay];
        [self addSubview:self.playerController.view];
        
        launchView = self.playerController.view;
        // 视频引导页进入按钮
        self.guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.guideBtn.frame = CGRectMake(20, MSScreenH-30-40, MSScreenW-40, 40);
        [self.guideBtn.layer setBorderWidth:1.0];
        [self.guideBtn.layer setCornerRadius:20.0];
        [self.guideBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.guideBtn setTitle:@"开始体验" forState:UIControlStateNormal];
        [self.guideBtn setAlpha:0.0];
        [self.playerController.view addSubview:self.guideBtn];
        
        [self.guideBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:MSHidden_TIME animations:^{
            [self.guideBtn setAlpha:1.0];
        }];
    }
    return self;
}

#pragma mark - scrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.x;//判断左右滑动时
    int cuttentIndex = (int)(lastContentOffset/MSScreenW);
    
    if (cuttentIndex == images.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!isScrollOut) {
                return ;
            }
            [self hideGuidView];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x/MSScreenW);
    self.imagePageControl.currentPage = cuttentIndex;
}
#pragma mark - 判断滚动方向
-(BOOL)isScrolltoLeft:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < lastContentOffset ){
        return YES;
    } else if (scrollView.contentOffset.x > lastContentOffset ){
        return NO;
    }
    return YES;
}
#pragma mark - KVO监测值的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentColor"]) {
        self.imagePageControl.currentPageIndicatorTintColor = self.currentColor;
    }
    if ([keyPath isEqualToString:@"nomalColor"]) {
        self.imagePageControl.pageIndicatorTintColor = self.nomalColor;
    }
}
@end

