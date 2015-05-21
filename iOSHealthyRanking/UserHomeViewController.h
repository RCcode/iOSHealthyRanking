//
//  UserHomeViewController.h
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/14.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RC_BaseViewController.h"
#import "UserInfo.h"

@interface UserHomeViewController : RC_BaseViewController

@property (nonatomic,strong) UserInfo *userInfo;
@property (nonatomic) BOOL canShare;

@end
