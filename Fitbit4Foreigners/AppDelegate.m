//
//  AppDelegate.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/9/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize fitbitAuthorization;
@synthesize fitbitResources;
@synthesize dateToGetInfoFor;

- (void)dealloc
{
    [_window release];
    self.dateToGetInfoFor = nil;
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.dateToGetInfoFor = [NSDate date];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    /**
     * This method is called when the app is opened by Safari
     * after the user has accepted our oAuth request on the
     * Fitbit website.
     *
     * We pass the oAuthVerifier contained in the URL back to the FitbitAuthorization object.
     */
    
    NSString *urlString = [NSString stringWithFormat:@"%@", [url absoluteURL]];
    NSArray *components = [urlString componentsSeparatedByString:@"oauth_verifier="];
    
    NSString *oAuthVerifier = [components lastObject];
    
    if(self->fitbitAuthorization) {
        if(self->fitbitAuthorization.delegate) {
            
            if(self->fitbitAuthorization.unAuthorizedoAuthToken != nil && self->fitbitAuthorization.oAuthToken == nil) {
                [self->fitbitAuthorization fetchAuthorizedOpenAuthTokenWithVerifier:oAuthVerifier];
            }
        }
    }
    
    return YES;  
}

@end
