//
//  FBConstants.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/17/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#ifndef Fitbit4Foreigners_FBConstants_h
#define Fitbit4Foreigners_FBConstants_h

typedef enum MeasurementUnitSystem{
    US,
    UK,
    METRIC,
    INVALID
} MeasurementUnitSystem;

typedef enum Gender{
    MALE,
    FEMALE,
    NA
} Gender;

static MeasurementUnitSystem distanceUnitFromString(NSString *string) {
    
    if([string isEqualToString:@"UK"]) {
        return UK;
    }

    else if([string isEqualToString:@"US"]) {
        return US;
    }
    
    else if([string isEqualToString:@"METRIC"]) {
        return METRIC;
    }
    
    else return INVALID;
}
    


#endif
