//
//  FBDailyActivity.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBDailyActivity : NSObject


@property (nonatomic, retain) NSArray *activities; // Array of FBActivity objects.

@property (nonatomic, retain) NSNumber *goalActiveScore;
@property (nonatomic, retain) NSNumber *goalCaloriesOut;
@property (nonatomic, retain) NSNumber *goalDistance;
@property (nonatomic, retain) NSNumber *goalFloors;
@property (nonatomic, retain) NSNumber *goalSteps;

@property (nonatomic, retain) NSNumber *activeScore;
@property (nonatomic, retain) NSNumber *caloriesOut;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSNumber *floors;
@property (nonatomic, retain) NSNumber *steps;

@property (nonatomic, retain) NSDictionary *distances;

@property (nonatomic, retain) NSNumber *fairlyActiveMinutes;
@property (nonatomic, retain) NSNumber *lightlyActiveMinutes;
@property (nonatomic, retain) NSNumber *sedentaryMinutes;
@property (nonatomic, retain) NSNumber *veryActiveMinutes;

@property (nonatomic, retain) NSNumber *elevation;
@property (nonatomic, retain) NSNumber *marginalCalories;

@property (nonatomic, retain) NSDate *dateForActivity;


+ (FBDailyActivity *) dailyActivityForDictionary: (NSDictionary *) dictionary forDate: (NSDate *) date;

@end
