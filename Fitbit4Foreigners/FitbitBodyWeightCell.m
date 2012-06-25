//
//  FitbitBodyWeightCell.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/21/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FitbitBodyWeightCell.h"

@implementation FitbitBodyWeightCell
@synthesize weightImageView;
@synthesize weightLabel;
@synthesize BMILabel;
@synthesize fatPercentLabel;

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
    [weightLabel release];
    [BMILabel release];
    [fatPercentLabel release];
    [weightImageView release];
    [super dealloc];
}

- (IBAction)editFatButtonPressed:(UIButton *)sender {
    
}
- (IBAction)editWeightButtonPressed:(UIButton *)sender {

}

@end
