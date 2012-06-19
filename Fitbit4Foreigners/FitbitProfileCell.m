//
//  FitbitProfileCell.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FitbitProfileCell.h"



@implementation FitbitProfileCell
@synthesize profileImageView;
@synthesize profileNameLabel;
@synthesize profileTrackerStatusLabel;


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
    [profileImageView release];
    [profileNameLabel release];
    [profileTrackerStatusLabel release];
    [super dealloc];
}
@end
