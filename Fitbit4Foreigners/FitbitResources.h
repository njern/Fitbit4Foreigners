//
//  FitbitResources.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/12/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FitbitAuthorization; // Forward declare

@protocol FitbitResourcesDelegate <NSObject>

- (void) gotResponseToDevicesQuery: (NSArray *) devices;
- (void) devicesQueryFailedWithError: (NSError *) error;

- (void) gotResponseToActivitiesQuery: (NSDictionary *) response;
- (void) activitiesQueryFailedWithError: (NSError *) error;

@end

@interface FitbitResources : NSObject

- (id) initWithAuthorizationObject: (FitbitAuthorization *) _authorization;

// GET methods for the Resources API
- (void) fetchDevices;
- (void) fetchMyActivitiesForDate: (NSDate *) date;


@end
