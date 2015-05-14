//
//  RC_LocalDataManager.m
//  FacebookHealth
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RC_LocalDataManager.h"

@implementation RC_LocalDataManager

static RC_LocalDataManager *localDataManager = nil;

+ (RC_LocalDataManager *)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        localDataManager = [[RC_LocalDataManager alloc]init];
    });
    return localDataManager;
}

@end
