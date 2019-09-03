//
//  AppDelegate.m
//  MSLaunchView
//
//  Created by TuBo on 2018/11/8.
//  Copyright © 2018 TuBur. All rights reserved.
//

#import "AppDelegate.h"
#import "MSLaunchView.h"

#define MSScreenW   [UIScreen mainScreen].bounds.size.width
#define MSScreenH   [UIScreen mainScreen].bounds.size.height
@interface AppDelegate ()<MSLaunchViewDeleagte>{
    MSLaunchView *_launchView;
}

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    if (kisFirstLaunch) {//或者使用[MSLaunchView isFirstLaunch]判断是否是第一次进入
        
        NSArray *imageNameArray = @[@"Untitled-4.gif",@"Untitled-6.gif",@"Untitled-7.gif"];
        CGRect rt = CGRectMake(MSScreenW*0.3, MSScreenH*0.8, MSScreenW*0.4, MSScreenH*0.08);
        
#pragma mark ---->>带立即体验按钮，项目是SB创建的 (此方法初始化，则guideBtnCustom：方法失效)
//        MSLaunchView *launchView = [MSLaunchView launchWithImages:imageNameArray sbName:@"" guideFrame:rt gImage:[UIImage imageNamed:@""] isScrollOut:YES];
#pragma mark ---->>不带立即体验按钮 项目是SB创建的
//        MSLaunchView *launchView = [MSLaunchView launchWithImages:imageNameArray sbName:@"" isScrollOut:NO];
#pragma mark ---->>不带立即按钮 代码创建项目
//        MSLaunchView *launchView = [MSLaunchView launchWithImages:imageNameArray isScrollOut:YES];
#pragma mark ---->>带立即按钮 代码创建项目
        MSLaunchView *launchView = [MSLaunchView launchWithImages:imageNameArray guideFrame:rt gImage:[UIImage imageNamed:@""] isScrollOut:NO];

        
#pragma mark ---->>关于Video 没有立即进入按钮
//        NSString *path  = [[NSBundle mainBundle]  pathForResource:@"测试" ofType:@"mp4"];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        MSLaunchView *launchView = [MSLaunchView launchWithVideo:CGRectMake(0, 0, MSScreenW, MSScreenH) videoURL:url];
//        launchView.videoGravity = AVLayerVideoGravityResize;
//        launchView.isPalyEndOut = YES;//
        
        launchView.guideTitle = @"进入当前界面";
        launchView.guideTitleColor = [UIColor blackColor];
        launchView.guideTitleFont = [UIFont systemFontOfSize:17];
        
#pragma mark ---->>跳过按钮自定义属性
        launchView.skipTitle = @"跳过";
        launchView.skipTitleColor = [UIColor whiteColor];
        launchView.skipTitleFont = [UIFont systemFontOfSize:15];
        launchView.skipBackgroundColor = [UIColor redColor];
        launchView.skipBackgroundImage = [UIImage imageNamed:@""];
        
        
#pragma mark ---->>PageControl自定义属性

//        launchView.showPageControl = NO;
        //pageControl的间距大小
//        launchView.pageControlStyle = MSPageControlStyleNumber;
     
//        launchView.pageControlBottomOffset += 25;
        launchView.pageDotColor = [UIColor redColor];
        launchView.currentPageDotColor = [UIColor yellowColor];
        launchView.textFont = [UIFont systemFontOfSize:9 weight:UIFontWeightBold];
        launchView.textColor = [UIColor blackColor];
        launchView.dotsIsSquare = NO;
        launchView.spacingBetweenDots = 15;
      
        launchView.dotBorderWidth = 2;
        launchView.dotBorderColor = [UIColor blueColor];
        launchView.currentDotBorderWidth = 2;
        launchView.currentDotBorderColor = [UIColor redColor];
        launchView.delegate = self;
        //设置了pageDotImage和currentPageDotImage图片 pageControlDotSize和currentWidthMultiple将失效
        launchView.pageControlDotSize = CGSizeMake(20, 20);
        launchView.currentWidthMultiple =  3;
        
        launchView.lastDotsIsHidden = YES;//最后一个页面时是否隐藏PageControl 默认为NO
        launchView.pageDotImage = [UIImage imageNamed:@"Ktv_ic_share_qq"];
        launchView.currentPageDotImage = [UIImage imageNamed:@"Ktv_ic_share_weixin"];
        launchView.loadFinishBlock = ^(MSLaunchView * _Nonnull launchView) {
            NSLog(@"广告加载完成了");
        };
        
#pragma mark ---->>自定义立即体验按钮
        [launchView guideBtnCustom:^UIButton * _Nonnull{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(60, 60, 130, 60);
            [btn setBackgroundColor:[UIColor redColor]];
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(hidde) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }];
        
#pragma mark ---->>自定义跳过按钮

//        [launchView skipBtnCustom:^UIButton * _Nonnull{
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame = CGRectMake(60, 200, 120, 120);
//            [btn setBackgroundColor:[UIColor blueColor]];
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [btn setTitle:@"跳过按钮" forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(hidde) forControlEvents:UIControlEventTouchUpInside];
//            return btn;
//        }];

        _launchView = launchView;
    }

    return YES;
}

-(void)hidde{
    [_launchView hideGuidView];
}

-(void)launchViewLoadFinish:(MSLaunchView *)launchView{
    NSLog(@"代理方法进入======广告加载完成了");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
