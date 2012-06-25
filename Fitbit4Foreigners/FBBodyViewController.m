//
//  FBBodyViewController.m
//  Fitbit4Foreigners
//
//  Created by Niclas Jern on 6/21/12.
//  Copyright (c) 2012 Mobio Oy. All rights reserved.
//

#import "FBBodyViewController.h"
#import "DateSelectionCell.h"
#import "TimeUtilities.h"
#import "AppDelegate.h"
#import "SSPullToRefresh.h"
#import "MBProgressHUD.h"
#import "FitbitResources.h"
#import "FBBodyMeasurement.h"
#import "FitbitBodyWeightCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UACellBackgroundView.h"

#define NUMBER_OF_SECTIONS 5
#define DATE_SELECTION_SECTION 0
#define WEIGHT_SECTION 1
#define HEART_RATE_SECTION 2
#define BLOOD_PRESSURE_SECTION 3
#define GLUCOSE_SECTION 4


@interface FBBodyViewController ()

@property (nonatomic, retain) FitbitResources *fitbitResources;
@property (nonatomic, retain) FBBodyMeasurement *bodyMeasurement;

@property (nonatomic, retain) UINib *dateCellLoader;
@property (nonatomic, retain) UINib *weightCellLoader;

@property (nonatomic, retain) NSDate *lastRefreshDate;
@property (nonatomic, retain) SSPullToRefreshView *pullToRefreshView;


@end

@implementation FBBodyViewController
@synthesize fitbitResources;
@synthesize bodyMeasurement;

@synthesize dateCellLoader;
@synthesize weightCellLoader;

@synthesize lastRefreshDate;
@synthesize pullToRefreshView;

- (void) dealloc {
    self.fitbitResources = nil;
    self.bodyMeasurement = nil;
    
    self.dateCellLoader = nil;
    self.weightCellLoader = nil;
    
    self.lastRefreshDate = nil;
    self.pullToRefreshView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

- (UINib *) dateCellLoader {
    if(self->dateCellLoader == nil) {
        self->dateCellLoader = [[UINib nibWithNibName:@"DateSelectionCell" bundle:[NSBundle mainBundle]] retain];
    }
    
    return self->dateCellLoader;
}

- (UINib *) weightCellLoader {
    if(self->weightCellLoader == nil) {
        self->weightCellLoader = [[UINib nibWithNibName:@"FitbitBodyWeightCell" bundle:[NSBundle mainBundle]] retain];
    }
    
    return self->weightCellLoader;
}
- (FitbitResources *) fitbitResources {
    

    if(self->fitbitResources == nil) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

        self->fitbitResources = [[FitbitResources alloc] initWithAuthorizationObject:appDelegate.fitbitAuthorization];
        self->fitbitResources.delegate = self;
    
    }
    
    return self->fitbitResources;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Body";
    
    // Hook up the pull to refresh view.
    UITableView *tableView = (UITableView *) self.view;
    self.pullToRefreshView = [[[SSPullToRefreshView alloc] initWithScrollView:tableView delegate:self] autorelease];
    
    
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
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fitbit_background2.png"]];
    [(UITableView *) self.view setSeparatorColor: [UIColor clearColor]];
    self.tableView.backgroundColor = [UIColor clearColor];
    

    [self refreshWithHUD];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    UITableView *tableView = (UITableView *) self.view;
    [tableView reloadData];
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
        case DATE_SELECTION_SECTION: {
            return 1;
        }
            break;            
        case WEIGHT_SECTION: {
            return 1;
        }
            break;
        case HEART_RATE_SECTION: {
            return 1;
        }
            break;
            
        case BLOOD_PRESSURE_SECTION: {
            return 1;
        }
            break;
            
        case GLUCOSE_SECTION: {
            return 1;
        }
            break;
            
        default: {
            return 0;
        }
            break;
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
        case WEIGHT_SECTION: {
            
            
            FitbitBodyWeightCell *fitbitBodyWeightCell = [tableView dequeueReusableCellWithIdentifier:@"FitbitBodyWeightCell"];
            
            if(fitbitBodyWeightCell == nil) {
                NSArray *topLevelItems = [self.weightCellLoader instantiateWithOwner:self options:nil];
                fitbitBodyWeightCell = [topLevelItems objectAtIndex:0];
            }
            
            fitbitBodyWeightCell.weightLabel.text = [NSString stringWithFormat:@"Weight: %@ kg", self.bodyMeasurement.weight];
            fitbitBodyWeightCell.fatPercentLabel.text = [NSString stringWithFormat:@"Fat: %@%%", self.bodyMeasurement.fatPercent];
            fitbitBodyWeightCell.BMILabel.text = [NSString stringWithFormat:@"BMI: %@", self.bodyMeasurement.BMI];            
            
            
            // Add rounded edges to the imageView
            CALayer * l = [fitbitBodyWeightCell.weightImageView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:5.0];
            
            // Make the cell look good
            fitbitBodyWeightCell.backgroundView = [UACellBackgroundView getBackgroundCellView];
            [(UACellBackgroundView *) fitbitBodyWeightCell.backgroundView setPosition:UACellBackgroundViewPositionSingle];
            
            
            
            NSLog(@"Weight: %@", self.bodyMeasurement.weight);
            NSLog(@"BMI: %@", self.bodyMeasurement.BMI);
            NSLog(@"Fat: %@", self.bodyMeasurement.fatPercent);

            return fitbitBodyWeightCell;
            
        }
            break;
        case HEART_RATE_SECTION: {
            
            
        }
            break;
            
        case BLOOD_PRESSURE_SECTION: {
            
            
        }
            break;
            
        case GLUCOSE_SECTION: {
            
            
        }
            break;
            
        default: {
            
        }
            break;
    }
    
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:@"Cell"]
                autorelease];        
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == WEIGHT_SECTION) {
        return 100;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}

#pragma mark - SSPullToRefreshView helper methods

- (void)refresh {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self.pullToRefreshView startLoading];
    
    [self.fitbitResources fetchBodyMeasurementsForDate:appDelegate.dateToGetInfoFor];
    
    [self.fitbitResources fetchMyUserInfo];
    [self.fitbitResources fetchMyActivitiesForDate:appDelegate.dateToGetInfoFor];
    
    // [self.pullToRefreshView finishLoading];
}

- (void) refreshWithHUD {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading body data...";
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




#pragma mark - FitbitResourcesDelegate helper methods

- (void) reloadTableIfNecessary {
    
    if(self.bodyMeasurement) {
        
        self.lastRefreshDate = [NSDate date];
        
        [(UITableView *) self.view reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.pullToRefreshView finishLoading];
    }
}



#pragma mark - FitbitResourcesDelegate

- (void) gotResponseToDevicesQuery: (NSArray *) _devices {
}
- (void) devicesQueryFailedWithError: (NSError *) error {
    NSLog(@"devicesQueryFailedWithError: %@", error);
    
}

- (void) gotResponseToActivitiesQuery: (FBDailyActivity *) response {
    
}
- (void) activitiesQueryFailedWithError: (NSError *) error {
    NSLog(@"activitiesQueryFailedWithError: %@", error);
    
}

- (void) gotResponseToMyUserInfoQuery: (FBUserInfo *) response {
    
    
}
- (void) myUserInfoQueryFailedWithError: (NSError *) error {
    NSLog(@"myUserInfoQueryFailedWithError: %@", error);
    
}

- (void) gotResponseToBodyMeasurementsQuery: (FBBodyMeasurement *) response {
    self.bodyMeasurement = response;

    
    [self reloadTableIfNecessary];
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


@end
