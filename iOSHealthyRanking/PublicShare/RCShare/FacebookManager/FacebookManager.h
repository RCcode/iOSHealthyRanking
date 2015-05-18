//
//  FacebookManager.h
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/15.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookManager : NSObject

@property (nonatomic) BOOL isLogined;

+ (FacebookManager *)shareManager;
- (void)loginSuccess:(void(^)())success andFailed:(void (^)(NSError *error))failure;
- (void)logOut;
-(void)getUserInfoSuccess:(void(^)(NSDictionary *userInfo))success andFailed:(void (^)(NSError *error))failure;
-(void)loadfriendsSuccess:(void(^)(NSArray* friends))success andFailed:(void (^)(NSError *error))failure;
-(void)getCoverGraphPathSuccess:(void(^)(NSDictionary *dic))success andFailed:(void (^)(NSError *error))failure;
-(void)getHeadPicturePathSuccess:(void(^)(NSDictionary *dic))success andFailed:(void (^)(NSError *error))failure;

@end
