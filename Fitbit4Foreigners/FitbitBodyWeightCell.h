//
//  FitbitBodyWeightCell.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/21/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitbitBodyWeightCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UIImageView *weightImageView;

@property (retain, nonatomic) IBOutlet UILabel *weightLabel;
@property (retain, nonatomic) IBOutlet UILabel *BMILabel;
@property (retain, nonatomic) IBOutlet UILabel *fatPercentLabel;

- (IBAction)editFatButtonPressed:(UIButton *)sender;
- (IBAction)editWeightButtonPressed:(UIButton *)sender;


@end
