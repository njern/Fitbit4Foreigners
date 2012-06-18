//
//  FBActivity.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/18/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBActivity.h"

@implementation FBActivity

@synthesize activityID;
@synthesize activityParentId;
@synthesize calories;
@synthesize description;
@synthesize distance;
@synthesize duration;
@synthesize hasStartTime;
@synthesize isFavorite;
@synthesize logId;
@synthesize name;
@synthesize startTime;
@synthesize steps;

- (void) dealloc {
    
    self.activityID = nil;
    self.activityParentId = nil;
    self.calories = nil;
    self.description = nil;
    self.distance = nil;
    self.duration = nil;
    self.hasStartTime = NO;
    self.isFavorite = NO;
    self.logId = nil;
    self.name = nil;
    self.startTime = nil;
    self.steps = nil;
    
    [super dealloc];
}


+ (FBActivity *) activityFromDictionary: (NSDictionary *) dictionary forDate: (NSDate *) date {
    
    FBActivity *activity = [[FBActivity alloc] init];
    
    activity.activityID = [dictionary objectForKey:@"activityId"];
    activity.activityParentId = [dictionary objectForKey:@"activityParentId"];
    activity.calories = [dictionary objectForKey:@"calories"];
    activity.distance = [dictionary objectForKey:@"distance"];
    activity.duration = [dictionary objectForKey:@"duration"];
    activity.hasStartTime = [[dictionary objectForKey:@"hasStartTime"] boolValue];
    activity.isFavorite = [[dictionary objectForKey:@"isFavorite"] boolValue];

    activity.logId = [dictionary objectForKey:@"logId"];
    activity.name = [dictionary objectForKey:@"name"];
    activity.steps = [dictionary objectForKey:@"steps"];
    
    if(activity.hasStartTime) {
        
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateFormatter* dateFormatter2 = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd_HH:mm"];
        
        NSString *fullDateString = [NSString stringWithFormat:@"%@_%@", [dateFormatter stringFromDate:date], [dictionary objectForKey:@"startTime"]];
        
        activity.startTime = [dateFormatter2 dateFromString:fullDateString];
    }
   
 
    return [activity autorelease];
}

@end
