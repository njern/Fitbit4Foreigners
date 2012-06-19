//
//  FitbitActivityCell.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FitbitActivityCell.h"

@implementation FitbitActivityCell
@synthesize activityNameLabel;
@synthesize activityGoalLabel;
@synthesize activityProgressView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [activityNameLabel release];
    [activityGoalLabel release];
    [activityProgressView release];
    [super dealloc];
}
@end
