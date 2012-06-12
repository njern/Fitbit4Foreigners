//
//  FitbitAuthorization.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/12/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"


static NSString *CONSUMER_KEY = @"627756a507a340b5915e5529af4265db";
static NSString *CONSUMER_SECRET = @"4d4c2c02cd80472c8369f7c179ce701d";
static NSString *REQUEST_TOKEN_URL = @"http://api.fitbit.com/oauth/request_token";
static NSString *AUTHORIZE_URL = @"https://www.fitbit.com/oauth/authorize";
static NSString *ACCESS_TOKEN_URL = @"https://api.fitbit.com/oauth/access_token";

@protocol FitbitAuthorizationDelegate <NSObject>

@required

- (void) gotAuthorizationURL: (NSURL *) url;
- (void) failedToGetAuthorizationURL: (NSError *) error;

- (void) successfullyFetchedAuthorizedToken;
- (void) failedToFetchAuthorizedToken: (NSError *) error;

@end

@interface FitbitAuthorization : NSObject

- (void) fetchAuthorizationURL; // Calls the delegate's gotAuthorizationURL / failedToGetAuthorizationURL when finished.
- (void) fetchAuthorizedOpenAuthTokenWithVerifier: (NSString *) oAuthVerifier; // Fetches an authorized oAuth token after the user has approved the app.

@property (nonatomic, readonly) BOOL isAuthorized; // YES if an authorized token exists.
@property (nonatomic, readonly) OAToken *unAuthorizedoAuthToken; // The UNAUTHORIZED oAuth token.
@property (nonatomic, readonly) OAToken *oAuthToken; // The AUTHORIZED oAuth token, loaded when the object is inited.

@property (nonatomic, assign) NSObject<FitbitAuthorizationDelegate> *delegate;


@end
