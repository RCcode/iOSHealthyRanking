//
//  AppDelegate.h
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import <HealthKit/HealthKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UserInfo *userInfo;

@end

