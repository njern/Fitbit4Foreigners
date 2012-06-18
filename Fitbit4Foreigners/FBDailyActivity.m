//
//  FBDailyActivity.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBDailyActivity.h"
#import "FBActivity.h"
@implementation FBDailyActivity

@synthesize activities;

@synthesize goalActiveScore;
@synthesize goalCaloriesOut;
@synthesize goalDistance;
@synthesize goalFloors;
@synthesize goalSteps;

@synthesize activeScore;
@synthesize caloriesOut;
@synthesize distance;
@synthesize floors;
@synthesize steps;

@synthesize distances;

@synthesize fairlyActiveMinutes;
@synthesize lightlyActiveMinutes;
@synthesize sedentaryMinutes;
@synthesize veryActiveMinutes;

@synthesize elevation;
@synthesize marginalCalories;

@synthesize dateForActivity;

- (void) dealloc {
    
    self.activities = nil; 
    
    self.goalActiveScore = nil;
    self.goalCaloriesOut = nil;
    self.goalDistance = nil;
    self.goalFloors = nil;
    self.goalSteps = nil;
    
    self.activeScore = nil;
    self.caloriesOut = nil;
    self.distance = nil;
    self.floors = nil;
    self.steps = nil;
    
    self.distances = nil;
    
    self.fairlyActiveMinutes = nil;
    self.lightlyActiveMinutes = nil;
    self.sedentaryMinutes = nil;
    self.veryActiveMinutes = nil;
    
    self.elevation = nil;
    self.marginalCalories = nil;

    self.dateForActivity = nil;
    
    [super dealloc];
}


+ (FBDailyActivity *) dailyActivityForDictionary: (NSDictionary *) dictionary forDate: (NSDate *) date {
    
    FBDailyActivity *dailyActivity = [[FBDailyActivity alloc] init];
    dailyActivity.dateForActivity = date;
    
    NSArray *activitiesJSON = [dictionary objectForKey:@"activities"];
    NSMutableArray *realActivities = [NSMutableArray array];
    
    for(NSDictionary *activityJSON in activitiesJSON) {
        FBActivity *realActivity = [FBActivity activityFromDictionary:activityJSON forDate:date];
        [realActivities addObject:realActivity];
    }
    
    dailyActivity.activities = realActivities;
    
    NSDictionary *goals = [dictionary objectForKey:@"goals"];
    
    dailyActivity.goalActiveScore = [goals objectForKey:@"activeScore"];
    dailyActivity.goalCaloriesOut = [goals objectForKey:@"caloriesOut"];
    dailyActivity.goalDistance = [goals objectForKey:@"distance"];
    dailyActivity.goalFloors = [goals objectForKey:@"floors"];
    dailyActivity.goalSteps = [goals objectForKey:@"steps"];
    
    NSDictionary *summary = [dictionary objectForKey:@"summary"];
    
    dailyActivity.activeScore = [summary objectForKey:@"activeScore"];
    dailyActivity.caloriesOut = [summary objectForKey:@"caloriesOut"];
    dailyActivity.distance = [summary objectForKey:@"distance"];
    dailyActivity.floors = [summary objectForKey:@"floors"];
    dailyActivity.steps = [summary objectForKey:@"steps"];
    
    
    dailyActivity.distances = [summary objectForKey:@"distances"];
    
    dailyActivity.fairlyActiveMinutes = [summary objectForKey:@"fairlyActiveMinutes"];
    dailyActivity.lightlyActiveMinutes = [summary objectForKey:@"lightlyActiveMinutes"];
    dailyActivity.sedentaryMinutes = [summary objectForKey:@"sedentaryMinutes"];
    dailyActivity.veryActiveMinutes = [summary objectForKey:@"veryActiveMinutes"];
    
    dailyActivity.elevation = [summary objectForKey:@"elevation"];
    dailyActivity.marginalCalories = [summary objectForKey:@"marginalCalories"];
    
    
    return [dailyActivity autorelease];
}

@end
