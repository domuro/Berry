//
//  GraphViewController.m
//  GitGraph
//
//  Created by Derek Omuro on 11/17/13.
//  Copyright (c) 2013 Derek Omuro. All rights reserved.
//

#import "TMGraphViewController.h"

@interface TMGraphViewController ()

//@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) TMInspectView *inspectView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TMDailyLog *selectedDailyLog;
@property (nonatomic, strong) TMDailyLog *todayDailyLog;

@end

@implementation TMGraphViewController

@synthesize selectedDailyLog, selectedCollectionViewCell;

const NSInteger numberOfTableViewSections = 12; //Look back 12 months
const NSInteger numberOfTableViewRows = 1; //One month displayed per month...
//const NSInteger numberOfCollectionViewCells = 31; //Days per month

- (NSMutableArray*) sampleData
{
    NSMutableArray *dailyLogs = [[NSMutableArray alloc]init];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    comp.month = comp.month - 12;
    comp.day = 1;
    NSDate *past = [self.calendar dateFromComponents:comp];
    comp = [[NSDateComponents alloc] init];
    comp.day = 1;
    NSDate *today = [NSDate date];
    while ([past compare:today] == NSOrderedAscending)
    {
        int lowest = 66;
        int highest = 230 - lowest;
        [dailyLogs addObject:[[TMDailyLog alloc] initWithDate:past records:@[[NSNumber numberWithInt:(arc4random() % highest + lowest)], [NSNumber numberWithInt:(arc4random() % highest + lowest)], [NSNumber numberWithInt:(arc4random() % highest + lowest)]] notes:@{}]];
        past = [self.calendar dateByAddingComponents:comp toDate:past options:0];
    }
    for(TMDailyLog *log in dailyLogs){
        [log writeToDisk];
    }

    return dailyLogs;
}

-(NSMutableArray*) readData
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    comp.month = comp.month - 12;
    comp.day = 1;
    NSDate *past = [TMDailyLog localDateWithGMTDate:[self.calendar dateFromComponents:comp]];
    comp = [[NSDateComponents alloc] init];
    comp.day = 1;
    NSDate *today = [TMDailyLog localDateWithGMTDate:[NSDate date]];
    while ([past compare:today] != NSOrderedDescending)
    {
        //NSLog(@"hi");
        past = [self.calendar dateByAddingComponents:comp toDate:past options:0];
        [arr addObject:[TMDailyLog dailyLogWithDate:past]];
    }

    return arr;
}

- (void)loadView
{
    [super loadView];
    //[self sampleData];
    
    //Fetch save data
    self.logs = [self processData:[self readData]];
    //NSLog(@"%@", [self readData]);
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"\n"];
    for (NSMutableArray *a in self.logs){
        for (TMDailyLog *d in a){
            if(d == nil)
                [str appendString:[NSString stringWithFormat:@"%d ",[[d grade] intValue]]];
        }
        [str appendString:@"\n"];
    }
    NSMutableArray *last = [self.logs objectAtIndex:[self.logs count]-1];
    self.selectedDailyLog = [last objectAtIndex:[last count]-1];
    self.todayDailyLog = [last objectAtIndex:[last count]-1];

    //NSLog(@"%@", str);

    //Colors for squares
    self.colors = [[NSMutableArray alloc]init];
    
//    
//    [self.colors addObject:[UIColor colorWithRed:246/255. green:221/255. blue:74/255. alpha:1]]; // 0
//    [self.colors addObject:[UIColor colorWithRed:246/255. green:221/255. blue:74/255. alpha:1]]; // 0
//    [self.colors addObject:[UIColor colorWithRed:188/255. green:192/255. blue:67/255. alpha:1]]; // 0
//    [self.colors addObject:[UIColor colorWithRed:129/255. green:163/255. blue:60/255. alpha:1]]; // 0
//    [self.colors addObject:[UIColor colorWithRed:71/255. green:133/255. blue:52/255. alpha:1]]; // 0
//    [self.colors addObject:[UIColor colorWithRed:12/255. green:104/255. blue:45/255. alpha:1]]; // 0

    //
    [self.colors addObject:[UIColor colorWithRed:205/255. green:91/255. blue:31/255. alpha:1]];
    [self.colors addObject:[UIColor colorWithRed:205/255. green:91/255. blue:31/255. alpha:1]];// 0
    //[self.colors addObject:[UIColor colorWithRed:205/255. green:91/255. blue:31/255. alpha:1]]; // 0
    [self.colors addObject:[UIColor colorWithRed:215/255. green:169/255. blue:47/255. alpha:1]]; // 1
    //[self.colors addObject:[UIColor colorWithRed:18/255. green:87/255. blue:15/255. alpha:1]];
    [self.colors addObject:[UIColor colorWithRed:171/255. green:217/255. blue:168/255. alpha:1]]; // 2
    //[self.colors addObject:[UIColor colorWithRed:144/255. green:214/255. blue:108/255. alpha:1]]; // 3
    [self.colors addObject:[UIColor colorWithRed:87/255. green:182/255. blue:81/255. alpha:1]]; // 4
    [self.colors addObject:[UIColor colorWithRed:53/255. green:144/255. blue:48/255. alpha:1]]; // 5
    //[self.colors addObject:[UIColor colorWithRed:188/255. green:225/255. blue:186/255. alpha:1]

    //Screen dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    //Navigation Bar
    [self.navigationItem setTitle:@"Berry"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendMail:)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(triggerInput:)]];
    
    //Inspect view
    self.inspectView = [[TMInspectView alloc] initWithFrame:CGRectMake(0, screenHeight-142-64, screenWidth, 142)];
    [self.inspectView setBackgroundColor:[UIColor darkGrayColor]];
    [self.inspectView updateWithLog:self.selectedDailyLog];
    [self.view addSubview:self.inspectView];
    [self.inspectView updateWithLog:self.selectedDailyLog];

    //UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-self.inspectView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + 64);
    [self.tableView setContentOffset:bottomOffset animated:NO];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//Process logs data
- (NSMutableArray*) processData:(NSMutableArray*)logs
{
    NSDateComponents *components;
    long month = -1;
    long day;
    NSMutableArray *processed = [[NSMutableArray alloc] init];
    NSMutableArray *monthLogs = [[NSMutableArray alloc] init];

    for(TMDailyLog *log in logs)
    {
        components = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSWeekdayCalendarUnit fromDate:[log date]];

        if(month != components.month) //New month
        {
            if([monthLogs count] != 0) //Add previous month's data
               [processed addObject:monthLogs];

            monthLogs = [[NSMutableArray alloc] init];
            month = components.month;
            day = components.day;
            components.day = 1;

            //offset
            for(int i = 0; i < components.weekday-1; i++)
            {
                [monthLogs addObject:[NSNull null]];
            }
        }
        [monthLogs addObject:log];
    }

    [processed addObject:monthLogs];
    return processed;
}

#pragma mark - Storyboard Segue
//InputViewController
- (void) triggerInput:(id)sender
{
    [self performSegueWithIdentifier: @"GraphToInputSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GraphToInputSegue"])
    {

        TMInputViewController *ivc = (TMInputViewController *)[[segue destinationViewController] topViewController];
        ivc.selectedLog = self.selectedDailyLog;
        ivc.sourceViewController = self;
    }
}
//Mail
- (void) sendMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        [self displayMailComposerSheet];
    }
}
- (void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    
	[picker setSubject:[@"Blood Sugar Levels - " stringByAppendingString:[dateFormatter stringFromDate:[NSDate date]]]];

	// Set up recipients
	NSArray *toRecipients = @[];
	//NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
	//NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];

	[picker setToRecipients:toRecipients];
	//[picker setCcRecipients:ccRecipients];
	//[picker setBccRecipients:bccRecipients];

	// Attach an image to the email
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GlucoseNovember2013" ofType:@"jpg"];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"image/jpg" fileName:@"GlucoseNovember2013"];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"GlucoseNovember2013" ofType:@"pdf"];
	NSData *myData2 = [NSData dataWithContentsOfFile:path2];
	[picker addAttachmentData:myData2 mimeType:@"application/pdf" fileName:@"GlucoseNovember2013"];

    /*
	// Fill out the email body text
	NSString *emailBody = @"It is raining in sunny California!";
	[picker setMessageBody:emailBody isHTML:NO];
	*/

	[self presentViewController:picker animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.logs count]; //12 months //[regions count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfTableViewRows; //1 Collection per view //self.colorArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // The header for the section is the region name -- get this from the region at the section index.
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    //BUG HERE! what if no entries in a month?
    NSDate *date;
    if ([[self.logs objectAtIndex:section] count] > 7 && ![[[self.logs objectAtIndex:section] objectAtIndex:7] isEqual:[NSNull null]]) {
        date = [[[self.logs objectAtIndex:section] objectAtIndex:7] date];
    } else {
        date = [NSDate date];
    }

    NSDateComponents *comp = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSString *month = [[df monthSymbols] objectAtIndex:(comp.month-1)];
    return [NSString stringWithFormat:@"%@ %ld", month, (long)comp.year]; //TODO //[region name];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    TMGraphCell *cell = (TMGraphCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[TMGraphCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(TMGraphCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.row];
}

#pragma mark - UITableViewDelegate Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long days = [[self.logs objectAtIndex:indexPath.section] count];
    return ceil(days / 7.0) * 45 + 5; //45 per square + 5 bottom padding.
}

#pragma mark - UICollectionViewDataSource Methods
-(NSInteger)collectionView:(TMGraphCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    UITableViewCell *tableViewCell = (UITableViewCell*) collectionView.superview.superview.superview;
    UITableView *tableView = (UITableView*) collectionView.superview.superview.superview.superview.superview;
    long tSection = [tableView indexPathForCell:tableViewCell].section;

    return [[self.logs objectAtIndex:tSection] count];
}

-(UICollectionViewCell *)collectionView:(TMGraphCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];

    UITableView *tableView = (UITableView *)collectionView.superview.superview.superview.superview.superview;
    UITableViewCell *tableViewCell = (UITableViewCell *)collectionView.superview.superview.superview;
    long section = [tableView indexPathForCell:tableViewCell].section;

    //TMDailyLog *currentLog = [[self.logs objectAtIndex:section] objectAtIndex:indexPath.item];
    int grade;
    if([[self.logs objectAtIndex:section] objectAtIndex:indexPath.item] != [NSNull null]){
        grade = [[[[self.logs objectAtIndex:section] objectAtIndex:indexPath.item] grade] intValue]; //Entry found
    }
    else
        grade = -2; //No entry found on this date

    if (grade == -2)
        cell.backgroundColor = [UIColor clearColor];
    else if (grade == -1)
        cell.backgroundColor = [UIColor lightGrayColor];
    else if (grade < [self.colors count])
        cell.backgroundColor = [self.colors objectAtIndex:grade];
    else
        NSLog(@"Help!!");

    UIView *bkv1 = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 20, 5)];
    UIView *bkv2 = [[UIView alloc] initWithFrame:CGRectMake(5, 10, 5, 20)];
    UIView *bkv3 = [[UIView alloc] initWithFrame:CGRectMake(30, 5, 5, 25)];
    UIView *bkv4 = [[UIView alloc] initWithFrame:CGRectMake(5, 30, 25, 5)];
    [bkv1 setBackgroundColor:[UIColor whiteColor]];
    [bkv2 setBackgroundColor:[UIColor whiteColor]];
    [bkv3 setBackgroundColor:[UIColor whiteColor]];
    [bkv4 setBackgroundColor:[UIColor whiteColor]];
    UIView *selectedCellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [selectedCellBackgroundView addSubview:bkv1];
    [selectedCellBackgroundView addSubview:bkv2];
    [selectedCellBackgroundView addSubview:bkv3];
    [selectedCellBackgroundView addSubview:bkv4];
    [cell setSelectedBackgroundView:selectedCellBackgroundView];

    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];

    if ([[[self.logs objectAtIndex:section] objectAtIndex:indexPath.item] isEqual:[self selectedDailyLog]]) {
        [cell setSelected:YES];
        [self setSelectedCollectionViewCell:cell];
    }

    return cell;
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    UITableView *tableView = (UITableView *)sender.view.superview.superview.superview.superview.superview.superview;
    UITableViewCell *tableViewCell = (UITableViewCell *)sender.view.superview.superview.superview.superview;
    UICollectionView *collectionView = (UICollectionView *)sender.view.superview;
    UICollectionViewCell *collectionViewCell = (UICollectionViewCell *)sender.view;

    long month = [tableView indexPathForCell:tableViewCell].section;
    long day = [collectionView indexPathForCell:collectionViewCell].item;
    //NSLog(@"Month: %ld; Day: %ld", month, day);
    if([[self.logs objectAtIndex:month] objectAtIndex:day] != [NSNull null]) {
        self.selectedDailyLog = [[self.logs objectAtIndex:month] objectAtIndex:day];
        [selectedCollectionViewCell setSelected:NO];
        [collectionViewCell setSelected:YES];
        selectedCollectionViewCell = collectionViewCell;
        [self.inspectView updateWithLog:self.selectedDailyLog];
        
        if(!([[self.todayDailyLog date] isEqual:[self.selectedDailyLog date]]))
        {
            self.navigationItem.rightBarButtonItem = nil;
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(triggerInput:)]];
        }
        else{
            self.navigationItem.rightBarButtonItem = nil;
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(triggerInput:)]];
        }
    }
}

-(void)refreshView{
    //check last 7 good
    //check last 7 bad
    int achievement = -1;
    if(([[self.selectedDailyLog date] isEqualToDate:[self.todayDailyLog date]]))
        achievement = [self evaluateLastSevenDays];
    if(achievement == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Congratulations!" message: @"You have been in control for seven days!" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];
    }
    else if(achievement == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Congratulations!" message: @"You have consistently logged for seven days!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    }
    [self.tableView reloadData];
    [self.inspectView updateWithLog:self.selectedDailyLog];
}

//only looks at current month...
-(int)evaluateLastSevenDays{
    int perfect = 1;
    int count = 7;
    for(long i = [self.logs count]-1; i >= 0; i--){
        for(long j = [[self.logs objectAtIndex:i] count]-1; j >= 0; j--){
            TMDailyLog *log = [[self.logs objectAtIndex:i] objectAtIndex:j];
            if([[self.logs objectAtIndex:i] objectAtIndex:j] == [NSNull null])
                break;
            if([[log grade] intValue] == -1)
                return -1;
            if([[log grade] intValue] <= 2)
                perfect = 2;
            count--;
            if(count == 0)
                break;
        }
        if(count == 0)
            break;
    }
    
    return perfect;
}

@end
