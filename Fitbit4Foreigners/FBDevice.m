//
//  FBDevice.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBDevice.h"

@implementation FBDevice

@synthesize batteryLevel, uniqueID, lastSyncTime, deviceType;

- (void) dealloc {
    self.batteryLevel = nil;
    self.uniqueID = nil;
    self.lastSyncTime = nil;
    self.deviceType = nil;
    
    [super dealloc];
}

+ (FBDevice *) deviceFromDictionary: (NSDictionary *) dictionary {
        
    /**
     * Date is in format: 2012-06-16T18:15:47.000
     *
     * Not completely sure about the trailing ".000" so parsing that as literals.
     */
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000'"];

    FBDevice *device = [[FBDevice alloc] init];
    
    device.batteryLevel = [dictionary objectForKey:@"battery"];
    device.uniqueID = [dictionary objectForKey:@"id"];
    device.lastSyncTime = [dateFormatter dateFromString: [dictionary objectForKey:@"lastSyncTime"]];
    device.deviceType = [dictionary objectForKey:@"type"];
    
    return [device autorelease];
}

- (NSString *) description {
    NSString *description = [NSString stringWithFormat:@"Fitbit %@ \n\tID: %@\n\tLast synced: %@\n\tBattery level: %@", self.deviceType, self.uniqueID, self.lastSyncTime, self.batteryLevel];
    
    return description;
}

@end
