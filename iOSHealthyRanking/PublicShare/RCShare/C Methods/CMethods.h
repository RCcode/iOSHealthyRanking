//
//  CMethods.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include <stdio.h>

@interface CMethods : NSObject
{
    
}

//十六进制颜色值
UIColor* colorWithHexString(NSString *stringToConvert);
//当前应用的版本
NSString *appVersion();
//统一使用它做 应用本地化 操作
NSString *LocalizedString(NSString *translation_key, id none);
//获取设备型号
NSString *doDevicePlatform();

NSString *stringFromDate(NSDate *date);

void showLabelHUD(NSString *content);

@end
