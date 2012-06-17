//
//  FBUserInfo.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConstants.h"
@interface FBUserInfo : NSObject


@property (nonatomic, retain) NSString *aboutMe;
@property (nonatomic, retain) NSURL *avatarURL;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSDate *dateOfBirth;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic) MeasurementUnitSystem distanceUnit;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *encodedID;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic) Gender gender;
@property (nonatomic) MeasurementUnitSystem glucoseUnit;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic) MeasurementUnitSystem heightUnit;
@property (nonatomic, retain) NSDate *memberSince;
@property (nonatomic, retain) NSNumber *offsetFromUTCMilliseconds;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *strideLengthWalking;
@property (nonatomic, retain) NSNumber *strideLengthRunning;
@property (nonatomic, retain) NSNumber *timezone;
@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic) MeasurementUnitSystem waterUnit;
@property (nonatomic) MeasurementUnitSystem weightUnit;

+ (FBUserInfo *) createFromDictionary: (NSDictionary *) fetchedUserInfoDictionary;
@end
