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
#import "FBActivityStats.h"
#import "FBDailyActivity.h"
#import "FBBodyMeasurement.h"
#import "FBBodyWeightData.h"
#import "FBBodyFatData.h"

@interface FitbitResources()

@property (nonatomic, retain) NSMutableDictionary *datesForDailyActivities;
@property (nonatomic, retain) FitbitAuthorization *authorization;

@end


@implementation FitbitResources
@synthesize  authorization, datesForDailyActivities;
@synthesize delegate;

- (void) dealloc {
 
    self.authorization = nil;
    self.datesForDailyActivities = nil;
    [super dealloc];
}

- (id) initWithAuthorizationObject: (FitbitAuthorization *) _authorization {
    
    if(self == [super init]) {
        self.authorization = _authorization;
        self.datesForDailyActivities = [NSMutableDictionary dictionary];
    
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
    
    [self.datesForDailyActivities setObject:date forKey:urlString];
    
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
                
                NSDate *dateForDailyActivity = [self.datesForDailyActivities objectForKey: [NSString stringWithFormat:@"%@", ticket.request.URL]]; // Get the date using the URL 
                FBDailyActivity *dailyActivity = [FBDailyActivity dailyActivityForDictionary: jsonResult forDate:dateForDailyActivity];
                
                [self.delegate gotResponseToActivitiesQuery:dailyActivity];
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
                
                FBBodyMeasurement *bodyMeasurement = [FBBodyMeasurement bodyMeasurementsFromDictionary:jsonResult];
                
                [self.delegate gotResponseToBodyMeasurementsQuery:bodyMeasurement];
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
        
        if([jsonResult isKindOfClass:[NSDictionary class]]) {
            jsonResult = [jsonResult objectForKey: @"weight"];
        }
        
        if(jsonResult && [jsonResult isKindOfClass:[NSArray class]]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToBodyWeightQuery:)]) {
                
                NSMutableArray *arrayOfBodyWeightObjects = [NSMutableArray array];
                
                for(NSDictionary *weightMeasurement in jsonResult) {
                    FBBodyWeightData *bodyWeightData = [FBBodyWeightData bodyWeightDataFromDictionary:weightMeasurement];
                    [arrayOfBodyWeightObjects addObject:bodyWeightData];
                }
                
                
                [self.delegate gotResponseToBodyWeightQuery:arrayOfBodyWeightObjects];
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
        if([jsonResult isKindOfClass:[NSDictionary class]]) {
            jsonResult = [jsonResult objectForKey:@"fat"];
        }
        
        if(jsonResult && [jsonResult isKindOfClass:[NSArray class]]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToBodyFatQuery:)]) {
                
                NSMutableArray *arrayOfBodyFatObjects = [NSMutableArray array];
                
                for(NSDictionary *fatMeasurement in jsonResult) {
                    FBBodyFatData *bodyFatData = [FBBodyFatData bodyFatFromDictionary:fatMeasurement];
                    [arrayOfBodyFatObjects addObject:bodyFatData];
                }

                
                [self.delegate gotResponseToBodyFatQuery:arrayOfBodyFatObjects];
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


- (void) fetchActivityStats {
    
    NSURL *url = [NSURL URLWithString:@"http://api.fitbit.com/1/user/-/activities.json"];
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
                didFinishSelector:@selector(activityStatsRequestWithTicket:didFinishWithData:)
                  didFailSelector:@selector(activityStatsRequestWithTicket:didFailWithError:)];
    
}

- (void)activityStatsRequestWithTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
        
        id jsonResult = [responseBody JSONValue];
        
        if(jsonResult && [jsonResult isKindOfClass:[NSDictionary class]]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToActivityStatsQuery:)]) {
                
                FBActivityStats *activityStats = [FBActivityStats activityStatsFromDictionary: jsonResult];
                
                [self.delegate gotResponseToActivityStatsQuery:activityStats];
            }
        }
        
        else {
            NSLog(@"Invalid data format for GET: ACTIVITY STATS request.");
        }
    }
}

- (void)activityStatsRequestWithTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(activityStatsQueryFailedWithError:)]) {
            [self.delegate activityStatsQueryFailedWithError: error];
        }
    }    
}


@end
