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


- (void) testTokenIsWorking {
    
    NSLog(@"Fetching test data...");
    NSURL *url = [NSURL URLWithString:@"http://api.fitbit.com/1/user/-/devices.json"];
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                                     secret:CONSUMER_SECRET] autorelease];
    
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:self->fitbitAuthorization.oAuthToken
                                                                      realm:nil
                                                          signatureProvider:nil]
                                    autorelease];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(apiTicket:didFinishWithData:)
                  didFailSelector:@selector(apiTicket:didFailWithError:)];
}

- (void)apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    NSString *responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
    
        NSLog(@"Response to devices query was: %@", responseBody);
    }
    
    else {
        NSLog(@"Test data ticket failed: %@", responseBody);
    }
}

- (void)apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    
    NSLog(@"Error response to devices query was: %@", [error localizedDescription]);

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
        [self testTokenIsWorking];
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
    [self testTokenIsWorking];
    
}
- (void) failedToFetchAuthorizedToken: (NSError *) error {
    NSLog(@"Error getting authorized oAuth token: %@", [error localizedDescription]);
}




@end
