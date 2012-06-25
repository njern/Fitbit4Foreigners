//
//  DateSelectionCell.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/20/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *DATE_NEXT_BUTTON_PRESSED = @"DATE_NEXT_BUTTON_PRESSED";
static NSString *DATE_PREVIOUS_BUTTON_PRESSED = @"DATE_PREVIOUS_BUTTON_PRESSED";

@interface DateSelectionCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *dateTextLabel;

- (IBAction)backButtonPressed:(UIButton *)sender;
- (IBAction)forwardButtonPressed:(UIButton *)sender;


@end
