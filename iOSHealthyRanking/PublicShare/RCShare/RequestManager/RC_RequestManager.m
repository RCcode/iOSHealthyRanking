//
//  RC_RequestManager.m
//  FacebookHealth
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RC_RequestManager.h"
#import "AFNetworking.h"
#import "Reachability.h"

//#define PostUserInfoURL @"http://192.168.0.88:8081/AdlayoutBossWeb/user/updateHealthyData.do"
//
//#define GetRankingURL @"http://192.168.0.88:8081/AdlayoutBossWeb/user/getHealthyData.do"

#define PostUserInfoURL @"http://healthy.rcplatformhk.net/HealthyRankingWeb/healthy/updateHealthyData.do"

#define GetRankingURL @"http://healthy.rcplatformhk.net/HealthyRankingWeb/healthy/getHealthyData.do"

@interface RC_RequestManager()

@property (nonatomic,strong) AFHTTPRequestOperationManager *operation;

@end

@implementation RC_RequestManager

static RC_RequestManager *requestManager = nil;

+ (RC_RequestManager *)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        requestManager = [[RC_RequestManager alloc]init];
        requestManager.operation = [AFHTTPRequestOperationManager manager];
    });
    return requestManager;
}

#pragma mark -
#pragma mark 公共请求 （Get）

-(void)requestServiceWithGet:(NSString *)url_Str success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    _operation.requestSerializer = requestSerializer;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _operation.responseSerializer = responseSerializer;
    
    [_operation GET:url_Str parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //解析数据
                if (success) {
                    success(responseObject);
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
    
}

#pragma mark -
#pragma mark 公共请求 （Post）

- (void)requestServiceWithPost:(NSString *)url_Str parameters:(id)parameters jsonRequestSerializer:(AFJSONRequestSerializer *)requestSerializer success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    _operation.requestSerializer = requestSerializer;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _operation.responseSerializer = responseSerializer;

    [_operation POST:url_Str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析数据
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark -
#pragma mark 注册设备

- (void)registerToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    [self requestServiceWithPost:kPushURL parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark 上传用户信息

- (void)postUserDate:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];

    [self requestServiceWithPost:PostUserInfoURL parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

#pragma mark -
#pragma mark 获取排名

- (void)getRanking:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    [self requestServiceWithPost:GetRankingURL parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark 检测网络状态

- (BOOL)checkNetWorking
{
    BOOL connected = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ? YES : NO;
    
    return connected;
}

- (void)cancleAllRequests
{
    [_operation.operationQueue cancelAllOperations];
}


@end
