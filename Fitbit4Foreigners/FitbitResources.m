//
//  FitbitResources.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/12/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FitbitResources.h"
#import "FitbitAuthorization.h"

@interface FitbitResources()

@property (nonatomic, retain) FitbitAuthorization *authorization;

@end


@implementation FitbitResources
@synthesize  authorization;

- (void) dealloc {
 
    self.authorization = nil;
    
    [super dealloc];
}

- (id) initWithAuthorizationObject: (FitbitAuthorization *) _authorization {
    
    if(self == [super init]) {
        self.authorization = _authorization;
    }
    
    return self;
}

- (id) init {
    return nil;
}


@end
