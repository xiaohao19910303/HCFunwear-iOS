//
//  AppDelegate.m
//  HCFunwear
//
//  Created by 刘海川 on 16/5/16.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import "AppDelegate.h"

#import "HCTabItem.h"
#import "HCTabBar.h"
#import "HCTabButton.h"
#import "HCTabBarController.h"

#import "MainStyleViewController.h"
#import "HomePageViewController.h"
#import "CategoryPageViewController.h"
#import "InspirationPageViewController.h"
#import "ShoppingBagPageViewController.h"
#import "MinePageViewController.h"

#import "GlobalContext.h"
#import "GlobalConfig.h"
#import "GlobalColors.h"
#import "HCNavigationControllerStack.h"

#import "HomePageViewModel.h"
#import "CategoryPageViewModel.h"
#import "InspirationPageViewModel.h"
#import "MinePageViewModel.h"

#import "HCCategoryViewModelServicesImp.h"
#import "HCInspirationViewModelServiceImp.h"
#import "HCProductDetailViewModelServiceImp.h"
#import "HCHomeViewModelServiceImpl.h"

@interface AppDelegate () <HCTabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //配置网络服务
    GlobalConfig *configManager = [GlobalConfig new];
    [configManager configDefaultNetworkParameters];
    [configManager configLog];
    
    self.window = [[HCWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    HCTabBarController *tabBarController = [self configTabBarController];
    tabBarController.automaticallyAdjustsScrollViewInsets = NO;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:tabBarController];
    
    //默认广告页
    MainStyleViewController *mainStyleController = [[MainStyleViewController alloc] initWithNibName:@"MainStyleViewController" bundle:nil];
    self.window.rootViewController = mainStyleController;
    [self.window makeKeyAndVisible];
    
    //只是检测 CPU 的
    [self.window fpsLabelWithSwitch:YES];
    //纪录到全局环境中
    [GlobalContext ShareInstance].mainTabBarController = tabBarController;
    [GlobalContext ShareInstance].applicationWindow = self.window;
    [GlobalContext ShareInstance].rootController = navigationController;
    //配置导航栈
    [[HCNavigationControllerStack sharedInstance] pushNavigationController:navigationController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - launchConfig
- (HCTabBarController *)configTabBarController {
    
    HCTabItem *homePageTabItem = [[HCTabItem alloc]initWithTitle:@"首页"
                                                           image:[UIImage imageNamed:@"tab_home_n"]
                                                   selectedImage:[UIImage imageNamed:@"tab_home_s"]
                                                      titleColor:kTabNormalColor
                                                   selectedColor:kTabSelectedColor];
    HCTabItem *searchTabItem = [[HCTabItem alloc]initWithTitle:@"分类"
                                                              image:[UIImage imageNamed:@"tab_search_n"]
                                                      selectedImage:[UIImage imageNamed:@"tab_search_s"]
                                                         titleColor:kTabNormalColor
                                                      selectedColor:kTabSelectedColor];
    HCTabItem *inspirationTabItem = [[HCTabItem alloc]initWithTitle:@"灵感"
                                                       image:[UIImage imageNamed:@"tab_inspiration_n"]
                                               selectedImage:[UIImage imageNamed:@"tab_inspiration_s"]
                                                  titleColor:kTabNormalColor
                                               selectedColor:kTabSelectedColor];
    HCTabItem *purchaseTabItem = [[HCTabItem alloc]initWithTitle:@"购物袋"
                                                       image:[UIImage imageNamed:@"tab_purchase_n"]
                                               selectedImage:[UIImage imageNamed:@"tab_purchase_s"]
                                                  titleColor:kTabNormalColor
                                               selectedColor:kTabSelectedColor];
    HCTabItem *mineTabItem = [[HCTabItem alloc]initWithTitle:@"我的"
                                                       image:[UIImage imageNamed:@"tab_me_n"]
                                               selectedImage:[UIImage imageNamed:@"tab_me_s"]
                                                  titleColor:kTabNormalColor
                                               selectedColor:kTabSelectedColor];
    
    HCTabButton *homePageTabButton = [[HCTabButton alloc]initWithItem:homePageTabItem];
    HCTabButton *searchTabButton = [[HCTabButton alloc]initWithItem:searchTabItem];
    HCTabButton *inspirationTabButton = [[HCTabButton alloc]initWithItem:inspirationTabItem];
    HCTabButton *purchaseTabButton = [[HCTabButton alloc]initWithItem:purchaseTabItem];
    HCTabButton *mineTabButton = [[HCTabButton alloc]initWithItem:mineTabItem];
    HCTabBar *tabBar = [[HCTabBar alloc]initWithTabViews:@[homePageTabButton,searchTabButton,inspirationTabButton,purchaseTabButton,mineTabButton]];
    /**
     *  ViewController 对应的 ViewModel 及 相关服务 Service
     */
    HCHomeViewModelServiceImpl *homeViewModelServiceImpl = [HCHomeViewModelServiceImpl new];
    HomePageViewModel *homeViewModel = [[HomePageViewModel alloc]initWithServices:homeViewModelServiceImpl];
    HomePageViewController *homePageViewController = [[HomePageViewController alloc]initWithViewModel:homeViewModel];
    
    HCCategoryViewModelServicesImp *categoryViewModelServiceImp = [HCCategoryViewModelServicesImp new];
    CategoryPageViewModel *cateViewModel = [[CategoryPageViewModel alloc] initWithServices:categoryViewModelServiceImp];
    CategoryPageViewController *categoryPageViewController = [[CategoryPageViewController alloc]initWithViewModel:cateViewModel];
    
    HCInspirationViewModelServiceImp *inspirationViewModelServiceImp = [HCInspirationViewModelServiceImp new];
    InspirationPageViewModel *InspViewModel = [[InspirationPageViewModel alloc] initWithServices:inspirationViewModelServiceImp];
    InspirationPageViewController *inspirationController = [[InspirationPageViewController alloc]initWithViewModel:InspViewModel];
    
    ShoppingBagPageViewController *shoppingBagController = [[ShoppingBagPageViewController alloc]init];
    MinePageViewModel *mineViewModel = [MinePageViewModel new];
    MinePageViewController *mineViewController = [[MinePageViewController alloc]initWithViewModel:mineViewModel];
    
    HCTabBarController *tabBarController = [[HCTabBarController alloc]initWithViewControllers:@[homePageViewController,categoryPageViewController,inspirationController,shoppingBagController,mineViewController]];
    tabBarController.delegate = self;
    tabBarController.tabBar = tabBar;
    return tabBarController;
}

#pragma mark - HCTabBarControllerDelegate
- (void)tabBarController:(HCTabBarController *)tabBarController indexOfSelectedViewController:(NSInteger)index {
    NSLog(@"当前点击的是第 %ld 个视图控制器",index);
}
- (void)tabBarController:(HCTabBarController *)tabBarController indexOfRepeatSelectedViewController:(NSInteger)index {
    NSLog(@"重复点击的是第 %ld 个视图控制器",index);
    if (index == 1 || index == 0) {
        NSLog(@"如果重复点击的是第二个，则切换第四个tabButton的item。");
//        HCTabItem *minePointTabItem = [[HCTabItem alloc]initWithTitle:@"我的"
//                                                           image:[UIImage imageNamed:@"tab_me_n_u"]
//                                                   selectedImage:[UIImage imageNamed:@"tab_me_s_u"]
//                                                      titleColor:kTabNormalColor
//                                                   selectedColor:kTabSelectedColor];
//        HCTabButton *mineTabButton = tabBarController.tabBar.tabButtonList.lastObject;
//        [mineTabButton updateItem:minePointTabItem];
        
//        [[GlobalContext ShareInstance].rootController popViewControllerAnimated:YES];
        
        [tabBarController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
