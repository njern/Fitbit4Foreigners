//
//  FBUserInfo.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBUserInfo.h"

@implementation FBUserInfo

@synthesize aboutMe;
@synthesize avatarURL;
@synthesize city;
@synthesize country;
@synthesize dateOfBirth;
@synthesize displayName;
@synthesize distanceUnit;
@synthesize encodedID;
@synthesize nickName;
@synthesize fullName;
@synthesize gender;
@synthesize glucoseUnit;
@synthesize height;
@synthesize heightUnit;
@synthesize memberSince;
@synthesize offsetFromUTCMilliseconds;
@synthesize state;
@synthesize strideLengthWalking;
@synthesize strideLengthRunning;
@synthesize timezone;
@synthesize weight;
@synthesize waterUnit;
@synthesize weightUnit;


- (void) dealloc {
    
    
    self.aboutMe = nil;
    self.avatarURL = nil;
    self.city = nil;
    self.country = nil;
    self.dateOfBirth = nil;
    self.displayName = nil;    
    self.distanceUnit = INVALID;
    self.encodedID = nil;
    self.fullName = nil;
    self.height = nil;
    self.heightUnit = INVALID;
    self.nickName = nil;
    self.memberSince = nil;
    self.offsetFromUTCMilliseconds = nil;
    self.state = nil;
    self.strideLengthRunning = nil;
    self.strideLengthWalking = nil;
    self.weight = nil;
    self.waterUnit = INVALID;
    self.glucoseUnit = INVALID;
    
    [super dealloc];
}

+ (FBUserInfo *) createFromDictionary:(NSDictionary *)fetchedUserInfoDictionary {
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    
    FBUserInfo *userInfo = [[FBUserInfo alloc] init];
    
    NSDictionary *user = [fetchedUserInfoDictionary objectForKey:@"user"];
    
    userInfo.aboutMe = [user objectForKey:@"aboutMe"];
    userInfo.avatarURL = [NSURL URLWithString: [user objectForKey:@"avatar"]];
    userInfo.city = [user objectForKey:@"city"];
    userInfo.country = [user objectForKey:@"country"];
    userInfo.dateOfBirth = [dateFormatter dateFromString: [user objectForKey:@"dateOfBirth"]];
    userInfo.displayName = [user objectForKey:@"displayName"];    
    userInfo.distanceUnit = distanceUnitFromString([user objectForKey:@"distanceUnit"]) ;
    userInfo.encodedID = [user objectForKey:@"encodedId"];
    userInfo.fullName = [user objectForKey:@"fullName"];
    userInfo.height = [user objectForKey:@"height"];
    userInfo.heightUnit = distanceUnitFromString([user objectForKey:@"heightUnit"]) ;
    userInfo.nickName = [user objectForKey:@"nickname"];
    userInfo.memberSince = [dateFormatter dateFromString: [user objectForKey:@"memberSince"]];
    userInfo.offsetFromUTCMilliseconds = [user objectForKey:@"offsetFromUTCMillis"];
    userInfo.state = [user objectForKey:@"state"];
    userInfo.strideLengthRunning = [user objectForKey:@"strideLengthRunning"];
    userInfo.strideLengthWalking = [user objectForKey:@"strideLengthWalking"];
    userInfo.weight = [user objectForKey:@"weight"];
    userInfo.waterUnit = distanceUnitFromString([user objectForKey:@"waterUnit"]) ;
    userInfo.glucoseUnit = distanceUnitFromString([user objectForKey:@"glucoseUnit"]) ;

    return [userInfo autorelease];
}


@end
