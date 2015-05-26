//
//  AppDelegate.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "RankingViewController.h"
//#import "HealthManager.h"
#import "MobClick.h"

@interface AppDelegate ()

@property (nonatomic,strong) RankingViewController *rankingViewController;

@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"获得本地通知");
    //点击提示框的打开
    application.applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册通知
    [self registNotification];
    [self addPush];
    application.applicationIconBadgeNumber = 0;
    
    //初始化统计相关（友盟、Flurry、GA）
    [self setupAnalytics];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _userInfo = [[UserInfo alloc]init];
    NSString *facebookid = [[NSUserDefaults standardUserDefaults]objectForKey:@"facebookid"];
    NSString *facebookname = [[NSUserDefaults standardUserDefaults]objectForKey:@"facebookname"];
    NSString *mainurl = [[NSUserDefaults standardUserDefaults]objectForKey:@"mainurl"];
    NSString *headurl = [[NSUserDefaults standardUserDefaults]objectForKey:@"headurl"];
    if (facebookid) {
        _userInfo.facebookid = facebookid;
    }
    if (facebookname) {
        _userInfo.facebookname = facebookname;
    }
    if (mainurl) {
        _userInfo.mainurl = mainurl;
    }
    if (headurl) {
        _userInfo.headurl = headurl;
    }
    
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    self.window.rootViewController = loginViewController;
    
    [self.window makeKeyAndVisible];

    
    
    
    
    
    
    
    
    
//    NSString *isLogin = [[NSUserDefaults standardUserDefaults]objectForKey:@"successLogin"];
//    
////    __weak AppDelegate *weakSelf = self;
//    if (isLogin && [isLogin integerValue] == 1) {
//        
//        [[FacebookManager shareManager]loginSuccess:^{
////            [weakSelf successLogin];
//            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"successLogin"];
//        } andFailed:^(NSError *error) {
//            NSLog(@"%@",error);
//        }];
//
//        _rankingViewController = [[RankingViewController alloc]init];
//        _rankingViewController.userInfo = _userInfo;
//        RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:_rankingViewController];
//        self.window.rootViewController = nav;
//    }
//    else
//    {
//        LoginViewController *loginViewController = [[LoginViewController alloc]init];
//        self.window.rootViewController = loginViewController;
//    }
//    [self.window makeKeyAndVisible];
    
    
    
    
    
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjects:@[@"1000009",@"20150514",@"560",@"6",@"1980",@"5000",@"549001",@"usename8",@"http://8",@"http://28"] forKeys:@[@"facebookid",@"dateid",@"steps",@"floors",@"distance",@"maxSteps",@"totalSteps",@"facebookname",@"headurl",@"mainurl"]];
//    [[RC_RequestManager shareInstance]postUserDate:dic success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } andFailed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    
//    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@[@"1000013",@"1000012"],@"facebookid",@"20150515",@"dateid", nil];
//    [[RC_RequestManager shareInstance]getRanking:dic1 success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } andFailed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//
//    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSArray arrayWithObjects:@"1000013", nil],@"facebookid",@"20150515",@"dateid", nil];
//    [[RC_RequestManager shareInstance]getRanking:dic2 success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } andFailed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    return YES;
}

#pragma mark -
#pragma mark 初始化统计相关
- (void)setupAnalytics{
    
    //友盟
    [MobClick startWithAppkey:UmengAPPKey reportPolicy:SEND_ON_EXIT channelId:@"App Store"];
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick updateOnlineConfig];
    
}

-(void)addPush
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    notification.repeatInterval = kCFCalendarUnitDay;
    
    notification.timeZone=[NSTimeZone defaultTimeZone];
    
    notification.applicationIconBadgeNumber = 1;
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    
    NSString  * nsStringDate12 =  [NSString  stringWithFormat:@"%d-%d-%d-%d-%d-%d",
                                   
                                   2015, 05, 22, 21, 30, 01  ];
    
    NSDate  * todayTwelve=[dateformatter dateFromString: nsStringDate12];
    
    notification.fireDate = todayTwelve;
    
    notification.alertBody=@"View today's sports data";
    
    notification.alertAction = @"打开";
    
    // 通知提示音 使用默认的
    
    notification.soundName= UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


#pragma mark -
#pragma mark 注册通知

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
//    NSRange range = NSMakeRange(1,[[deviceToken description] length]-2);
//    NSString *deviceTokenStr = [[deviceToken description] substringWithRange:range];
//    CLog(@"deviceTokenStr==%@",deviceTokenStr);
//    
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:UDKEY_DEVICETOKEN];
//    if (token == nil || [token isKindOfClass:[NSNull class]] || ![token isEqualToString:deviceTokenStr]) {
//        
//        [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:UDKEY_DEVICETOKEN];
//        //注册token
//        [self postData:[NSString stringWithFormat:@"%@",deviceTokenStr]];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    CLog(@"Fail to Register For Remote Notificaions With Error :error = %@",error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    CLog(@"userInfo = %@",userInfo);
    
}

//- (void)registNotification{
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//}

- (void)registNotification{
    if([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)cancelNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)OpenUrl:(NSString *)urlString{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
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

@end
