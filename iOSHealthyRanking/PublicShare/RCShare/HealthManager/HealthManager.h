//
//  HealthManager.h
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/18.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface HealthManager : NSObject

+ (HealthManager *)shareManager;

@property (nonatomic) HKHealthStore *healthStore;

-(void)getAllStepCount2CompletionHandler:(void(^)(double allStepCount))handler;
-(void)getTodayStepCountCompletionHandler:(void(^)(double todayStepCount))handler;
-(void)getTodayDistanceWalkingRunningCompletionHandler:(void(^)(double todayDistanceWalkingRunning))handler;
-(void)getTodayFlightsClimbedCompletionHandler:(void(^)(double todayFlightsClimbed))handler;
-(void)getWeekMaxStepCountCompletionHandler:(void(^)(double weekMaxStepCount))handler;

- (NSSet *)dataTypesToRead;
- (NSSet *)dataTypesToWrite;

-(void)getAllData:(void(^)(double allStepCount,double todayStepCount,double todayDistanceWalkingRunning,double todayFlightsClimbed,double weekMaxStepCount))handler;

@end
