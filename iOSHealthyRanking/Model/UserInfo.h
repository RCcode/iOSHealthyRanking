//
//  UserInfo.h
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/15.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *facebookid;
@property (nonatomic, strong) NSString *facebookname;

@property (nonatomic, strong) NSString *dateid;

@property (nonatomic, strong) NSString *headurl;
@property (nonatomic, strong) NSString *mainurl;

@property (nonatomic) CGFloat maxSteps;
@property (nonatomic) CGFloat steps;
@property (nonatomic) CGFloat totalSteps;
@property (nonatomic) CGFloat distance;
@property (nonatomic) CGFloat floors;

@end
