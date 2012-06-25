//
//  FitbitActivityCell.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *EDIT_GOAL_BUTTON_PRESSED_NOTIFICATION = @"EDIT_GOAL_BUTTON_PRESSED_NOTIFICATION";

static NSString *STEPS_STRING = @"Steps";
static NSString *FLOORS_STRING = @"Floors";
static NSString *DISTANCE_STRING = @"Distance";
static NSString *CALORIES_OUT_STRING = @"Calories Out";
static NSString *ACTIVE_SCORE_STRING = @"Active Score";


@interface FitbitActivityCell : UITableViewCell



@property (retain, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *activityGoalLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *activityProgressView;


- (IBAction)editGoalButtonPressed:(UIButton *)sender;


@end
