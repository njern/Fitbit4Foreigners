//
//  DateSelectionCell.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/20/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "DateSelectionCell.h"

@implementation DateSelectionCell
@synthesize dateTextLabel;

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
    [dateTextLabel release];
    [super dealloc];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:DATE_PREVIOUS_BUTTON_PRESSED 
     object:self];
    
}
- (IBAction)forwardButtonPressed:(UIButton *)sender {

    [[NSNotificationCenter defaultCenter]
     postNotificationName:DATE_NEXT_BUTTON_PRESSED 
     object:self];
}

@end
