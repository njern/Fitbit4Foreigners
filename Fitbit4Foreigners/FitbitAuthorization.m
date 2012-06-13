//
//  FitbitAuthorization.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/12/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FitbitAuthorization.h"



@implementation FitbitAuthorization {
    OAToken *accessToken;
    OAToken *unAuthorizedAccessToken;
}

@synthesize unAuthorizedoAuthToken = unAuthorizedAccessToken;
@synthesize oAuthToken = accessToken;
@synthesize delegate;

+ (NSString *) pathToSavedTokens {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];  
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"tokens.plist"];
   
    return filePath;
}

+ (id) loadAuthorizedKeysFromDisk {
    
    id unarchivedObject = [[NSKeyedUnarchiver unarchiveObjectWithFile: [FitbitAuthorization pathToSavedTokens]] retain];
    return [unarchivedObject autorelease];
}

+ (void) saveAuthorizedKeyToDisk: (OAToken *) _accessToken {
    
    [NSKeyedArchiver archiveRootObject: _accessToken toFile:[FitbitAuthorization pathToSavedTokens]]; 
}

- (BOOL) isAuthorized {
    if(self->accessToken != nil) {
        return YES;
    }
    
    return NO;
}


- (id) init {
    
    if(self == [super init]) {
        self->accessToken = [[FitbitAuthorization loadAuthorizedKeysFromDisk] retain];
    }
    
    return self;
}




- (void) fetchAuthorizationURL {
    
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    NSURL *url = [NSURL URLWithString:REQUEST_TOKEN_URL];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:nil   // we don't have a Token yet
                                                                       realm:nil   // our service provider doesn't specify a realm
                                                           signatureProvider:nil] 
                                    autorelease]; // use the default method, HMAC-SHA1
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
        
        OAToken *requestToken = [[[OAToken alloc] initWithHTTPResponseBody:responseBody] autorelease];
        self->unAuthorizedAccessToken = [requestToken retain]; // Save the unauthorized token.
        
        NSString *urlString = [NSString stringWithFormat:@"https://www.fitbit.com/oauth/authorize?oauth_token=%@", requestToken.key];
        NSURL *url = [NSURL URLWithString:urlString];
       
        if(self.delegate != nil) {
            if([self.delegate respondsToSelector:@selector(gotAuthorizationURL:)]) {
                [self.delegate gotAuthorizationURL:url];
            }
        }
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(failedToGetAuthorizationURL:)]) {
            [self.delegate failedToGetAuthorizationURL:error];
        }
    }
}


- (void) fetchAuthorizedOpenAuthTokenWithVerifier: (NSString *) oAuthVerifier; {
    
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    NSURL *url = [NSURL URLWithString:ACCESS_TOKEN_URL];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:consumer
                                                                       token:self->unAuthorizedAccessToken   // We have a token now
                                                                       realm:nil   // our service provider doesn't specify a realm
                                                           signatureProvider:nil] 
                                    autorelease]; // use the default method, HMAC-SHA1
    
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter *verifierParam = [[[OARequestParameter alloc] initWithName:@"oauth_verifier"
                                                                       value:oAuthVerifier] autorelease];
    NSArray *params = [NSArray arrayWithObjects:verifierParam, nil];
    [request setParameters:params];
    
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithAuthorizedTokenData:)
                  didFailSelector:@selector(requestTokenTicket:authorizedTokenFetchdidFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithAuthorizedTokenData:(NSData *)data {
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    
    if (ticket.didSucceed) {
        
        OAToken *requestToken = [[[OAToken alloc] initWithHTTPResponseBody:responseBody] autorelease];
        
        self->accessToken = [requestToken retain]; // Set the AUTHORIZED token.
        [FitbitAuthorization saveAuthorizedKeyToDisk: requestToken]; // Save it to disk as well.
        
        if(self.delegate != nil) {
            if([self.delegate respondsToSelector:@selector(successfullyFetchedAuthorizedToken)]) {
                [self.delegate successfullyFetchedAuthorizedToken];
            }
        }
    }
    
    else {
        NSLog(@"Epic fail in requestTokenTicket: didFinishWithAuthorizedTokenData: -> ticket.didSucceed = NO");
        NSLog(@"Data: %@", responseBody);
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket authorizedTokenFetchdidFailWithError:(NSError *)error {
    
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(failedToFetchAuthorizedToken:)]) {
            [self.delegate failedToFetchAuthorizedToken:error];
        }
    }
}



@end
