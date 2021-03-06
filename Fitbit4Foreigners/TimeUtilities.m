//
//  TimeUtilities.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "TimeUtilities.h"

@implementation TimeUtilities

// Seconds per day (24h * 60m * 60s)
#define kSecondsPerDay 86400.0f



+ (BOOL) dateIsToday:(NSDate*)dateToCheck
{
    // Split today into components
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) 
                                           fromDate:[NSDate date]];
    
    // Set to this morning 00:00:00
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate* theMidnightHour = [gregorian dateFromComponents:comps];
    [gregorian release];
    
    // Get time difference (in seconds) between date and then
    NSTimeInterval diff = [dateToCheck timeIntervalSinceDate:theMidnightHour];
    
    return ( diff>=0.0f && diff < kSecondsPerDay );
}

+ (NSString *) getNicelyFormattedTimeSinceDate: (NSDate *) date {
    
    if(date == nil) {
        return @"...";
    }
    
    NSUInteger desiredComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit 
    | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    // NSLog(@"Getting time difference for date: %@", date);
    
    NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components: desiredComponents
                                                                         fromDate: date
                                                                           toDate: [NSDate date]
                                                                          options:0];
    // format to be used to generate string to display
    NSString *scannedFormat = @"%d %@ ago";
    NSInteger number = 0;
    NSString *unit = @"";
    
    if ([elapsedTimeUnits year] > 0) {
        number = [elapsedTimeUnits year];
        unit = [NSString stringWithFormat:@"year"];
    }
    else if ([elapsedTimeUnits month] > 0) {
        number = [elapsedTimeUnits month];
        unit = [NSString stringWithFormat:@"month"];
    }
    else if ([elapsedTimeUnits week] > 0) {
        number = [elapsedTimeUnits week];
        unit = [NSString stringWithFormat:@"week"];
    }
    else if ([elapsedTimeUnits day] > 0) {
        number = [elapsedTimeUnits day];
        unit = [NSString stringWithFormat:@"day"];
    }
    else if ([elapsedTimeUnits hour] > 0) {
        number = [elapsedTimeUnits hour];
        unit = [NSString stringWithFormat:@"hour"];
    }
    else if ([elapsedTimeUnits minute] > 0) {
        number = [elapsedTimeUnits minute];
        unit = [NSString stringWithFormat:@"minute"];
    }
    else if ([elapsedTimeUnits second] > 0) {
        number = [elapsedTimeUnits second];
        unit = [NSString stringWithFormat:@"second"];
    }
    else if([elapsedTimeUnits second] == 0) {
        return @"Just now";
    }
    
    // check if unit number is greater then append s at the end
    if (number > 1) {
        unit = [NSString stringWithFormat:@"%@s", unit];
    }
    // resultant string required
    NSString *scannedString = [NSString stringWithFormat:scannedFormat, number, unit];  
    
    return scannedString;
}


@end
