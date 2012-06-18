//
//  FBActivity.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/18/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBActivity : NSObject



@property (nonatomic, retain) NSNumber *activityID;
@property (nonatomic, retain) NSNumber *activityParentId;
@property (nonatomic, retain) NSNumber *calories;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic) BOOL hasStartTime;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, retain) NSNumber *logId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSNumber *steps;

+ (FBActivity *) activityFromDictionary: (NSDictionary *) dictionary forDate: (NSDate *) date;

@end
