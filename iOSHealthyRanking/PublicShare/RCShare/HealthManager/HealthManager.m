//
//  HealthManager.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/18.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "HealthManager.h"
#import "UserInfo.h"

@interface HealthManager ()

@end

@implementation HealthManager

static HealthManager *healthManager = nil;

+ (HealthManager *)shareManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        healthManager = [[HealthManager alloc]init];
        healthManager.healthStore = [[HKHealthStore alloc] init];
    });
    return healthManager;
}

-(void)getAllData:(void(^)(double allStepCount,double todayStepCount,double todayDistanceWalkingRunning,double todayFlightsClimbed,double weekMaxStepCount))handler
{
    [self getAllStepCount2CompletionHandler:^(double allStepCount) {
        [self getTodayDistanceWalkingRunningCompletionHandler:^(double todayDistanceWalkingRunning) {
            [self getTodayFlightsClimbedCompletionHandler:^(double todayFlightsClimbed) {
                [self getTodayStepCountCompletionHandler:^(double todayStepCount) {
                    [self getWeekMaxStepCountCompletionHandler:^(double weekMaxStepCount) {
                        handler(allStepCount,todayStepCount,todayDistanceWalkingRunning,todayFlightsClimbed,weekMaxStepCount);
                    }];
                }];
            }];
        }];
    }];
    
//    [self getAllStepCount2CompletionHandler:^(double allStepCount) {
//        [self getTodayStepCountCompletionHandler:^(double todayStepCount) {
//            [self getTodayDistanceWalkingRunningCompletionHandler:^(double todayDistanceWalkingRunning) {
//                [self getTodayFlightsClimbedCompletionHandler:^(double todayFlightsClimbed) {
//                    handler(allStepCount,todayStepCount,todayDistanceWalkingRunning,todayFlightsClimbed);
//                }];
//            }];
//        }];
//    }];
}

-(void)getAllStepCount2CompletionHandler:(void(^)(double allStepCount))handler
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:now options:0];
    NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:-2000 toDate:endDate options:0];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    HKQuantityType *quantityType =
    [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        if (sum) {
            double value = [sum doubleValueForUnit:[HKUnit countUnit]];
            NSLog(@"总步数2：%lf",value);
            handler(value);
        }
        else
        {
            handler(0);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

-(void)getAllStepCount
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    //    interval.day = 20;
    interval.year = 2000;
    
    // Set the anchor date to Monday at 3:00 a.m.
    NSDateComponents *anchorComponents =
    [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth |
     NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    //    NSInteger offset = (7 + anchorComponents.weekday - 2) % 7;
    anchorComponents.day += 1;
    //    anchorComponents.hour = 3;
    
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    HKQuantityType *quantityType =
    [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create the query
    HKStatisticsCollectionQuery *query =
    [[HKStatisticsCollectionQuery alloc]
     initWithQuantityType:quantityType
     quantitySamplePredicate:nil
     options:HKStatisticsOptionCumulativeSum
     anchorDate:anchorDate
     intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler =
    ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",
                  error.localizedDescription);
            abort();
        }
        
        NSDate *endDate = [NSDate date];
        //        NSDate *startDate = [NSDate distantPast];
        NSDate *startDate = [calendar
                             dateByAddingUnit:NSCalendarUnitMonth
                             value:-3
                             toDate:endDate
                             options:0];
        
        
        // Plot the weekly step counts over the past 3 months
        [results
         enumerateStatisticsFromDate:startDate
         toDate:endDate
         withBlock:^(HKStatistics *result, BOOL *stop) {
             
             HKQuantity *quantity = result.sumQuantity;
             if (quantity) {
                 NSDate *date = result.startDate;
                 NSDate *date1 = result.endDate;
                 double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                 //                 double value1 = [quantity doubleValueForUnit:[HKUnit footUnit]];
                 NSLog(@"总步数%f,%@,%@",value,date,date1);
                 //                 [self plotData:value forDate:date];
             }
             
         }];
    };
    
    [self.healthStore executeQuery:query];
}

-(void)getWeekMaxStepCountCompletionHandler:(void(^)(double weekMaxStepCount))handler
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    NSDateComponents *anchorComponents =
    [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth |
     NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    //    NSInteger offset = (7 + anchorComponents.weekday - 2) % 7;
    //    anchorComponents.day -= offset;
    //    anchorComponents.hour = 3;
    
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    HKQuantityType *quantityType =
    [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create the query
    HKStatisticsCollectionQuery *query =
    [[HKStatisticsCollectionQuery alloc]
     initWithQuantityType:quantityType
     quantitySamplePredicate:nil
     options:HKStatisticsOptionCumulativeSum
     anchorDate:anchorDate
     intervalComponents:interval];
    
    __block double maxStepCount = 0;
    
    // Set the results handler
    query.initialResultsHandler =
    ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",
                  error.localizedDescription);
            abort();
        }
        
        NSDate *endDate = [NSDate date];
        NSDate *startDate = [calendar
                             dateByAddingUnit:NSCalendarUnitWeekday
                             value:-1
                             toDate:endDate
                             options:0];
//        NSDate *startDate = [self getToday];
//        startDate = anchorDate;
        // Plot the weekly step counts over the past 3 months
        [results
         enumerateStatisticsFromDate:startDate
         toDate:endDate
         withBlock:^(HKStatistics *result, BOOL *stop) {
             
             HKQuantity *quantity = result.sumQuantity;
             if (quantity) {
                 double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                 NSLog(@"%f,%@,%@",value,result.startDate,result.endDate);
                 if (maxStepCount<value) {
                     maxStepCount = value;
                 }
                 if ([result.startDate isEqualToDate:anchorDate]) {
                     handler(maxStepCount);
                 }
                 
             }
             else
             {
                 handler(0);
             }
         }];
    };
    
    [self.healthStore executeQuery:query];
}

-(void)getTodayStepCountCompletionHandler:(void(^)(double todayStepCount))handler
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 7;
    
    // Set the anchor date to Monday at 3:00 a.m.
    NSDateComponents *anchorComponents =
    [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth |
     NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    //    NSInteger offset = (7 + anchorComponents.weekday - 2) % 7;
    //    anchorComponents.day -= offset;
    //    anchorComponents.hour = 3;
    
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    HKQuantityType *quantityType =
    [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create the query
    HKStatisticsCollectionQuery *query =
    [[HKStatisticsCollectionQuery alloc]
     initWithQuantityType:quantityType
     quantitySamplePredicate:nil
     options:HKStatisticsOptionCumulativeSum
     anchorDate:anchorDate
     intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler =
    ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",
                  error.localizedDescription);
            abort();
        }
        
        NSDate *endDate = [NSDate date];
        //        NSDate *startDate = [calendar
        //                             dateByAddingUnit:NSCalendarUnitMonth
        //                             value:-3
        //                             toDate:endDate
        //                             options:0];
        NSDate *startDate = [self getToday];
        startDate = anchorDate;
        // Plot the weekly step counts over the past 3 months
        [results
         enumerateStatisticsFromDate:startDate
         toDate:endDate
         withBlock:^(HKStatistics *result, BOOL *stop) {
             
             HKQuantity *quantity = result.sumQuantity;
             if (quantity) {
                 double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                 NSLog(@"%f,%@,%@",value,startDate,endDate);
                 handler(value);
             }
             else
             {
                 handler(0);
             }
         }];
    };
    
    [self.healthStore executeQuery:query];
}

-(void)getTodayDistanceWalkingRunningCompletionHandler:(void(^)(double todayDistanceWalkingRunning))handler
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 7;
    
    // Set the anchor date to Monday at 3:00 a.m.
    NSDateComponents *anchorComponents =
    [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth |
     NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    //    NSInteger offset = (7 + anchorComponents.weekday - 2) % 7;
    //    anchorComponents.day -= offset;
    //    anchorComponents.hour = 3;
    
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    HKQuantityType *quantityType =
    [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    // Create the query
    HKStatisticsCollectionQuery *query =
    [[HKStatisticsCollectionQuery alloc]
     initWithQuantityType:quantityType
     quantitySamplePredicate:nil
     options:HKStatisticsOptionCumulativeSum
     anchorDate:anchorDate
     intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler =
    ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",
                  error.localizedDescription);
            abort();
        }
        
        NSDate *endDate = [NSDate date];
        //        NSDate *startDate = [calendar
        //                             dateByAddingUnit:NSCalendarUnitMonth
        //                             value:-3
        //                             toDate:endDate
        //                             options:0];
        NSDate *startDate = [self getToday];
        startDate = anchorDate;
        // Plot the weekly step counts over the past 3 months
        [results
         enumerateStatisticsFromDate:startDate
         toDate:endDate
         withBlock:^(HKStatistics *result, BOOL *stop) {
             
             HKQuantity *quantity = result.sumQuantity;
             if (quantity) {
                 double meterUnit = [quantity doubleValueForUnit:[HKUnit meterUnit]];
//                 double inchUnit = [quantity doubleValueForUnit:[HKUnit inchUnit]];
//                 double footUnit = [quantity doubleValueForUnit:[HKUnit footUnit]];
//                 double mileUnit = [quantity doubleValueForUnit:[HKUnit mileUnit]];
                 NSLog(@"%f,%@,%@",meterUnit,result.startDate,result.endDate);
                 handler(meterUnit);
             }
             else
             {
                 handler(0);
             }
             
         }];
    };
    
    [self.healthStore executeQuery:query];
}

-(void)getTodayFlightsClimbedCompletionHandler:(void(^)(double todayFlightsClimbed))handler
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 7;
    
    // Set the anchor date to Monday at 3:00 a.m.
    NSDateComponents *anchorComponents =
    [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth |
     NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    //    NSInteger offset = (7 + anchorComponents.weekday - 2) % 7;
    //    anchorComponents.day -= offset;
    //    anchorComponents.hour = 3;
    
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    HKQuantityType *quantityType =
    [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    // Create the query
    HKStatisticsCollectionQuery *query =
    [[HKStatisticsCollectionQuery alloc]
     initWithQuantityType:quantityType
     quantitySamplePredicate:nil
     options:HKStatisticsOptionCumulativeSum
     anchorDate:anchorDate
     intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler =
    ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",
                  error.localizedDescription);
            abort();
        }
        
        NSDate *endDate = [NSDate date];
        //        NSDate *startDate = [calendar
        //                             dateByAddingUnit:NSCalendarUnitMonth
        //                             value:-3
        //                             toDate:endDate
        //                             options:0];
        NSDate *startDate = [self getToday];
        startDate = anchorDate;
        // Plot the weekly step counts over the past 3 months
        [results
         enumerateStatisticsFromDate:startDate
         toDate:endDate
         withBlock:^(HKStatistics *result, BOOL *stop) {
             
             HKQuantity *quantity = result.sumQuantity;
             if (quantity) {
                 double countUnit = [quantity doubleValueForUnit:[HKUnit countUnit]];
                 NSLog(@"%f,%@,%@",countUnit,result.startDate,result.endDate);
                 handler(countUnit);
             }
             else
             {
                 handler(0);
             }
             
         }];
    };
    
    [self.healthStore executeQuery:query];
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

-(NSDate *)getToday
{
    return [self dateFromString:[self stringFromDate:[NSDate date]]];
}

#pragma mark - HealthKit Permissions

// Returns the types of data that Fit wishes to write to HealthKit.
- (NSSet *)dataTypesToWrite {
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, nil];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    HKCharacteristicType *biologicalSexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    HKQuantityType *stepCount = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *distanceWalkingRunning = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *flightsClimbed = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType,stepCount,distanceWalkingRunning,flightsClimbed, nil];
}


@end
