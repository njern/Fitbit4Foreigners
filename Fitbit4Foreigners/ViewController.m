//
//  ViewController.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/9/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//


#import "ViewController.h"
#import "OAuthConsumer.h"
#import "AppDelegate.h"
#import "AsyncImageView.h"
#import "FBUserInfo.h"


@interface ViewController ()

@property (nonatomic, retain) FitbitAuthorization *fitbitAuthorization;
@property (nonatomic, retain) FitbitResources *fitbitResources;
@end

@implementation ViewController

@synthesize getStartedButton;
@synthesize gettingStartedSpinner;
@synthesize userInterfaceContainerView;
@synthesize profileImageView;
@synthesize profileNameLabel;
@synthesize fitbitResources;

@synthesize fitbitAuthorization;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
    self.fitbitAuthorization = nil;
    self.fitbitResources = nil;
    
    [getStartedButton release];
    [gettingStartedSpinner release];
    [profileImageView release];
    [profileNameLabel release];
    [userInterfaceContainerView release];
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.gettingStartedSpinner.hidden = YES;    
    
    self.fitbitAuthorization = [[[FitbitAuthorization alloc] init] autorelease];
    self.fitbitAuthorization.delegate = self;
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.fitbitAuthorization = self->fitbitAuthorization;
    
    self.fitbitResources = [[[FitbitResources alloc] initWithAuthorizationObject:self.fitbitAuthorization] autorelease];
    self.fitbitResources.delegate = self;
    
    if(self.fitbitAuthorization.isAuthorized == NO) {
        self.getStartedButton.hidden = NO;
        
    }
    
    else {
        self.userInterfaceContainerView.hidden = NO;
        
        [self.fitbitResources fetchMyUserInfo];
        [self.fitbitResources fetchDevices];
        // FETCH DATA ABOUT USER!
    
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
  
}

- (void)viewDidUnload
{
    [self setGetStartedButton:nil];
    [self setGettingStartedSpinner:nil];
    [self setProfileImageView:nil];
    [self setProfileNameLabel:nil];
    [self setUserInterfaceContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
       
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)getStartedButtonPressed:(UIButton *)sender {
    self.gettingStartedSpinner.hidden = NO;
    [self.gettingStartedSpinner startAnimating];
    
    [self.fitbitAuthorization fetchAuthorizationURL];
}


// FitbitAuthorizationDelegate.

- (void) gotAuthorizationURL: (NSURL *) url {

    [[UIApplication sharedApplication] openURL:url];
}
- (void) failedToGetAuthorizationURL: (NSError *) error {

    NSLog(@"Error getting oAuth authorization URL: %@", [error localizedDescription]);
}

- (void) successfullyFetchedAuthorizedToken {
    
    NSLog(@"Successfully fetched the authorized token.");
    // DO STUFF
    
}
- (void) failedToFetchAuthorizedToken: (NSError *) error {
    NSLog(@"Error getting authorized oAuth token: %@", [error localizedDescription]);
}



// FitbitResourcesDelegate

- (void) gotResponseToDevicesQuery: (NSArray *) devices {
    NSLog(@"Device: %@", [devices lastObject]);
}
- (void) devicesQueryFailedWithError: (NSError *) error {
    
}

- (void) gotResponseToActivitiesQuery: (FBDailyActivity *) response {
    
}
- (void) activitiesQueryFailedWithError: (NSError *) error {
    
}

- (void) gotResponseToMyUserInfoQuery: (FBUserInfo *) response {
    
    self.profileImageView.imageURL = response.avatarURL;
    self.profileNameLabel.text = response.fullName;
    
}
- (void) myUserInfoQueryFailedWithError: (NSError *) error {
    NSLog(@"%@", error);
    
}

- (void) gotResponseToBodyMeasurementsQuery: (FBBodyMeasurement *) response {
    
}
- (void) bodyMeasurementsQueryFailedWithError: (NSError *) error {
    
}

- (void) gotResponseToBodyWeightQuery: (NSArray *) response {
    
}
- (void) bodyWeightQueryFailedWithError: (NSError *) error {
    
}

- (void) gotResponseToBodyFatQuery: (NSArray *) response {
    
}
- (void) bodyFatQueryFailedWithError: (NSError *) error {
    
}

- (void) gotResponseToActivityStatsQuery: (FBActivityStats *) response {
    
}
- (void) activityStatsQueryFailedWithError: (NSError *) error {
    
}



@end
