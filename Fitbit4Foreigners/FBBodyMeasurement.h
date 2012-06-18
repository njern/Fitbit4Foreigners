//
//  FBBodyMeasurement.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBBodyMeasurement : NSObject

@property (nonatomic, retain) NSNumber *biceps;
@property (nonatomic, retain) NSNumber *calf;
@property (nonatomic, retain) NSNumber *chest;
@property (nonatomic, retain) NSNumber *forearm;
@property (nonatomic, retain) NSNumber *hips;
@property (nonatomic, retain) NSNumber *neck;
@property (nonatomic, retain) NSNumber *thigh;
@property (nonatomic, retain) NSNumber *waist;

@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic, retain) NSNumber *fatPercent;
@property (nonatomic, retain) NSNumber *BMI;

@property (nonatomic, retain) NSNumber *goalWeight;

+ (FBBodyMeasurement *) bodyMeasurementsFromDictionary: (NSDictionary *) dictionary;

@end


