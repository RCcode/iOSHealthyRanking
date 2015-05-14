//
//  IS_MobAndAnalyticsManager.h
//  iOSNoCropVideo
//
//  Created by TCH on 14-8-14.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADInterstitial.h"

@interface IS_MobAndAnalyticsManager : NSObject

//广告条
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) GADInterstitial *interstitial;

+ (IS_MobAndAnalyticsManager *)shareInstance;

/**
 *  全局公用统计分析方法
 */
+ (void)event:(NSString *)event label:(NSString *)label;

@end
