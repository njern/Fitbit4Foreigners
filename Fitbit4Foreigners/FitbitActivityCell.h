//
//  FitbitActivityCell.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *EDIT_GOAL_BUTTON_PRESSED_NOTIFICATION = @"EDIT_GOAL_BUTTON_PRESSED_NOTIFICATION";

@interface FitbitActivityCell : UITableViewCell



@property (retain, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *activityGoalLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *activityProgressView;


- (IBAction)editGoalButtonPressed:(UIButton *)sender;


@end
