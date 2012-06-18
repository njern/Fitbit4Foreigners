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

@property (retain, nonatomic) IBOutlet UILabel *stepsTakenLabel;
@property (retain, nonatomic) IBOutlet UILabel *floorClimbedLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceTravelledTodayLabel;
@property (retain, nonatomic) IBOutlet UILabel *caloriesBurnedTodayLabel;
@property (retain, nonatomic) IBOutlet UILabel *activeScoreLabel;

@property (retain, nonatomic) IBOutlet UIProgressView *stepsTakenProgressView;
@property (retain, nonatomic) IBOutlet UIProgressView *floorsClimbedProgressView;
@property (retain, nonatomic) IBOutlet UIProgressView *distanceTravelledProgressView;
@property (retain, nonatomic) IBOutlet UIProgressView *caloriesBurnedProgressView;
@property (retain, nonatomic) IBOutlet UIProgressView *activeScoreProgressView;


- (IBAction)getStartedButtonPressed:(UIButton *)sender;

@end
