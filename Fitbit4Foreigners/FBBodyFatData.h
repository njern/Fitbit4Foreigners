//
//  FBBodyFatData.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBBodyFatData : NSObject


@property (nonatomic, retain) NSNumber *fat;
@property (nonatomic, retain) NSDate *dateTime;
@property (nonatomic, retain) NSNumber *logIdentifer;

+ (FBBodyFatData *) bodyFatFromDictionary: (NSDictionary *) dictionary;

@end
