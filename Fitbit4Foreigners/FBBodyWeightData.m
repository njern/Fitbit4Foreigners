//
//  FBBodyWeightData.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBBodyWeightData.h"

@implementation FBBodyWeightData


@synthesize BMI;
@synthesize dateTime;
@synthesize logIdentifer;
@synthesize weight;

- (void) dealloc {
    self.BMI = nil;
    self.dateTime = nil;
    self.logIdentifer = nil;
    self.weight = nil;
    
    [super dealloc];
}

+ (FBBodyWeightData *) bodyWeightDataFromDictionary: (NSDictionary *) dictionary {
    
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];

    FBBodyWeightData *bodyWeightData = [[FBBodyWeightData alloc] init];
 
    NSString *newDateString = [NSString stringWithFormat:@"%@_%@", [dictionary objectForKey:@"date"], [dictionary objectForKey:@"time"]];
    bodyWeightData.dateTime = [dateFormatter dateFromString:newDateString];
    bodyWeightData.BMI = [dictionary objectForKey:@"bmi"];
    bodyWeightData.logIdentifer = [dictionary objectForKey:@"logId"];
    bodyWeightData.weight = [dictionary objectForKey:@"weight"];

    
    return [bodyWeightData autorelease];
}

@end
