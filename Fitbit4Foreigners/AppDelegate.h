//
//  AppDelegate.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/9/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitbitAuthorization.h"

static NSString *USER_AUTHORIZED_APP_NOTIFICATION = @"UserDidAuthorizeFitbitInWebView";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) FitbitAuthorization *fitbitAuthorization;

@end
