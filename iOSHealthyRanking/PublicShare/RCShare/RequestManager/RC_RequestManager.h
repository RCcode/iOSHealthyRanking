//
//  RC_RequestManager.h
//  FacebookHealth
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RC_RequestManager : NSObject

+ (RC_RequestManager *)shareInstance;

- (void)registerToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

- (void)cancleAllRequests;

@end
