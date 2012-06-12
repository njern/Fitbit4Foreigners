//
//  ViewController.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/9/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitbitAuthorization.h"

@interface ViewController : UIViewController <FitbitAuthorizationDelegate>

@property (retain, nonatomic) IBOutlet UIButton *getStartedButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *gettingStartedSpinner;

- (IBAction)getStartedButtonPressed:(UIButton *)sender;

@end
