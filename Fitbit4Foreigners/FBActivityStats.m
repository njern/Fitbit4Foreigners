//
//  FBActivityStats.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/18/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBActivityStats.h"

@implementation FBActivityStats

 
@synthesize bestActiveScore;
@synthesize bestActiveScoreDate;
@synthesize bestCaloriesOut;
@synthesize bestCaloriesOutDay;
@synthesize bestDistance;
@synthesize bestDistanceDay;
@synthesize bestFloorsClimbed;
@synthesize bestFloorsClimbedDay;
@synthesize bestStepsTaken;
@synthesize bestStepsTakenDay;

@synthesize bestActiveScore_tracker;
@synthesize bestActiveScoreDate_tracker;
@synthesize bestCaloriesOut_tracker;
@synthesize bestCaloriesOutDay_tracker;
@synthesize bestDistance_tracker;
@synthesize bestDistanceDay_tracker;
@synthesize bestFloorsClimbed_tracker;
@synthesize bestFloorsClimbedDay_tracker;
@synthesize bestStepsTaken_tracker;
@synthesize bestStepsTakenDay_tracker;


@synthesize lifetimeActiveScore;
@synthesize lifetimeCaloriesOut;
@synthesize lifetimeDistance;
@synthesize lifetimeFloorsClimbed;
@synthesize lifetimeStepsTaken;

@synthesize lifetimeActiveScore_tracker;
@synthesize lifetimeCaloriesOut_tracker;
@synthesize lifetimeDistance_tracker;
@synthesize lifetimeFloorsClimbed_tracker;
@synthesize lifetimeStepsTaken_tracker;

- (void) dealloc {

    self.bestActiveScore = nil;
    self.bestActiveScoreDate = nil;
    self.bestCaloriesOut = nil;
    self.bestCaloriesOutDay = nil;
    self.bestDistance = nil;
    self.bestDistanceDay = nil;
    self.bestFloorsClimbed = nil;
    self.bestFloorsClimbedDay = nil;
    self.bestStepsTaken = nil;
    self.bestStepsTakenDay = nil;
    
    self.bestActiveScore_tracker = nil;
    self.bestActiveScoreDate_tracker = nil;
    self.bestCaloriesOut_tracker = nil;
    self.bestCaloriesOutDay_tracker = nil;
    self.bestDistance_tracker = nil;
    self.bestDistanceDay_tracker = nil;
    self.bestFloorsClimbed_tracker = nil;
    self.bestFloorsClimbedDay_tracker = nil;
    self.bestStepsTaken_tracker = nil;
    self.bestStepsTakenDay_tracker = nil;
    
    self.lifetimeActiveScore = nil;
    self.lifetimeCaloriesOut = nil;
    self.lifetimeDistance = nil;
    self.lifetimeFloorsClimbed = nil;
    self.lifetimeStepsTaken = nil;
    
    self.lifetimeActiveScore_tracker = nil;
    self.lifetimeCaloriesOut_tracker = nil;
    self.lifetimeDistance_tracker = nil;
    self.lifetimeFloorsClimbed_tracker = nil;
    self.lifetimeStepsTaken_tracker = nil;
    
    [super dealloc];
}


+ (FBActivityStats *) activityStatsFromDictionary: (NSDictionary *) dictionary {
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDictionary *best = [dictionary objectForKey:@"best"];
    NSDictionary *bestTotal = [best objectForKey:@"total"];
    NSDictionary *bestTracker = [best objectForKey:@"tracker"];
    
    NSDictionary *lifetime = [dictionary objectForKey:@"lifetime"];
    NSDictionary *lifetimeTotal = [lifetime objectForKey:@"total"];
    NSDictionary *lifetimeTracker = [lifetime objectForKey:@"tracker"];
    
    FBActivityStats *activityStats = [[FBActivityStats alloc] init];
    
    
    activityStats.bestActiveScore = [[bestTotal objectForKey:@"activeScore"] objectForKey:@"value"];
    activityStats.bestActiveScoreDate = [dateFormatter dateFromString: [[bestTotal objectForKey:@"activeScore"] objectForKey:@"date"]];
    activityStats.bestCaloriesOut = [[bestTotal objectForKey:@"caloriesOut"] objectForKey:@"value"];
    activityStats.bestCaloriesOutDay = [dateFormatter dateFromString: [[bestTotal objectForKey:@"caloriesOut"] objectForKey:@"date"]];
    activityStats.bestDistance = [[bestTotal objectForKey:@"distance"] objectForKey:@"value"];
    activityStats.bestDistanceDay = [dateFormatter dateFromString: [[bestTotal objectForKey:@"distance"] objectForKey:@"date"]];
    activityStats.bestFloorsClimbed = [[bestTotal objectForKey:@"floors"] objectForKey:@"value"];
    activityStats.bestFloorsClimbedDay = [dateFormatter dateFromString: [[bestTotal objectForKey:@"floors"] objectForKey:@"date"]];
    activityStats.bestStepsTaken = [[bestTotal objectForKey:@"steps"] objectForKey:@"value"];
    activityStats.bestStepsTakenDay = [dateFormatter dateFromString: [[bestTotal objectForKey:@"steps"] objectForKey:@"date"]];
    
    activityStats.bestActiveScore_tracker = [[bestTracker objectForKey:@"activeScore"] objectForKey:@"value"];
    activityStats.bestActiveScoreDate_tracker = [dateFormatter dateFromString: [[bestTracker objectForKey:@"activeScore"] objectForKey:@"date"]];
    activityStats.bestCaloriesOut_tracker = [[bestTracker objectForKey:@"caloriesOut"] objectForKey:@"value"];
    activityStats.bestCaloriesOutDay_tracker = [dateFormatter dateFromString: [[bestTracker objectForKey:@"caloriesOut"] objectForKey:@"date"]];
    activityStats.bestDistance_tracker = [[bestTracker objectForKey:@"distance"] objectForKey:@"value"];
    activityStats.bestDistanceDay_tracker = [dateFormatter dateFromString: [[bestTracker objectForKey:@"distance"] objectForKey:@"date"]];
    activityStats.bestFloorsClimbed_tracker = [[bestTracker objectForKey:@"floors"] objectForKey:@"value"];
    activityStats.bestFloorsClimbedDay_tracker = [dateFormatter dateFromString: [[bestTracker objectForKey:@"floors"] objectForKey:@"date"]];
    activityStats.bestStepsTaken_tracker = [[bestTracker objectForKey:@"steps"] objectForKey:@"value"];
    activityStats.bestStepsTakenDay_tracker = [dateFormatter dateFromString: [[bestTracker objectForKey:@"steps"] objectForKey:@"date"]];
    
    activityStats.lifetimeActiveScore = [lifetimeTotal objectForKey:@"activeScore"];
    activityStats.lifetimeCaloriesOut = [lifetimeTotal objectForKey:@"caloriesOut"];
    activityStats.lifetimeDistance = [lifetimeTotal objectForKey:@"distance"];
    activityStats.lifetimeFloorsClimbed = [lifetimeTotal objectForKey:@"floors"];
    activityStats.lifetimeStepsTaken = [lifetimeTotal objectForKey:@"steps"];
    
    activityStats.lifetimeActiveScore_tracker = [lifetimeTracker objectForKey:@"activeScore"];;
    activityStats.lifetimeCaloriesOut_tracker = [lifetimeTracker objectForKey:@"caloriesOut"];;
    activityStats.lifetimeDistance_tracker = [lifetimeTracker objectForKey:@"distance"];;
    activityStats.lifetimeFloorsClimbed_tracker = [lifetimeTracker objectForKey:@"floors"];;
    activityStats.lifetimeStepsTaken_tracker = [lifetimeTracker objectForKey:@"steps"];;
    
    
    return [activityStats autorelease];
}


@end
