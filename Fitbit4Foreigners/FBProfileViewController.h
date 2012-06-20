//
//  FBProfileViewController.h
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitbitResources.h"
#import "FitbitAuthorization.h"
#import "SSPullToRefresh.h"
@interface FBProfileViewController : UITableViewController <FitbitResourcesDelegate, FitbitAuthorizationDelegate, SSPullToRefreshViewDelegate>

@end
