//
//  FBBodyWeightData.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBBodyWeightData : NSObject


@property (nonatomic, retain) NSNumber *BMI;
@property (nonatomic, retain) NSDate *dateTime;
@property (nonatomic, retain) NSNumber *logIdentifer;
@property (nonatomic, retain) NSNumber *weight;

+ (FBBodyWeightData *) bodyWeightDataFromDictionary: (NSDictionary *) dictionary; 

@end
