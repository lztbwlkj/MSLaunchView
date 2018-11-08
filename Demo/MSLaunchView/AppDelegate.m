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
@interface AppDelegate (){
    MSLaunchView *_launchView;
}

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *vc = [[UIViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
//    MSLaunchView *launchView = [MSLaunchView sharedWithStoryboardName:@"Main"  images:@[@"launch1.jpg",@"launch2.jpg",@"launch3"] buttonImage:@"" buttonFrame:CGRectMake(MSScreenW*0.3, MSScreenH*0.8, MSScreenW*0.4, MSScreenH*0.08)];
    
    MSLaunchView *launchView = [MSLaunchView sharedWithImages:@[@"launch1",@"launch2",@"launch3"]];
    launchView.nomalColor = [UIColor lightGrayColor];
    launchView.currentColor = [UIColor orangeColor];
    launchView.guideTitle = @"进入当前界面";
    launchView.guideTitleColor = [UIColor redColor];
    launchView.isHiddenSkipBtn = YES;
    _launchView = launchView;
    
    [launchView guideBtnCustom:^UIButton * _Nonnull{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(60, 60, 120, 120);
        [btn setBackgroundColor:[UIColor redColor]];
        [btn addTarget:self action:@selector(hidde) forControlEvents:UIControlEventTouchUpInside];
        return btn;
    }];
    
    [launchView skipBtnCustom:^UIButton * _Nonnull{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(60, 200, 120, 120);
        [btn setBackgroundColor:[UIColor blueColor]];
        [btn addTarget:self action:@selector(hidde) forControlEvents:UIControlEventTouchUpInside];
        return btn;
    }];
    

    return YES;
}

-(void)hidde{
    [_launchView hideGuidView];
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
