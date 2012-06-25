//
//  FBBodyViewController.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/21/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefresh.h"
#import "FitbitResources.h"
@interface FBBodyViewController : UITableViewController <FitbitResourcesDelegate, SSPullToRefreshViewDelegate>

@end
