//
//  FBBodyMeasurement.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBBodyMeasurement.h"

@implementation FBBodyMeasurement

@synthesize biceps;
@synthesize calf;
@synthesize chest;
@synthesize forearm;
@synthesize hips;
@synthesize neck;
@synthesize thigh;
@synthesize waist;

@synthesize weight;
@synthesize fatPercent;
@synthesize BMI;

@synthesize goalWeight;

- (void) dealloc {
    
    self.biceps = nil;
    self.calf = nil;
    self.chest = nil;
    self.forearm = nil;
    self.hips = nil;
    self.neck = nil;
    self.thigh = nil;
    self.waist = nil;
    
    self.weight = nil;
    self.fatPercent = nil;
    self.BMI = nil;
    
    self.goalWeight = nil;

    [super dealloc];
}

+ (FBBodyMeasurement *) bodyMeasurementsFromDictionary: (NSDictionary *) dictionary {
    
    NSDictionary *body = [dictionary objectForKey:@"body"];
    NSDictionary *goals = [dictionary objectForKey:@"goals"];  
    
    FBBodyMeasurement *bodyMeasurement = [[FBBodyMeasurement alloc] init];
    
    bodyMeasurement.biceps = [body objectForKey:@"bicep"];
    bodyMeasurement.calf = [body objectForKey:@"calf"];
    bodyMeasurement.chest = [body objectForKey:@"chest"];
    bodyMeasurement.forearm = [body objectForKey:@"forearm"];
    bodyMeasurement.hips = [body objectForKey:@"hips"];
    bodyMeasurement.neck = [body objectForKey:@"neck"];
    bodyMeasurement.thigh = [body objectForKey:@"thigh"];
    bodyMeasurement.waist = [body objectForKey:@"waist"];
    
    bodyMeasurement.weight = [body objectForKey:@"weight"];
    bodyMeasurement.fatPercent = [body objectForKey:@"fat"];
    bodyMeasurement.BMI = [body objectForKey:@"bmi"];
    
    bodyMeasurement.goalWeight = [goals objectForKey:@"weight"];
   
    
    return [bodyMeasurement autorelease];
}

@end
