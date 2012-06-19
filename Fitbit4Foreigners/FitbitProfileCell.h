//
//  FitbitProfileCell.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitbitProfileCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *profileTrackerStatusLabel;

@end
