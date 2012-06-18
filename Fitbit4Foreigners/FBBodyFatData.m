//
//  FBBodyFatData.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBBodyFatData.h"

@implementation FBBodyFatData

@synthesize fat;
@synthesize dateTime;
@synthesize logIdentifer;


- (void) dealloc {
    self.fat = nil;
    self.dateTime = nil;
    self.logIdentifer = nil;
    
    [super dealloc];
}

+ (FBBodyFatData *) bodyFatFromDictionary: (NSDictionary *) dictionary {
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];

    FBBodyFatData *bodyFatData = [[FBBodyFatData alloc] init];
    NSString *newDateString = [NSString stringWithFormat:@"%@_%@", [dictionary objectForKey:@"date"], [dictionary objectForKey:@"time"]];
    
    bodyFatData.dateTime = [dateFormatter dateFromString:newDateString];
    bodyFatData.fat = [dictionary objectForKey:@"fat"];
    bodyFatData.logIdentifer = [dictionary objectForKey:@"logId"];
    
    
    return [bodyFatData autorelease];
}

@end
