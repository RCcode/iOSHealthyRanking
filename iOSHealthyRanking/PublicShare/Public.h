//
//  Public.h
//  InstaShot
//
//  Created by TCH on 14-8-5.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#ifndef InstaShot_Public_h
#define InstaShot_Public_h

#define UmengAPPKey @"555af7a967e58e372f002d70"

#define kAppID @"994404644"
#define kAppStoreURLPre @"itms-apps://itunes.apple.com/app/id"
#define kAppStoreURL [NSString stringWithFormat:@"%@%@", kAppStoreURLPre, kAppID]

#define kAppStoreScoreURLPre @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
#define kAppStoreScoreURL [NSString stringWithFormat:@"%@%@", kAppStoreScoreURLPre, kAppID]






//#define kMoreAppID 22005
#define kMoreAppID 28001
#define kMoreAppBaseURL @"http://moreapp.rcplatformhk.net/pbweb/app/getIOSAppListNew.do"
//
#define AdMobID @""
//#define AdMobID @"ca-app-pub-3747943735238482/9860250656"
#define AdUrl @"http://ads.rcplatformhk.com/AdlayoutBossWeb/platform/getRcAppAdmob.do"

//#define kFollwUsAccount @"viddo_rc"
//#define kFollowUsURL @"http://www.instagram.com/viddo"
#define kFeedbackEmail @"rcplatform.help@gmail.com"

#define kPushURL @"http://iospush.rcplatformhk.net/IOSPushWeb/userinfo/regiUserInfo.do"

#define kShareHotTags @"Made with @Ideavid #Ideavid"

//key
#define UDKEY_ShareCount @"shareCount"
#define UDKEY_DEVICETOKEN @"deviceToken"

#define isFirstLaunch @"isFirstLaunch"
#define showCount @"showCount"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define NavBarHeight 44
#define Height5 568
#define ScreenHeightHaveNavBar [[UIScreen mainScreen] bounds].size.height - NavBarHeight

#define iPhone6plus ([[UIScreen mainScreen] bounds].size.height ==736)
#define iPhone6 ([[UIScreen mainScreen] bounds].size.height ==667)
#define iPhone5 ([[UIScreen mainScreen] bounds].size.height ==568)
#define iPhone4 ([[UIScreen mainScreen] bounds].size.height ==480)
//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
//判断是否为iPhone5
#define IS_IPHONE_5_SCREEN [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f
#define IS_IOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?1:0)
#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0)
#define IS_IOS_6 (([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)?1:0)
#define IS_IOS_5 (([[[UIDevice currentDevice] systemVersion] floatValue]<6.0)?1:0)

#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)

#endif
