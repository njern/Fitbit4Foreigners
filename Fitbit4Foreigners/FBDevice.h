//
//  FBDevice.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBDevice : NSObject

@property (nonatomic, retain) NSString *batteryLevel; 
@property (nonatomic, retain) NSNumber *uniqueID; 
@property (nonatomic, retain) NSDate *lastSyncTime; 
@property (nonatomic, retain) NSString *deviceType; 

+ (FBDevice *) deviceFromDictionary: (NSDictionary *) dictionary;

@end
