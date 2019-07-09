//
//  MSLaunchView.m
//  MSLaunchView
//
//  Created by TuBo on 2018/11/8.
//  Copyright © 2018 TuBur. All rights reserved.
//

#import "MSLaunchView.h"
#import "MSLaunchOperation.h"
#import "MSPageControl.h"

#define MSHidden_TIME 1.0
#define MSScreenW   [UIScreen mainScreen].bounds.size.width
#define MSScreenH   [UIScreen mainScreen].bounds.size.height

#define MS_LAZY(object,assignment) (object = object ?:assignment)
#define kCycleScrollViewInitialPageControlDotSize CGSizeMake(8, 8)

@interface MSLaunchView()<UIScrollViewDelegate>{
    UIImageView *launchView;//获取到最后一个imageView 添加自定义按钮
    //
    CGFloat oldlastContentOffset;
    CGFloat newlastContentOffset;
    
    CGRect guideFrame;//
    CGRect videoFrame;
    UIImage *gbgImage;//按钮背景图片
}
@property (nonatomic, strong) UIButton *skipButton;//跳过按钮
@property (nonatomic, strong) UIButton *guideButton;//立即进入按钮
@property (nonatomic, strong) MSPageControl *pageControl;
@property (nonatomic, strong) AVPlayerViewController  *playerController;//视频播放
@property (nonatomic, copy) NSMutableArray<NSString *> *dataImages; //图片数据
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL isScrollOut;//是否左滑推出

@property (nonatomic, strong) UIScrollView *scrollView;

@end

static NSString *const kAppVersion = @"appVersion";

@implementation MSLaunchView

#pragma mark - 创建对象-->>不带button 左滑动消失
+(instancetype) launchWithImages:(NSArray <NSString *>*)images isScrollOut:(BOOL)isScrollOut{
    return [[MSLaunchView alloc] initWithVideoframe:CGRectZero guideFrame:CGRectZero images:images gImage:nil sbName:nil videoUrl:nil isScrollOut:isScrollOut];
}

#pragma mark - 创建对象-->>带button
+(instancetype)launchWithImages:(NSArray <NSString *>*)images guideFrame:(CGRect)gframe gImage:(UIImage *)gImage isScrollOut:(BOOL)isScrollOut{
    return [[MSLaunchView alloc] initWithVideoframe:CGRectZero guideFrame:gframe images:images gImage:gImage sbName:nil videoUrl:nil isScrollOut:isScrollOut];
}

#pragma mark - 用storyboard创建的项目时调用，不带button左滑动不消失
+(instancetype)launchWithImages:(NSArray <NSString *>*)images sbName:(NSString *)sbName isScrollOut:(BOOL)isScrollOut{
    return [[MSLaunchView alloc] initWithVideoframe:CGRectZero guideFrame:CGRectZero images:images gImage:nil sbName:![MSLaunchView isBlankString:sbName]? sbName:@"Main" videoUrl:nil isScrollOut:isScrollOut];
}

#pragma mark - 用storyboard创建的项目时调用，带button左滑动不消失
+(instancetype)launchWithImages:(NSArray <NSString *>*)images sbName:(NSString *)sbName guideFrame:(CGRect)gframe gImage:(UIImage *)gImage isScrollOut:(BOOL)isScrollOut{
    return [[MSLaunchView alloc] initWithVideoframe:CGRectZero guideFrame:gframe images:images gImage:nil sbName:![MSLaunchView isBlankString:sbName]? sbName:@"Main" videoUrl:nil isScrollOut:isScrollOut];
}


#pragma  mark - 关于Video引导页

#pragma mark - 创建对象，不带button 左滑动消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL{
    return [[MSLaunchView alloc] initWithVideoframe:videoFrame guideFrame:CGRectZero images:nil gImage:nil sbName:nil videoUrl:videoURL isScrollOut:YES];
}

#pragma mark - 创建对象，不带button 左滑动不消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL guideFrame:(CGRect)gframe gImage:(UIImage *)gImage{
    return [[MSLaunchView alloc] initWithVideoframe:videoFrame guideFrame:gframe images:nil gImage:gImage sbName:nil videoUrl:videoURL isScrollOut:NO];
}


#pragma mark - 用storyboard创建的项目时调用，不带button左滑动消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL sbName:(NSString *)sbName{
    return [[MSLaunchView alloc] initWithVideoframe:videoFrame guideFrame:CGRectZero images:nil gImage:nil sbName:![MSLaunchView isBlankString:sbName]? sbName:@"Main" videoUrl:videoURL isScrollOut:YES];
}

#pragma mark - 用storyboard创建的项目时调用，带button左滑动不消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL sbName:(NSString *)sbName guideFrame:(CGRect)gframe gImage:(UIImage *)gImage {
    return [[MSLaunchView alloc] initWithVideoframe:videoFrame guideFrame:gframe images:nil gImage:gImage sbName:![MSLaunchView isBlankString:sbName]? sbName:@"Main" videoUrl:videoURL isScrollOut:NO];
}


#pragma mark - 初始化
- (instancetype)initWithVideoframe:(CGRect)frame guideFrame:(CGRect)gframe images:(NSArray <NSString *>*)images gImage:(UIImage *)gImage sbName:(NSString *)sbName videoUrl:(NSURL *)videoUrl isScrollOut:(BOOL)isScrollOut{
    self = [super init];
    if (self) {
 
        self.frame = CGRectMake(0, 0, MSScreenW, MSScreenH);
        self.backgroundColor = [UIColor whiteColor];
        if (images.count>0) {
            self.dataImages = [NSMutableArray arrayWithArray:images];
        }
        
        //初始化默认数据
        [self initialization];
        
        self.videoUrl = videoUrl;
        videoFrame = frame;
        guideFrame = gframe;
        gbgImage = gImage;
        self.isScrollOut = isScrollOut;
        self.isPalyEndOut = YES;
        self.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        if ([MSLaunchView isFirstLaunch]) {
            //保存当前的最新版本号
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
            [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            
            if (sbName != nil) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:sbName bundle:nil];
                UIViewController * vc = story.instantiateInitialViewController;
                window.rootViewController = vc;
                [vc.view addSubview:self];
            }else{
                [window addSubview:self];
            }

            if (videoUrl && images == nil) {
                [self addVideo];
            }else{
                [self addImages];
                [self setupPageControl];
            }
        }else{
            [self removeGuidePageHUD];
        }
    }
    return self;
}

- (void)initialization{
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    _showPageControl = YES;
    _pageControlDotSize = kCycleScrollViewInitialPageControlDotSize;
    _pageControlBottomOffset = 0;
    _pageControlRightOffset = 0;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _spacingBetweenDots = 8;
    _currentWidthMultiple = 1;//当前选中点宽度与未选中点的宽度的倍数，默认为1倍
    _dotsIsSquare = NO;//默认是圆点
    _lastDotsIsHidden = NO;
    _currentDotBorderWidth = 0;
    _currentDotBorderColor = [UIColor clearColor];
    
    _dotBorderColor = [UIColor whiteColor];
    _dotBorderWidth = 0;
    
    _pageControlStyle = MSPageControlStyleSystem;
    _pageControlAnimation = MSPageControlAnimationNone;
    
    self.textFont = [UIFont systemFontOfSize:9];
    self.textColor = [UIColor blackColor];
}


#pragma mark - 判断是不是首次登录或者版本更新
+ (BOOL) isFirstLaunch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if ([MSLaunchView isBlankString:version] || ![version isEqualToString:currentAppVersion]) {
        return YES;
    }else{
        return NO;
    }
}



#pragma mark - 创建滚动视图、添加引导页图片
-(void)addImages{
    
    self.scrollView.contentSize = CGSizeMake(MSScreenW * self.dataImages.count, MSScreenH);
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < self.dataImages.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * MSScreenW, 0, MSScreenW, MSScreenH)];
        imageView.userInteractionEnabled = YES;
        if ([[MSLaunchOperation ms_contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataImages[i] ofType:nil]]] isEqualToString:@"gif"]) {
            NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataImages[i] ofType:nil]];
            imageView = (UIImageView *)[[MSLaunchOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
            [_scrollView addSubview:imageView];
        } else {
            imageView.image = [UIImage imageNamed:self.dataImages[i]];
            [_scrollView addSubview:imageView];
        }
        
        if (i == self.dataImages.count - 1) {
            //拿到最后一个图片，添加自定义体验按钮
            launchView = imageView;
            //判断要不要添加button
            if (!self.isScrollOut) {
                [imageView addSubview:self.guideButton];
            }
        }
    }
    
    [self addSubview:self.skipButton];
}


#pragma mark - APP视频新特性页面(新增测试模块内容)
-(void)addVideo{
    
    [self addSubview:self.playerController.view];
    [self addSubview:self.guideButton];

    [UIView animateWithDuration:MSHidden_TIME animations:^{
        [self.guideButton setAlpha:1.0];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideGuidView) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self addSubview:self.skipButton];

}

#pragma mark -- >> 自定义属性设置

#pragma mark - 跳过按钮的简单设置
-(void)setSkipTitle:(NSString *)skipTitle{
    [self.skipButton setTitle:skipTitle forState:UIControlStateNormal];
}

-(void)setSkipBackgroundColor:(UIColor *)skipBackgroundColor{
    [self.skipButton setBackgroundColor:skipBackgroundColor];
}

-(void)setSkipBackgroundImage:(UIImage *)skipBackgroundImage{
    [self.skipButton setBackgroundImage:skipBackgroundImage forState:UIControlStateNormal];
}

-(void)setSkipTitleColor:(UIColor *)skipTitleColor{
    [self.skipButton setTitleColor:skipTitleColor forState:UIControlStateNormal];
}

-(void)setSkipTitleFont:(UIFont *)skipTitleFont{
    self.skipButton.titleLabel.font = skipTitleFont;
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
    [self.guideButton setTitle:guideTitle forState:UIControlStateNormal];
}

-(void)setGuideBackgroundImage:(UIImage *)guideBackgroundImage{
    [self.guideButton setBackgroundImage:guideBackgroundImage forState:UIControlStateNormal];
}

-(void)setGuideTitleColor:(UIColor *)guideTitleColor{
    [self.guideButton setTitleColor:guideTitleColor forState:UIControlStateNormal];
}

-(void)setGuideTitleFont:(UIFont *)guideTitleFont{
    self.guideButton.titleLabel.font = guideTitleFont;
}

#pragma mark - 自定义进入按钮
-(void)guideBtnCustom:(UIButton *(^)(void))btn{
    
    if(guideFrame.size.height || guideFrame.origin.x) return;
    
    //移除当前的体验按钮
    [self.guideButton removeFromSuperview];
    if (_videoUrl) {
        [self addSubview:btn()];
    }else{
        [launchView addSubview:btn()];
    }
}

#pragma mark - UIPageControl简单设置
-(void)setLastDotsIsHidden:(BOOL)lastDotsIsHidden{
    _lastDotsIsHidden = lastDotsIsHidden;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    _pageControlDotSize = pageControlDotSize;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.pageDotSize = pageControlDotSize;
}

- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

-(void)setSpacingBetweenDots:(CGFloat)spacingBetweenDots{
    if (_spacingBetweenDots == spacingBetweenDots) return;
    
    _spacingBetweenDots = spacingBetweenDots;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.spacingBetweenDots = spacingBetweenDots;
}

- (void)setDotBorderWidth:(CGFloat)dotBorderWidth{
    if (_dotBorderWidth == dotBorderWidth) return;
    
    _dotBorderWidth = dotBorderWidth;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.dotBorderWidth = dotBorderWidth;
}

-(void)setCurrentDotBorderWidth:(CGFloat)currentDotBorderWidth{
    if (_currentDotBorderWidth == currentDotBorderWidth) return;
    _currentDotBorderWidth = currentDotBorderWidth;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.currentDotBorderWidth = currentDotBorderWidth;
    
}

-(void)setDotBorderColor:(UIColor *)dotBorderColor{
    if (_dotBorderColor == dotBorderColor) return;
    _dotBorderColor = dotBorderColor;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.dotBorderColor = dotBorderColor;
}
-(void)setPageControlAnimation:(MSPageControlAnimation)pageControlAnimation{
    if (_pageControlAnimation == pageControlAnimation) return;
    _pageControlAnimation = pageControlAnimation;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.pageControlAnimation = pageControlAnimation;
}

-(void)setCurrentDotBorderColor:(UIColor *)currentDotBorderColor{
    if (_currentDotBorderColor == currentDotBorderColor) return;
    
    _currentDotBorderColor = currentDotBorderColor;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.currentDotBorderColor = currentDotBorderColor;
}

-(void)setCurrentWidthMultiple:(CGFloat)currentWidthMultiple{
    if (_currentWidthMultiple == currentWidthMultiple) return;
    
    _currentWidthMultiple = currentWidthMultiple;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.currentWidthMultiple = currentWidthMultiple;
}

-(void)setDotsIsSquare:(BOOL)dotsIsSquare{
    if (_dotsIsSquare == dotsIsSquare) return;
    _dotsIsSquare = dotsIsSquare;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.dotsIsSquare = dotsIsSquare;
}

-(void)setPageControlStyle:(MSPageControlStyle)pageControlStyle{
    if (_pageControlStyle == pageControlStyle) return;
    _pageControlStyle = pageControlStyle;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.pageControlStyle = pageControlStyle;
}


- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;

    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.currentDotColor = currentPageDotColor;
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    if (_pageDotColor == pageDotColor) return;
    _pageDotColor = pageDotColor;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.dotColor = pageDotColor;
}
-(void)setTextFont:(UIFont *)textFont{
    if (_textFont == textFont) return;
    _textFont = textFont;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.textFont = textFont;
}

-(void)setTextColor:(UIColor *)textColor{
    if (_textColor == textColor) return;
    _textColor = textColor;
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.textColor = textColor;
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage
{
    _currentPageDotImage = currentPageDotImage;
    
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage
{
    _pageDotImage = pageDotImage;
    
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}


- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot
{
    if (!image || !self.pageControl) return;
    
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage = image;
        }
    }
}

#pragma mark - UIPageControl简单设置


-(void)setVideoGravity:(AVLayerVideoGravity)videoGravity{
    self.playerController.videoGravity = videoGravity;
}

-(void)setIsPalyEndOut:(BOOL)isPalyEndOut{
    if (!isPalyEndOut) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - 隐藏引导页

-(void)hideGuidView{
    
    [UIView animateWithDuration:MSHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MSHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchViewLoadFinish:)]) {
        [self.delegate launchViewLoadFinish:self];
    }
    
    if (self.loadFinishBlock) {
        self.loadFinishBlock(self);
    }
}

- (void)removeGuidePageHUD {
    //解决第二次进入视屏不显示还能听到声音的BUG
    if (self.videoUrl) {
        self.playerController = nil;
    }
    [self removeFromSuperview];
}



#pragma mark - ScrollerView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    oldlastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    newlastContentOffset = scrollView.contentOffset.x;
    int cuttentIndex = [self currentIndex];
    
    if (cuttentIndex == self.dataImages.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!self.isScrollOut) {
                return ;
            }
            [self hideGuidView];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.dataImages.count) return;
    int cuttentIndex = (int)(scrollView.contentOffset.x/MSScreenW);
    if (self.lastDotsIsHidden && cuttentIndex == self.dataImages.count - 1) {
        return;
    }
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    pageControl.currentPage = [self currentIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int cuttentIndex = (int)(scrollView.contentOffset.x/MSScreenW);
    
    MSPageControl *pageControl = (MSPageControl *)_pageControl;
    if (self.lastDotsIsHidden && cuttentIndex == self.dataImages.count - 1) {
        pageControl.hidden = YES;
        return;
    }
    pageControl.hidden = NO;
}

- (int)currentIndex{
    int index = 0;
    index = (_scrollView.contentOffset.x) / MSScreenW;
    return MAX(0, index);
}


#pragma mark - 判断滚动方向
-(BOOL)isScrolltoLeft:(UIScrollView *)scrollView{
    if (oldlastContentOffset - newlastContentOffset >0 ){
        return NO;
    }
    return YES;
}

#pragma mark - prvite void
//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] ==0) {
        return YES;
    }
    
    return NO;
}

- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    
    if (!self.showPageControl) return;
    
    if (self.dataImages.count == 0) return;
//
    if (self.dataImages.count == 1) return;

    [self addSubview:self.pageControl];
    
    // 重设pagecontroldot图片
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize size = CGSizeZero;
    
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kCycleScrollViewInitialPageControlDotSize, self.pageControlDotSize))) {
            pageControl.pageDotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.dataImages.count];
    } else {
        size = CGSizeMake(self.dataImages.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    }
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
//    if (self.pageControlAliment == kMSPageContolAlimentRight) {
//        x = self.mainView.sd_width - size.width - 10;
//    }
    CGFloat y = self.frame.size.height - size.height - 20;
    
    if ([self.pageControl isKindOfClass:[MSPageControl class]]) {
        MSPageControl *pageControl = (MSPageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
//    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
    
}

#pragma mark - >> 懒加载部分
-(MSPageControl *)pageControl{
   return MS_LAZY(_pageControl,({
        MSPageControl *pageControl = [[MSPageControl alloc] init];
        pageControl.numberOfPages = self.dataImages.count;
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPage = [self currentIndex];
        pageControl;
    }));
}
#pragma mark - 跳过按钮
-(UIButton *)skipButton{
    return MS_LAZY(_skipButton, ({
        // 设置引导页上的跳过按钮
        UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        skipButton.frame = CGRectMake(MSScreenW*0.8, MSScreenW*0.1, 50, 25);
        [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [skipButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [skipButton setBackgroundColor:[UIColor grayColor]];
        [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [skipButton.layer setCornerRadius:(skipButton.frame.size.height * 0.5)];
        [skipButton addTarget:self action:@selector(hideGuidView) forControlEvents:UIControlEventTouchUpInside];
        skipButton;
    }));
}

#pragma mark - 进入按钮
-(UIButton *)guideButton{
    return MS_LAZY(_guideButton, ({
        // 设置引导页上的跳过按钮
        //CGRectMake(MSScreenW*0.3, MSScreenH*0.8, MSScreenW*0.4, MSScreenH*0.08)
        UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        guideButton.frame = guideFrame;
        [guideButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [guideButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [guideButton setBackgroundImage:gbgImage forState:UIControlStateNormal];
        [guideButton.titleLabel setFont:[UIFont systemFontOfSize:21]];
        [guideButton addTarget:self action:@selector(hideGuidView) forControlEvents:UIControlEventTouchUpInside];
        guideButton;
    }));
}


#pragma mark - 视频播放VC
-(AVPlayerViewController *)playerController{
    return MS_LAZY(_playerController, ({
        AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
        playerController.view.frame = videoFrame;
        playerController.view.backgroundColor = [UIColor whiteColor];
        [playerController.view setAlpha:1.0];
        playerController.player = [[AVPlayer alloc] initWithURL:self.videoUrl];
        playerController.videoGravity = self.videoGravity;
        playerController.showsPlaybackControls = NO;
        [playerController.player play];
        playerController;
    }));
}

- (UIScrollView *)scrollView{
    return MS_LAZY(_scrollView, ({
        UIScrollView *launchScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        launchScrollView.showsHorizontalScrollIndicator = NO;
        launchScrollView.bounces = NO;
        launchScrollView.pagingEnabled = YES;
        launchScrollView.delegate = self;
        launchScrollView;
    }));
}

@end


