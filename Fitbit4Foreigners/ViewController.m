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

@interface ViewController ()

@property (nonatomic, retain) FitbitAuthorization *fitbitAuthorization;

@end

@implementation ViewController
@synthesize getStartedButton;
@synthesize gettingStartedSpinner;

@synthesize fitbitAuthorization;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
    self.fitbitAuthorization = nil;
    
    [getStartedButton release];
    [gettingStartedSpinner release];
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
    
    
    if(self.fitbitAuthorization.isAuthorized == NO) {
        self.getStartedButton.hidden = NO;
        
    }
    
    else {
        // FETCH DATA ABOUT USER!
    
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
  
}

- (void)viewDidUnload
{
    [self setGetStartedButton:nil];
    [self setGettingStartedSpinner:nil];
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




@end
