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
    
    NSLog(@"Fetching test data...");
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotResponseToDevicesQuery:)]) {
                [self.delegate gotResponseToDevicesQuery:jsonResult];
            }
        }
        
        else {
            NSLog(@"Invalid data format for GET: Devices request.");
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




@end
