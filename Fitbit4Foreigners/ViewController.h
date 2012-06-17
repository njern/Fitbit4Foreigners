//
//  ViewController.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/9/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitbitAuthorization.h"
#import "FitbitResources.h"

@interface ViewController : UIViewController <FitbitAuthorizationDelegate, FitbitResourcesDelegate>

@property (retain, nonatomic) IBOutlet UIButton *getStartedButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *gettingStartedSpinner;


@property (retain, nonatomic) IBOutlet UIView *userInterfaceContainerView;
@property (retain, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) IBOutlet UILabel *profileNameLabel;


- (IBAction)getStartedButtonPressed:(UIButton *)sender;

@end
