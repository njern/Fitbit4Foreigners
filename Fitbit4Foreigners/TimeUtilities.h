//
//  TimeUtilities.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeUtilities : NSObject

+ (BOOL) dateIsToday:(NSDate*)dateToCheck;
+ (NSString *) getNicelyFormattedTimeSinceDate: (NSDate *) date;

@end
