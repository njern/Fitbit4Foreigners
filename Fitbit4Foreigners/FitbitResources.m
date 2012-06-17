//
//  FitbitResources.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/12/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FitbitResources.h"
#import "FitbitAuthorization.h"
#import "SBJson.h"
#import "FBUserInfo.h"
#import "FBDevice.h"
@interface FitbitResources()

@property (nonatomic, retain) FitbitAuthorization *authorization;

@end


@implementation FitbitResources
@synthesize  authorization;
@synthesize delegate;

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



// DEVICES

- (void) fetchDevices {
    
    NSURL *url = [NSURL URLWithString:@"http://api.fitbit.com/1/user/-/devices.json"];
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:self.authorization.oAuthToken
                                                                       realm:nil
                                                           signatureProvider:nil]
                                    autorelease];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(devicesRequestWithTicket:didFinishWithData:)
                  didFailSelector:@selector(devicesRequestWithTicket:didFailWithError:)];
}

- (void)devicesRequestWithTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
    
        id jsonResult = [responseBody JSONValue];
        
        if(jsonResult && [jsonResult isKindOfClass:[NSArray class]]) {
            
            // Create FBDevice objects -> put them in deviceObjects -> pass that to delegate
            NSMutableArray *deviceObjects = [NSMutableArray array];
            for(NSDictionary *dictionaryDevice in jsonResult) {
                FBDevice *device = [FBDevice deviceFromDictionary:dictionaryDevice];
                [deviceObjects addObject:device];
            }
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToDevicesQuery:)]) {
                [self.delegate gotResponseToDevicesQuery:deviceObjects];
            }
        }
        
        else {
            NSLog(@"Invalid data format for GET: DEVICES request.");
        }
    }
}

- (void)devicesRequestWithTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(devicesQueryFailedWithError:)]) {
            [self.delegate devicesQueryFailedWithError: error];
        }
    }    
}



// MY ACTIVITIES

- (void) fetchMyActivitiesForDate: (NSDate *) date {
    // GET /1/user/-/activities/date/2010-02-21.json
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString =  [dateFormat stringFromDate:date];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.fitbit.com/1/user/-/activities/date/%@.json", dateString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:self.authorization.oAuthToken
                                                                       realm:nil
                                                           signatureProvider:nil]
                                    autorelease];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(activitiesRequestWithTicket:didFinishWithData:)
                  didFailSelector:@selector(activitiesRequestWithTicket:didFailWithError:)];
}

- (void)activitiesRequestWithTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
        
        id jsonResult = [responseBody JSONValue];
        
        if(jsonResult && [jsonResult isKindOfClass:[NSDictionary class]]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToActivitiesQuery:)]) {
                [self.delegate gotResponseToActivitiesQuery:jsonResult];
            }
        }
        
        else {
            NSLog(@"Invalid data format for GET: ACTIVITIES request.");
        }
    }
}

- (void)activitiesRequestWithTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(activitiesQueryFailedWithError:)]) {
            [self.delegate activitiesQueryFailedWithError: error];
        }
    }    
}




// MY USER INFO

- (void) fetchMyUserInfo {
    // GET /1/user/-/profile.json
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.fitbit.com/1/user/-/profile.json"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:self.authorization.oAuthToken
                                                                       realm:nil
                                                           signatureProvider:nil]
                                    autorelease];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(userInfoRequestWithTicket:didFinishWithData:)
                  didFailSelector:@selector(userInfoRequestWithTicket:didFailWithError:)];
}

- (void)userInfoRequestWithTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
        
        id jsonResult = [responseBody JSONValue];
        
        if(jsonResult && [jsonResult isKindOfClass:[NSDictionary class]]) {
            FBUserInfo *resultingUserInfo = [FBUserInfo createFromDictionary:jsonResult];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToMyUserInfoQuery:)]) {
                [self.delegate gotResponseToMyUserInfoQuery:resultingUserInfo];
            }
        }
        
        else {
            NSLog(@"Invalid data format for GET: USER INFO request.");
        }
    }
}

- (void)userInfoRequestWithTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(myUserInfoQueryFailedWithError:)]) {
            [self.delegate myUserInfoQueryFailedWithError: error];
        }
    }    
}


- (void) fetchBodyMeasurementsForDate: (NSDate *) date {
    // GET /1/user/-/body/date/2010-02-21.json
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString =  [dateFormat stringFromDate:date];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.fitbit.com/1/user/-/body/date/%@.json", dateString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:self.authorization.oAuthToken
                                                                       realm:nil
                                                           signatureProvider:nil]
                                    autorelease];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(bodyMeasurementsRequestWithTicket:didFinishWithData:)
                  didFailSelector:@selector(bodyMeasurementsRequestWithTicket:didFailWithError:)];
}

- (void)bodyMeasurementsRequestWithTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
        
        id jsonResult = [responseBody JSONValue];
        
        if(jsonResult && [jsonResult isKindOfClass:[NSDictionary class]]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToBodyMeasurementsQuery:)]) {
                [self.delegate gotResponseToBodyMeasurementsQuery:jsonResult];
            }
        }
        
        else {
            NSLog(@"Invalid data format for GET: USER INFO request.");
        }
    }
}

- (void)bodyMeasurementsRequestWithTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(bodyMeasurementsQueryFailedWithError:)]) {
            [self.delegate bodyMeasurementsQueryFailedWithError: error];
        }
    }    
}


// BODY WEIGHT

- (void) fetchBodyWeightDataFromDate: (NSDate *) fromDate untilDate: (NSDate *) endDate {
    // GET /<api-version>/user/-/body/log/weight/date/<base-date>/<end-date>.<response-format>
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *fromDateString =  [dateFormat stringFromDate:fromDate];
    NSString *endDateString =  [dateFormat stringFromDate:endDate];

    NSString *urlString = [NSString stringWithFormat:@"http://api.fitbit.com/1/user/-/body/log/weight/date%@/%@.json", fromDateString, endDateString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:self.authorization.oAuthToken
                                                                       realm:nil
                                                           signatureProvider:nil]
                                    autorelease];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(bodyWeightRequestWithTicket:didFinishWithData:)
                  didFailSelector:@selector(bodyWeightRequestWithTicket:didFailWithError:)];
}

- (void)bodyWeightRequestWithTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
        
        id jsonResult = [responseBody JSONValue];
        
        if(jsonResult && [jsonResult isKindOfClass:[NSArray class]]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToBodyWeightQuery:)]) {
                [self.delegate gotResponseToBodyWeightQuery:jsonResult];
            }
        }
        
        else {
            NSLog(@"Invalid data format for GET: BODY WEIGHT request.");
        }
    }
}

- (void)bodyWeightRequestWithTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(bodyWeightQueryFailedWithError:)]) {
            [self.delegate bodyWeightQueryFailedWithError: error];
        }
    }    
}


// BODY FAT
    
- (void) fetchBodyFatDataFromDate: (NSDate *) fromDate untilDate: (NSDate *) endDate { 
    // GET /<api-version>/user/-/body/log/fat/date/<base-date>/<end-date>.<response-format>
    

    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *fromDateString =  [dateFormat stringFromDate:fromDate];
    NSString *endDateString =  [dateFormat stringFromDate:endDate];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.fitbit.com/1/user/-/fat/log/weight/date%@/%@.json", fromDateString, endDateString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:self.authorization.oAuthToken
                                                                       realm:nil
                                                           signatureProvider:nil]
                                    autorelease];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(bodyFatRequestWithTicket:didFinishWithData:)
                  didFailSelector:@selector(bodyFatRequestWithTicket:didFailWithError:)];
}

- (void)bodyFatRequestWithTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
        
        id jsonResult = [responseBody JSONValue];
        
        if(jsonResult && [jsonResult isKindOfClass:[NSArray class]]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToBodyFatQuery:)]) {
                [self.delegate gotResponseToBodyFatQuery:jsonResult];
            }
        }
        
        else {
            NSLog(@"Invalid data format for GET: BODY FAT request.");
        }
    }
}

- (void)bodyFatRequestWithTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(bodyFatQueryFailedWithError:)]) {
            [self.delegate bodyFatQueryFailedWithError: error];
        }
    }    
}



@end
