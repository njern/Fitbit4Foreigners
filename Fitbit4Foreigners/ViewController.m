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
#import "FBDailyActivity.h"

@interface ViewController ()

@property (nonatomic, retain) FitbitAuthorization *fitbitAuthorization;
@property (nonatomic, retain) FitbitResources *fitbitResources;

@property (nonatomic, retain) FBDailyActivity *currentdailyActivity;

@end

@implementation ViewController

@synthesize getStartedButton;
@synthesize gettingStartedSpinner;
@synthesize userInterfaceContainerView;
@synthesize profileImageView;
@synthesize profileNameLabel;
@synthesize stepsTakenLabel;
@synthesize floorClimbedLabel;
@synthesize distanceTravelledTodayLabel;
@synthesize caloriesBurnedTodayLabel;
@synthesize activeScoreLabel;
@synthesize stepsTakenProgressView;
@synthesize floorsClimbedProgressView;
@synthesize distanceTravelledProgressView;
@synthesize caloriesBurnedProgressView;
@synthesize activeScoreProgressView;
@synthesize fitbitResources;

@synthesize fitbitAuthorization;

@synthesize currentdailyActivity;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    self.fitbitAuthorization = nil;
    self.fitbitResources = nil;
    
    [getStartedButton release];
    [gettingStartedSpinner release];
    [profileImageView release];
    [profileNameLabel release];
    [userInterfaceContainerView release];
    [stepsTakenLabel release];
    [floorClimbedLabel release];
    [distanceTravelledTodayLabel release];
    [caloriesBurnedTodayLabel release];
    [activeScoreLabel release];
    [stepsTakenProgressView release];
    [floorsClimbedProgressView release];
    [distanceTravelledProgressView release];
    [caloriesBurnedProgressView release];
    [activeScoreProgressView release];
    
    self.currentdailyActivity = nil;
    
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
        [self.fitbitResources fetchMyActivitiesForDate:[NSDate date]];
        
        //[self.fitbitResources fetchActivityStats];
        //[self.fitbitResources fetchBodyFatDataFromDate:[NSDate date] untilDate:[NSDate date]];
        //[self.fitbitResources fetchBodyWeightDataFromDate:[NSDate date] untilDate:[NSDate date]];
        //[self.fitbitResources fetchBodyMeasurementsForDate:[NSDate date]];
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
    [self setStepsTakenLabel:nil];
    [self setFloorClimbedLabel:nil];
    [self setDistanceTravelledTodayLabel:nil];
    [self setCaloriesBurnedTodayLabel:nil];
    [self setActiveScoreLabel:nil];
    [self setStepsTakenProgressView:nil];
    [self setFloorsClimbedProgressView:nil];
    [self setDistanceTravelledProgressView:nil];
    [self setCaloriesBurnedProgressView:nil];
    [self setActiveScoreProgressView:nil];
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

- (UIColor *) colorForScore: (NSNumber *) achieved ofGoal: (NSNumber *) goal {
    
    if([achieved floatValue] / [goal floatValue] < 0.25) {
        return [UIColor redColor];
    }
    
    else if([achieved floatValue] / [goal floatValue] < 0.5) {
        return [UIColor orangeColor];
    }
    
    else if([achieved floatValue] / [goal floatValue] < 0.75) {
        return [UIColor yellowColor];
    }
    
    else if([achieved floatValue] / [goal floatValue] < 0.99) {
        return [UIColor greenColor];
    }
    
    return [UIColor blueColor];
    
}

- (void) redrawProgressBars {
    // Set colors
    self.stepsTakenProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.steps ofGoal:self.currentdailyActivity.goalSteps];
    self.floorsClimbedProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.floors ofGoal:self.currentdailyActivity.goalFloors];
    self.distanceTravelledProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.distance ofGoal:self.currentdailyActivity.goalDistance];
    self.caloriesBurnedProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.caloriesOut ofGoal:self.currentdailyActivity.goalCaloriesOut];
    self.activeScoreProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.activeScore ofGoal:self.currentdailyActivity.goalActiveScore];
    
    
    // Set values
    
    self.stepsTakenProgressView.progress = [self.currentdailyActivity.steps floatValue] / [self.currentdailyActivity.goalSteps floatValue];
    self.floorsClimbedProgressView.progress = [self.currentdailyActivity.floors floatValue] / [self.currentdailyActivity.goalFloors floatValue];
    self.distanceTravelledProgressView.progress = [self.currentdailyActivity.distance floatValue] / [self.currentdailyActivity.goalDistance floatValue];    
    self.caloriesBurnedProgressView.progress = [self.currentdailyActivity.caloriesOut floatValue] / [self.currentdailyActivity.goalCaloriesOut floatValue];    
    self.activeScoreProgressView.progress = [self.currentdailyActivity.activeScore floatValue] / [self.currentdailyActivity.goalActiveScore floatValue];    
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
    
    self.currentdailyActivity = response;
    
    self.stepsTakenLabel.text = [NSString stringWithFormat:@"%@ steps taken today", response.steps];
    self.floorClimbedLabel.text = [NSString stringWithFormat:@"%@ floors climbed today", response.floors];
    self.distanceTravelledTodayLabel.text = [NSString stringWithFormat:@"%@ km travelled today", response.distance];
    self.caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%@ calories burned today", response.caloriesOut];
    self.activeScoreLabel.text = [NSString stringWithFormat:@"%@ active score", response.activeScore];
    
    
    [self redrawProgressBars];
    
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
