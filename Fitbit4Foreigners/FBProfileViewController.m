//
//  FBProfileViewController.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/19/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBProfileViewController.h"
#import "FitbitAuthorization.h"
#import "FitbitResources.h"
#import "FBDailyActivity.h"
#import "AppDelegate.h"
#import "FBUserInfo.h"
#import "FBDevice.h"
#import "AsyncImageView.h"
#import "UACellBackgroundView.h"
#import "FitbitProfileCell.h"
#import "FitbitActivityCell.h"
#import "DateSelectionCell.h"
#import "TimeUtilities.h"
#import "MBProgressHUD.h"


#define NUMBER_OF_SECTIONS 3
#define DATE_SELECTION_SECTION 0
#define PROFILE_CELL_SECTION 1
#define ACTIVITIES_CELL_SECTION 2

@interface FBProfileViewController ()


@property (nonatomic, retain) FitbitAuthorization *fitbitAuthorization;
@property (nonatomic, retain) FitbitResources *fitbitResources;
@property (nonatomic, retain) FBDailyActivity *currentdailyActivity;
@property (nonatomic, retain) FBUserInfo *userInfo;
@property (nonatomic, retain) NSArray *devices;

@property (nonatomic, retain) UINib *profileCellLoader;
@property (nonatomic, retain) UINib *activityCellLoader;
@property (nonatomic, retain) UINib *dateCellLoader;

@property (nonatomic, retain) NSDate *lastRefreshDate;
@property (nonatomic, retain) SSPullToRefreshView *pullToRefreshView;

@end

@implementation FBProfileViewController

@synthesize fitbitAuthorization;
@synthesize fitbitResources;
@synthesize currentdailyActivity;
@synthesize userInfo;
@synthesize devices;

@synthesize profileCellLoader;
@synthesize activityCellLoader;
@synthesize dateCellLoader;

@synthesize lastRefreshDate;
@synthesize pullToRefreshView;

- (void) dealloc {
    self.fitbitAuthorization = nil;
    self.fitbitResources = nil;
    self.currentdailyActivity = nil;
    self.userInfo = nil;
    self.devices = nil;
    
    self.profileCellLoader = nil;
    self.activityCellLoader = nil;
    self.dateCellLoader = nil;
    
    self.lastRefreshDate = nil;
    self.pullToRefreshView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Use lazy initialization for Cell Loaders.
- (UINib *) profileCellLoader {
    if(self->profileCellLoader == nil) {
        self->profileCellLoader = [[UINib nibWithNibName:@"FitbitProfileCell" bundle:[NSBundle mainBundle]] retain];
    }
    return self->profileCellLoader;
}

- (UINib *) activityCellLoader {
    if(self->activityCellLoader == nil) {
        self->activityCellLoader = [[UINib nibWithNibName:@"FitbitActivityCell" bundle:[NSBundle mainBundle]] retain];
    }
    return self->activityCellLoader;
}

- (UINib *) dateCellLoader {
    if(self->dateCellLoader == nil) {
        self->dateCellLoader = [[UINib nibWithNibName:@"DateSelectionCell" bundle:[NSBundle mainBundle]] retain];
    }
    
    return self->dateCellLoader;
}


/**
 * Convenience method for setting the  
 * color best corresponding to the percent
 * of the user's goal that has been achieved.
 */
- (UIColor *) colorForScore: (NSNumber *) achieved ofGoal: (NSNumber *) goal {
    
    if([achieved floatValue] / [goal floatValue] < 0.25) {
        return [UIColor redColor];
    }
    
    else if([achieved floatValue] / [goal floatValue] < 0.5) {
        return [UIColor orangeColor];
    }
    
    else if([achieved floatValue] / [goal floatValue] < 0.75) {
        return [UIColor yellowColor];
    }
    
    else if([achieved floatValue] / [goal floatValue] < 0.99) {
        return [UIColor blueColor];
    }
    
    return [UIColor greenColor];
    
}

// 
- (void)rightSwipe:(id)sender
{
    NSLog(@"Right swipe detected!"); // Means we're going back in time -> remove 1 day
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
   
    NSDateComponents *dayComponent = [[[NSDateComponents alloc] init] autorelease];
    dayComponent.day = -1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    appDelegate.dateToGetInfoFor = [theCalendar dateByAddingComponents:dayComponent toDate:appDelegate.dateToGetInfoFor options:0];
    
    [self refreshWithHUD];
}

- (void)leftSwipe:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
   
    if([TimeUtilities dateIsToday:appDelegate.dateToGetInfoFor]) {
        // Do nothing, we can't go forward in time.
    }
    
    else {
        NSDateComponents *dayComponent = [[[NSDateComponents alloc] init] autorelease];
        dayComponent.day = 1;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        appDelegate.dateToGetInfoFor = [theCalendar dateByAddingComponents:dayComponent toDate:appDelegate.dateToGetInfoFor options:0];
        
            [self refreshWithHUD];
    }
    NSLog(@"Left swipe detected!"); // We're going forward in time, add a day (unless it's already today)
}

- (void) previousDayButtonTapped: (NSNotification *) notification {
    if ([self.tabBarController.selectedViewController isEqual:self]) {
        // If this is the currently selected controller, handle the event.
        [self rightSwipe:notification];
    }
}

- (void) nextDayButtonTapped: (NSNotification *) notification {
    if ([self.tabBarController.selectedViewController isEqual:self]) {
        // If this is the currently selected controller, handle the event.
        [self leftSwipe:notification];
    }    
}

// Handle incoming "edit goal" notifications
- (void) editGoalNotificationReceived: (NSNotification *) notification {
    
    id sender = [notification.userInfo objectForKey:@"sender"];
    
    if([sender isKindOfClass:[FitbitActivityCell class]]) {
        NSLog(@"Got notification from %@ cell", [(FitbitActivityCell *) sender activityNameLabel].text);
        
        NSString *senderName = [(FitbitActivityCell *) sender activityNameLabel].text;
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:senderName message:@"Enter new goal:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField.placeholder = @"";
        [alert show];
        [alert release];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Hook up the pull to refresh view.
    UITableView *tableView = (UITableView *) self.view;
    self.pullToRefreshView = [[[SSPullToRefreshView alloc] initWithScrollView:tableView delegate:self] autorelease];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.fitbitAuthorization = [[[FitbitAuthorization alloc] init] autorelease];
    self.fitbitAuthorization.delegate = self;
    
    appDelegate.fitbitAuthorization = self->fitbitAuthorization;
    appDelegate.fitbitResources = self->fitbitResources;
    
    self.fitbitResources = [[[FitbitResources alloc] initWithAuthorizationObject:self.fitbitAuthorization] autorelease];
    self.fitbitResources.delegate = self;

    // Share the Fitbit objects via the App Delegate.
    appDelegate.fitbitAuthorization = self->fitbitAuthorization;
    appDelegate.fitbitResources = self->fitbitResources;
    
    
    if(self.fitbitAuthorization.isAuthorized == NO) {
        NSLog(@"Fail, authorization flow not implemented in the new view controller!");
    }
    
    else {
        
        [self refreshWithHUD]; 
        
        //[self.fitbitResources fetchActivityStats];
        //[self.fitbitResources fetchBodyFatDataFromDate:[NSDate date] untilDate:[NSDate date]];
        //[self.fitbitResources fetchBodyWeightDataFromDate:[NSDate date] untilDate:[NSDate date]];
        //[self.fitbitResources fetchBodyMeasurementsForDate:[NSDate date]];
        // FETCH DATA ABOUT USER!
        
    }
    
    
    // Subscribe to "Edit Goal" notifications
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(editGoalNotificationReceived:)
     name:EDIT_GOAL_BUTTON_PRESSED_NOTIFICATION
     object:nil];    
    
    // Subscribe to "Previous date button" notifications
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(previousDayButtonTapped:)
     name:DATE_PREVIOUS_BUTTON_PRESSED
     object:nil];    
    
    // Subscribe to "Next date button" notifications
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(nextDayButtonTapped:)
     name:DATE_NEXT_BUTTON_PRESSED
     object:nil];    
    
    // Set up swipe detection.
    
    // Recognizing RIGHT swiping gestures
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:rightSwipeGestureRecognizer];
    [rightSwipeGestureRecognizer release];
    
    // Recognizing LEFT swiping gestures
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:leftSwipeGestureRecognizer];
    [leftSwipeGestureRecognizer release];
    
    
    // Set our image background && make sure it shows through.
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_metal_grid.png.png"]];
    [(UITableView *) self.view setSeparatorColor: [UIColor clearColor]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    UITableView *tableView = (UITableView *) self.view;
    [tableView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case DATE_SELECTION_SECTION:
            return 1;
        case PROFILE_CELL_SECTION:
            return 1;
        case ACTIVITIES_CELL_SECTION:
            return 5;
        default:
            return 0;
    }    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    switch (indexPath.section) {
     
        
        case DATE_SELECTION_SECTION: {
            
            DateSelectionCell *dateSelectionCell = [tableView dequeueReusableCellWithIdentifier:@"DateSelectionCell"];
            
            if(dateSelectionCell == nil) {
                NSArray *topLevelItems = [self.dateCellLoader instantiateWithOwner:self options:nil];
                dateSelectionCell = [topLevelItems objectAtIndex:0];
            }
            
            dateSelectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if([TimeUtilities dateIsToday:appDelegate.dateToGetInfoFor]) {
                dateSelectionCell.dateTextLabel.text = @"Today";
            }
            
            else {
             
                NSDateComponents *dayComponent = [[[NSDateComponents alloc] init] autorelease];
                dayComponent.day = 1;
                
                NSCalendar *theCalendar = [NSCalendar currentCalendar];
                NSDate *datePlusOneDay = [theCalendar dateByAddingComponents:dayComponent toDate:appDelegate.dateToGetInfoFor options:0];
                
                if([TimeUtilities dateIsToday:datePlusOneDay]) {
                    dateSelectionCell.dateTextLabel.text = @"Yesterday";
                }
                
                else {
                    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                    [dateFormatter setDateFormat:@"dd. MMM"];
                    dateSelectionCell.dateTextLabel.text = [dateFormatter stringFromDate:appDelegate.dateToGetInfoFor];
                }

            }                
                
            
            return dateSelectionCell;
            
        }
            break;
        
        case PROFILE_CELL_SECTION: {
            
            // Load the : with our custom loader
            FitbitProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"FitbitProfileCell"];
            
            if(profileCell == nil) {
                NSArray *topLevelItems = [self.profileCellLoader instantiateWithOwner:self options:nil];
                profileCell = [topLevelItems objectAtIndex:0];
            }
            
            // Set not selectable
            profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Set all the stuff.
            profileCell.backgroundView = [UACellBackgroundView getBackgroundCellView];
            [(UACellBackgroundView *) profileCell.backgroundView setPosition:UACellBackgroundViewPositionSingle];
            
            // Set the profile image to the default male image while waiting for the real result.
            profileCell.profileImageView.image = [UIImage imageNamed:@"defaultProfileImage.png"];
            
            // Load the real profile image asynchronously.
            profileCell.profileImageView.imageURL = self.userInfo.avatarURL;
            
            // Add rounded edges to the imageView
            CALayer * l = [profileCell.profileImageView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:5.0];
            
            profileCell.profileNameLabel.backgroundColor = [UIColor clearColor];
            profileCell.profileNameLabel.text = self.userInfo.fullName;
            
            FBDevice *tracker = [self.devices lastObject];
            
            profileCell.profileTrackerStatusLabel.backgroundColor = [UIColor clearColor];
            profileCell.profileTrackerStatusLabel.text = [NSString stringWithFormat:@"Tracker last synced %@", [TimeUtilities getNicelyFormattedTimeSinceDate:tracker.lastSyncTime]];
            
            return profileCell;
        }
            break;
            
        case ACTIVITIES_CELL_SECTION: {
            
            // Load the FitbitActivityCell with our custom loader.
            FitbitActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"FitbitActivityCell"];
            
            if(activityCell == nil) {
                NSArray *topLevelItems = [self.activityCellLoader instantiateWithOwner:self options:nil];
                activityCell = [topLevelItems objectAtIndex:0];
            }
            
            // Set not selectable
            activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch(indexPath.row) {
                case 0: {
                    // Top position
                    activityCell.backgroundView = [UACellBackgroundView getBackgroundCellView];
                    [(UACellBackgroundView *) activityCell.backgroundView setPosition:UACellBackgroundViewPositionTop];
                    
                    // Steps
                    activityCell.activityNameLabel.text = STEPS_STRING;
                    activityCell.activityGoalLabel.text = [NSString stringWithFormat:@"%@ of goal %@", self.currentdailyActivity.steps, self.currentdailyActivity.goalSteps];
                    
                    activityCell.activityProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.steps ofGoal:self.currentdailyActivity.goalSteps];
                    activityCell.activityProgressView.progress = [self.currentdailyActivity.steps floatValue] / [self.currentdailyActivity.goalSteps floatValue];    
                    
                    
                }
                    break;
                case 1: {
                    
                    // Middle position
                    activityCell.backgroundView = [UACellBackgroundView getBackgroundCellView];
                    [(UACellBackgroundView *) activityCell.backgroundView setPosition:UACellBackgroundViewPositionMiddle];
                    
                    // Floors
                    activityCell.activityNameLabel.text = FLOORS_STRING;
                    activityCell.activityGoalLabel.text = [NSString stringWithFormat:@"%@ of goal %@", self.currentdailyActivity.floors, self.currentdailyActivity.goalFloors];
                    
                    activityCell.activityProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.floors ofGoal:self.currentdailyActivity.goalFloors];
                    activityCell.activityProgressView.progress = [self.currentdailyActivity.floors floatValue] / [self.currentdailyActivity.goalFloors floatValue];    
                    
                }
                    break;
                case 2: {
                    
                    // Middle position
                    activityCell.backgroundView = [UACellBackgroundView getBackgroundCellView];
                    [(UACellBackgroundView *) activityCell.backgroundView setPosition:UACellBackgroundViewPositionMiddle];
                    
                    // Distance
                    activityCell.activityNameLabel.text = DISTANCE_STRING;
                    activityCell.activityGoalLabel.text = [NSString stringWithFormat:@"%@ km of goal %@ km", self.currentdailyActivity.distance, self.currentdailyActivity.goalDistance];
                    
                    activityCell.activityProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.distance ofGoal:self.currentdailyActivity.goalDistance];
                    activityCell.activityProgressView.progress = [self.currentdailyActivity.distance floatValue] / [self.currentdailyActivity.goalDistance floatValue];    
                    
                }
                    break;
                case 3: {
                    
                    // Middle position
                    activityCell.backgroundView = [UACellBackgroundView getBackgroundCellView];
                    [(UACellBackgroundView *) activityCell.backgroundView setPosition:UACellBackgroundViewPositionMiddle];
                    
                    // Calories
                    activityCell.activityNameLabel.text = CALORIES_OUT_STRING;
                    activityCell.activityGoalLabel.text = [NSString stringWithFormat:@"%@ cal of goal %@", self.currentdailyActivity.caloriesOut, self.currentdailyActivity.goalCaloriesOut];
                    
                    activityCell.activityProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.caloriesOut ofGoal:self.currentdailyActivity.goalCaloriesOut];
                    activityCell.activityProgressView.progress = [self.currentdailyActivity.caloriesOut floatValue] / [self.currentdailyActivity.goalCaloriesOut floatValue];    
                    
                }
                    break;
                case 4: {
                    
                    // Bottom position
                    activityCell.backgroundView = [UACellBackgroundView getBackgroundCellView];
                    [(UACellBackgroundView *) activityCell.backgroundView setPosition:UACellBackgroundViewPositionBottom];
                    
                    // Active Score
                    activityCell.activityNameLabel.text = ACTIVE_SCORE_STRING;
                    activityCell.activityGoalLabel.text = [NSString stringWithFormat:@"%@ of goal %@",self.currentdailyActivity.activeScore, self.currentdailyActivity.goalActiveScore];
                    
                    activityCell.activityProgressView.progressTintColor = [self colorForScore:self.currentdailyActivity.activeScore ofGoal:self.currentdailyActivity.goalActiveScore];
                    activityCell.activityProgressView.progress = [self.currentdailyActivity.activeScore floatValue] / [self.currentdailyActivity.goalActiveScore floatValue];    
                    
                }
                    break;
            }
            
            return activityCell;
            // These are the activities, e.g steps taken, floors climbed, distance covered, calories out, active score.
        }
    }
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:@"Cell"]
                autorelease];
        
        // cell.textLabel.text = [NSString stringWithFormat:@"Section: %d, row: %d", indexPath.section, indexPath.row];                
    }
    // Configure the cell...
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == PROFILE_CELL_SECTION) {
        return 120;
    }
    
    if(indexPath.section == ACTIVITIES_CELL_SECTION) {
        return 75;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == PROFILE_CELL_SECTION) {
        return @"Profile";
    }
    
    if(section == ACTIVITIES_CELL_SECTION) {
        return @"Daily activities";
    }
    
    else return @"";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *text = @"";
    
    if(section == PROFILE_CELL_SECTION) {
        text = @"Profile";
    }
    
    else if(section == ACTIVITIES_CELL_SECTION) {
        text =  @"Daily activities";
    }
    
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    
	headerLabel.text = text;
	[customView addSubview:headerLabel];
    
	return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}



- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    
    if(path.section == DATE_SELECTION_SECTION || path.section == PROFILE_CELL_SECTION || path.section == ACTIVITIES_CELL_SECTION) {
        // We don't want the date cell / profile cell / activity cells to be selectable.        
        return nil;
    }
    
    else {
        return path;
    }
    
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
 if(section > 0) {
 
 UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)] autorelease];
 
 UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
 
 headerLabel.textAlignment = UITextAlignmentLeft;
 headerLabel.backgroundColor = [UIColor clearColor];
 
 if(section == 1) {
 headerLabel.text = @"Profile";
 }
 else if(section == 2) {
 headerLabel.text = @"Activities";
 }
 
 [headerView addSubview:headerLabel];
 [headerLabel release];
 
 return headerView;
 
 
 }
 
 return [super tableView:tableView viewForHeaderInSection:section];
 
 }
 
 -(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
 return  30.0;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark - helper methods / FitbitAuthorizationDelegate

- (void) reloadTableIfNecessary {
    
    if(self.currentdailyActivity && self.userInfo && self.devices) {
        
        self.lastRefreshDate = [NSDate date];
        
        [(UITableView *) self.view reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.pullToRefreshView finishLoading];
    }
}


#pragma mark - FitbitAuthorizationDelegate

- (void) gotAuthorizationURL: (NSURL *) url {
    
    [[UIApplication sharedApplication] openURL:url];
}
- (void) failedToGetAuthorizationURL: (NSError *) error {
    
    NSLog(@"Error getting oAuth authorization URL: %@", [error localizedDescription]);
}

- (void) successfullyFetchedAuthorizedToken {
    
    NSLog(@"Successfully fetched the authorized token.");
    // DO STUFF
    
}
- (void) failedToFetchAuthorizedToken: (NSError *) error {
    NSLog(@"Error getting authorized oAuth token: %@", [error localizedDescription]);
}


#pragma mark - FitbitResourcesDelegate

- (void) gotResponseToDevicesQuery: (NSArray *) _devices {
    self.devices = _devices;
    [self reloadTableIfNecessary];
}
- (void) devicesQueryFailedWithError: (NSError *) error {
    NSLog(@"devicesQueryFailedWithError: %@", error);
    
}

- (void) gotResponseToActivitiesQuery: (FBDailyActivity *) response {
    
    self.currentdailyActivity = response;
    [self reloadTableIfNecessary];
}
- (void) activitiesQueryFailedWithError: (NSError *) error {
    NSLog(@"activitiesQueryFailedWithError: %@", error);
    
}

- (void) gotResponseToMyUserInfoQuery: (FBUserInfo *) response {
    
    self.userInfo = response;
    [self reloadTableIfNecessary];
    
}
- (void) myUserInfoQueryFailedWithError: (NSError *) error {
    NSLog(@"myUserInfoQueryFailedWithError: %@", error);
    
}

- (void) gotResponseToBodyMeasurementsQuery: (FBBodyMeasurement *) response {
    
}
- (void) bodyMeasurementsQueryFailedWithError: (NSError *) error {
    
}

- (void) gotResponseToBodyWeightQuery: (NSArray *) response {
    
}
- (void) bodyWeightQueryFailedWithError: (NSError *) error {
    
}

- (void) gotResponseToBodyFatQuery: (NSArray *) response {
    
}
- (void) bodyFatQueryFailedWithError: (NSError *) error {
    
}

- (void) gotResponseToActivityStatsQuery: (FBActivityStats *) response {
    
}
- (void) activityStatsQueryFailedWithError: (NSError *) error {
    
}


#pragma mark - SSPullToRefreshView helper methods

- (void)refresh {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [self.pullToRefreshView startLoading];
    
    self.currentdailyActivity = nil;
    self.userInfo = nil;
    self.devices = nil;
    
    [self.fitbitResources fetchDevices];
    [self.fitbitResources fetchMyUserInfo];
    [self.fitbitResources fetchMyActivitiesForDate:appDelegate.dateToGetInfoFor];
    
    // [self.pullToRefreshView finishLoading];
}

- (void) refreshWithHUD {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading profile";
    hud.dimBackground = YES;
    hud.minShowTime = 1.5;
    hud.removeFromSuperViewOnHide = YES;
    
    [self refresh];
}

#pragma mark - SSPullToRefreshViewDelegate


/**
 Return `NO` if the pull to refresh view should no start loading.
 */
- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    
    return YES;
}

/**
 The pull to refresh view started loading. You should kick off whatever you need to load when this is called.
 */
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    
    [self refresh];
}

/**
 The pull to refresh view finished loading. This will get called when it receives `finishLoading`.
 */
- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view {
    
}

/**
 The date when data was last updated. This will get called when it finishes loading or if it receives `refreshLastUpdatedAt`.
 Some content views may display this date.
 */

- (NSDate *)pullToRefreshViewLastUpdatedAt:(SSPullToRefreshView *)view {
    
    return self.lastRefreshDate;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // CANCEL -> do nothing
    }
    
    else if(buttonIndex == 1) {
        // OK tapped, change goal.
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        NSString *alertTextFieldText = [alertTextField text];
        
        if([alertView.title isEqualToString:STEPS_STRING]) {
            self.currentdailyActivity.goalSteps = [NSNumber numberWithInteger:[alertTextFieldText integerValue]];
        }
        
        else if([alertView.title isEqualToString:FLOORS_STRING]) {
            self.currentdailyActivity.goalFloors = [NSNumber numberWithInteger:[alertTextFieldText integerValue]];            
        }
        
        else if([alertView.title isEqualToString:DISTANCE_STRING]) {
            self.currentdailyActivity.goalDistance = [NSNumber numberWithInteger:[alertTextFieldText integerValue]];            
        }
        
        else if([alertView.title isEqualToString:CALORIES_OUT_STRING]) {
            self.currentdailyActivity.goalCaloriesOut = [NSNumber numberWithInteger:[alertTextFieldText integerValue]];
        }
        
        else if([alertView.title isEqualToString:ACTIVE_SCORE_STRING]) {
            self.currentdailyActivity.goalActiveScore = [NSNumber numberWithInteger:[alertTextFieldText integerValue]];
        }
        
        else {
            return;
        }
        
    UITableView *tableView = (UITableView *) self.view;
    [tableView reloadData];
    
    }
    
}



@end
