//
//  FitbitResources.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/12/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBUserInfo;
@class FBActivityStats;
@class FitbitAuthorization; // Forward declare

@protocol FitbitResourcesDelegate <NSObject>

- (void) gotResponseToDevicesQuery: (NSArray *) devices;
- (void) devicesQueryFailedWithError: (NSError *) error;

- (void) gotResponseToActivitiesQuery: (NSDictionary *) response;
- (void) activitiesQueryFailedWithError: (NSError *) error;

- (void) gotResponseToMyUserInfoQuery: (FBUserInfo *) response;
- (void) myUserInfoQueryFailedWithError: (NSError *) error;

- (void) gotResponseToBodyMeasurementsQuery: (NSDictionary *) response;
- (void) bodyMeasurementsQueryFailedWithError: (NSError *) error;

- (void) gotResponseToBodyWeightQuery: (NSArray *) response;
- (void) bodyWeightQueryFailedWithError: (NSError *) error;

- (void) gotResponseToBodyFatQuery: (NSArray *) response;
- (void) bodyFatQueryFailedWithError: (NSError *) error;

- (void) gotResponseToActivityStatsQuery: (FBActivityStats *) response;
- (void) activityStatsQueryFailedWithError: (NSError *) error;

@end

@interface FitbitResources : NSObject

@property (nonatomic, assign) NSObject<FitbitResourcesDelegate> *delegate;

- (id) initWithAuthorizationObject: (FitbitAuthorization *) _authorization;

// GET methods for the Resources API
- (void) fetchDevices;
- (void) fetchMyActivitiesForDate: (NSDate *) date;
- (void) fetchMyUserInfo;
- (void) fetchBodyMeasurementsForDate: (NSDate *) date;
- (void) fetchBodyWeightDataFromDate: (NSDate *) fromDate untilDate: (NSDate *) endDate;
- (void) fetchBodyFatDataFromDate: (NSDate *) fromDate untilDate: (NSDate *) endDate;
- (void) fetchActivityStats;


@end
