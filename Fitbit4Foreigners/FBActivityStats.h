//
//  FBActivityStats.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/18/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBActivityStats : NSObject

@property (nonatomic, retain) NSNumber *bestActiveScore;
@property (nonatomic, retain) NSDate *bestActiveScoreDate;
@property (nonatomic, retain) NSNumber *bestCaloriesOut;
@property (nonatomic, retain) NSDate *bestCaloriesOutDay;
@property (nonatomic, retain) NSNumber *bestDistance;
@property (nonatomic, retain) NSDate *bestDistanceDay;
@property (nonatomic, retain) NSNumber *bestFloorsClimbed;
@property (nonatomic, retain) NSDate *bestFloorsClimbedDay;
@property (nonatomic, retain) NSNumber *bestStepsTaken;
@property (nonatomic, retain) NSDate *bestStepsTakenDay;

@property (nonatomic, retain) NSNumber *bestActiveScore_tracker;
@property (nonatomic, retain) NSDate *bestActiveScoreDate_tracker;
@property (nonatomic, retain) NSNumber *bestCaloriesOut_tracker;
@property (nonatomic, retain) NSDate *bestCaloriesOutDay_tracker;
@property (nonatomic, retain) NSNumber *bestDistance_tracker;
@property (nonatomic, retain) NSDate *bestDistanceDay_tracker;
@property (nonatomic, retain) NSNumber *bestFloorsClimbed_tracker;
@property (nonatomic, retain) NSDate *bestFloorsClimbedDay_tracker;
@property (nonatomic, retain) NSNumber *bestStepsTaken_tracker;
@property (nonatomic, retain) NSDate *bestStepsTakenDay_tracker;


@property (nonatomic, retain) NSDate *lifetimeActiveScore;
@property (nonatomic, retain) NSDate *lifetimeCaloriesOut;
@property (nonatomic, retain) NSDate *lifetimeDistance;
@property (nonatomic, retain) NSDate *lifetimeFloorsClimbed;
@property (nonatomic, retain) NSDate *lifetimeStepsTaken;

@property (nonatomic, retain) NSDate *lifetimeActiveScore_tracker;
@property (nonatomic, retain) NSDate *lifetimeCaloriesOut_tracker;
@property (nonatomic, retain) NSDate *lifetimeDistance_tracker;
@property (nonatomic, retain) NSDate *lifetimeFloorsClimbed_tracker;
@property (nonatomic, retain) NSDate *lifetimeStepsTaken_tracker;


+ (FBActivityStats *) activityStatsFromDictionary: (NSDictionary *) dictionary;

@end
