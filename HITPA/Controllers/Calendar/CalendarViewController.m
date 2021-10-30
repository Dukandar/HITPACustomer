//
//  CalendarViewController.m
//  HITPA
//
//  Created by Selma D. Souza on 09/01/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import "CalendarViewController.h"
#import "Gradients.h"
//#import "KeyboardHelper.h"
#import "Configuration.h"
#import "Constants.h"
#import "Helper.h"
#import "Utility.h"
#import "FSCalendar.h"
#import "AddEventViewController.h"
#import "HITPAAppDelegate.h"
#import "CalendarTableViewCell.h"

NSInteger  const kSearchTag             = 30000;

@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) FSCalendar *calendar;
@property(nonatomic, strong) EKCalendar *ekCalendar;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) HITPAAppDelegate *appDelegate;
@property(nonatomic, strong) NSMutableArray *events;
@property(nonatomic, strong) NSMutableArray *allEvents;
@property(nonatomic, strong) NSMutableArray *filteredEvents;
@property(nonatomic, strong) UILabel *eventStatusLabel;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.selectedDate = [NSDate date];
    self.appDelegate = (HITPAAppDelegate *)[[UIApplication sharedApplication]delegate];
    [self performSelector:@selector(requestAccessToEvents) withObject:nil afterDelay:0.1];
    self.events = [[NSMutableArray alloc]init];
    self.filteredEvents = [[NSMutableArray alloc]init];
    self.allEvents = [[NSMutableArray alloc]init];
    self.navigationItem.title = NSLocalizedString(@"Calendar", @"");
    CAGradientLayer *backgroundGradient = [[Gradients shareGradients]background];
    backgroundGradient.frame = [self bounds];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
    [self barItems];
    [self createCalendarView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self reloadEvents];
}

- (void)barItems
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    UIImage *buttonImage = [UIImage imageNamed:@"icon_back_arrow.png"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    UIImage *eventCreateImage = [UIImage imageNamed:@"icon_navi_createcase"];
    
    UIButton *addEventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addEventBtn setBackgroundImage:eventCreateImage forState:UIControlStateNormal];
    addEventBtn.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addEventBtn];
    
    [addEventBtn addTarget:self action:@selector(addEventTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, 1.0)];
//    lineView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lineView];
    
}

- (void)createCalendarView {
    
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    
    xPos = 0.0;
    yPos = 90.0;
    width = frame.size.width;
    height = (frame.size.height - 64.0) * 0.42;
    UIView *calendarView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [calendarView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:calendarView];
    
    xPos = 0.0;
    yPos = 0.0;
    width = calendarView.frame.size.width;
    height = calendarView.frame.size.height;
    self.calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.calendar.dataSource = self;
    self.calendar.delegate =self;
    self.calendar.backgroundColor = [UIColor clearColor];
    [calendarView addSubview:self.calendar];
    
    xPos = 0.0;
    yPos = calendarView.frame.origin.y + calendarView.frame.size.height;
    width = frame.size.width;
    height = 51.0;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    searchView.tag = kSearchTag;
    [self.view addSubview:searchView];
    
    yPos = 0.0;
    height = 50.0;
    UISearchBar *searchName = [[UISearchBar alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    searchName.delegate = self;
    //searchName.searchBarStyle = UISearchBarStyleProminent;
//    UITextField *txfSearchField = [searchName valueForKey:@"_searchField"];
//    txfSearchField.backgroundColor= [UIColor colorWithRed:(207/255.0) green:(207/255.0) blue:(207/255.0) alpha:1.0f];
//    searchName.barTintColor = [UIColor clearColor];
//    searchName.backgroundImage = [UIImage new];
    searchName.placeholder = NSLocalizedString(@"Search by title", @"");
    [searchView addSubview:searchName];
    
    xPos = 0.0;
    height = 1.0;
    yPos = searchView.frame.size.height - height;
    width = frame.size.width;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [searchView addSubview:lineView];
    
    xPos = 0.0;
    yPos = searchView.frame.origin.y + searchView.frame.size.height;
    width = frame.size.width;
    height = frame.size.height - yPos;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    xPos = 10.0;
    width = frame.size.width - 2 * xPos;
    height = 40.0;
    yPos = (self.tableView.frame.size.height - height)/2.0;
    self.eventStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    self.eventStatusLabel.text = self.isMedReminder ? @"No Med Reminder" :@"No events";
    self.eventStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self.eventStatusLabel setHidden:(self.filteredEvents.count > 0) ? YES : NO];
    [self.tableView addSubview:self.eventStatusLabel];
    
    if (self.filteredEvents.count == 0) {
        [[self.view viewWithTag:kSearchTag]setHidden:YES];
    }
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen] bounds];
    
}

- (void)requestAccessToEvents
{
    [self.appDelegate.eventManger.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
        if (error == nil)
        {
            self.appDelegate.eventManger.eventAccessGranded = granted;
            self.ekCalendar = [self createCalendarWithTitle:@"HITPA"];
        }else
        {
            NSLog(@"%@",[error description]);
        }
    }];
}


- (EKCalendar *)createCalendarWithTitle:(NSString *)title
{
    NSArray *arrCalendars = [self.appDelegate.eventManger getLocalEventCalendars];
    for(int i = 0; i < arrCalendars.count; i++) {
        if ([[arrCalendars[i] title] isEqualToString:title]) {
            NSLog(@"arrCalendars[i]");
            self.appDelegate.eventManger.selectedCalendarIdentifier = [[arrCalendars objectAtIndex:i] calendarIdentifier];
            return arrCalendars[i];
        }
    }
    
    EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.appDelegate.eventManger.eventStore];
    [calendar setTitle:title];
    EKSource *localSource;
    for (int i = 0; i < [self.appDelegate.eventManger.eventStore.sources count]; i++) {
        EKSource *source = (EKSource *)[self.appDelegate.eventManger.eventStore.sources objectAtIndex:i];
        EKSourceType currentSourceType = source.sourceType;
        if (currentSourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"]) {
            localSource = source;
            calendar.source = source;
            break;
        }
        
    }
   
    if (localSource == nil)
    {
        for (EKSource *source in self.appDelegate.eventManger.eventStore.sources)
        {
            if (source.sourceType == EKSourceTypeLocal)
            {
                localSource = source;
                calendar.source = source;
                break;
            }
        }
    }
    

    
    NSError *error;
    [self.appDelegate.eventManger.eventStore saveCalendar:calendar commit:YES error:&error];
    if (error == nil)
    {
        [self.appDelegate.eventManger saveCustomCalendarIdentifier:calendar.calendarIdentifier];
        return calendar;
    }else
    {
        NSLog(@"%@",[error description]);
    }
//    return [[EKCalendar alloc]init];  //*** Crash Issue***//
    return calendar;
}

- (void)getEvents
{
//    NSArray *calendarArray;
    [self.events removeAllObjects];
    [self.filteredEvents removeAllObjects];
    NSDateFormatter *datefomat = [[NSDateFormatter alloc]init];
    [datefomat setDateFormat:@"MM/dd/yyyy"];
    NSString *date = [datefomat stringFromDate:self.selectedDate];
    [datefomat setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *startDate = [datefomat dateFromString:[NSString stringWithFormat:@"%@ %@",date,@"12:00 AM"]];
    NSDate *endDate = [datefomat dateFromString:[NSString stringWithFormat:@"%@ %@",date,@"11:59 PM"]];
    NSPredicate *predicate = [self.appDelegate.eventManger.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:[[NSArray alloc]initWithObjects:self.ekCalendar, nil]];
    self.events = [[self.appDelegate.eventManger.eventStore eventsMatchingPredicate:predicate]mutableCopy];
    [self eventFilter];
    //calendarArray = [self.events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];

}

//Filter the events
-(void)eventFilter{
    NSMutableArray *events = [[NSMutableArray alloc]init];
     for(int i = 0; i < self.events.count; i++) {
         if(self.isMedReminder && [((EKEvent *)self.events[i]).location isEqualToString: @"MedReminder"]){
             [events addObject:self.events[i]];
         }else if (!self.isMedReminder &&![((EKEvent *)self.events[i]).location isEqualToString: @"MedReminder"]){
             [events addObject:self.events[i]];
         }
     }
    [self.filteredEvents addObjectsFromArray:events];
}

- (void)getAllEvents:(NSDate *)selectedDate
{
    [self.allEvents removeAllObjects];
   // NSArray *calendarArray;
    NSDateFormatter *datefomat = [[NSDateFormatter alloc]init];
    [datefomat setDateFormat:@"MM/dd/yyyy"];
    NSString *date = [datefomat stringFromDate:selectedDate];
    NSString *startDateString = [date stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@/",[[date componentsSeparatedByString:@"/"]objectAtIndex:1]] withString:@"/01/"];
    NSString *endDateString = [date stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@/",[[date componentsSeparatedByString:@"/"]objectAtIndex:1]] withString:@"/31/"];
    [datefomat setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *startDate = [datefomat dateFromString:[NSString stringWithFormat:@"%@ %@",startDateString,@"00:00 AM"]];
    NSDate *endDate = [datefomat dateFromString:[NSString stringWithFormat:@"%@ %@",endDateString,@"00:00 PM"]];
    NSInteger day = 31;
    while (endDate == nil) {
        day = day - 1;
        endDateString = [date stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@/",[[date componentsSeparatedByString:@"/"]objectAtIndex:1]] withString:[NSString stringWithFormat:@"/%d/",day]];
        endDate = [datefomat dateFromString:[NSString stringWithFormat:@"%@ %@",endDateString,@"00:00 PM"]];
    }
    NSPredicate *predicate = [self.appDelegate.eventManger.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:[[NSArray alloc]initWithObjects:self.ekCalendar, nil]];
    self.allEvents = [[self.appDelegate.eventManger.eventStore eventsMatchingPredicate:predicate]mutableCopy];
    NSLog(@"%@",self.allEvents);
//    calendarArray = [self.events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
//    NSLog(@"%@",calendarArray);
    
}

- (void)reloadEvents {
    [self getAllEvents:self.selectedDate];
    [self.calendar reloadData];
    [self getEvents];
    [self.tableView reloadData];
    [self.eventStatusLabel setHidden:(self.filteredEvents.count > 0) ? YES : NO];
    if (self.filteredEvents.count == 0) {
        [[self.view viewWithTag:kSearchTag]setHidden:YES];
    }else {
        [[self.view viewWithTag:kSearchTag]setHidden:NO];
        UISearchBar *searchBar = [[[self.view viewWithTag:kSearchTag]subviews]objectAtIndex:0];
        [searchBar setText:@""];
    }
}

#pragma mark - Button delegate
- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Add Event delegate
- (IBAction)addEventTapped:(id)sender
{
    AddEventViewController *vctr = [[AddEventViewController alloc]initWithCalendar:self.ekCalendar eventDate:self.selectedDate event:nil];
    vctr.isMedReminder = self.isMedReminder;
    [self.navigationController pushViewController:vctr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Tableview delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.filteredEvents.count;
    
}

-(CalendarTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CalendarTableViewCell *cell;
    if (cell == nil)
    {
        
        cell = [[CalendarTableViewCell alloc]initWithIndexPath:indexPath eventDetail:self.filteredEvents[indexPath.row]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EKCalendar * calendar = [self createCalendarWithTitle:@"HITPA"];
    AddEventViewController *vctr = [[AddEventViewController alloc]initWithCalendar:calendar eventDate:nil event:self.filteredEvents[indexPath.row]];
    vctr.isMedReminder = self.isMedReminder;
    [self.navigationController pushViewController:vctr animated:YES];
}



#pragma mark - Calendar delegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    self.selectedDate = date;
    NSLog(@"calendar did select date \(self.formatter.string(from: date))");
    if (monthPosition == FSCalendarMonthPositionPrevious || monthPosition == FSCalendarMonthPositionNext) {
        [self.calendar setCurrentPage:date];
    }
    [self reloadEvents];
    
}


- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
    //[self getAllEvents:date];
    NSMutableArray *eventDays = [[NSMutableArray alloc]init];
    NSDateFormatter *datefomat = [[NSDateFormatter alloc]init];
    [datefomat setDateFormat:@"dd"];
    NSString *currentDate = [datefomat stringFromDate:date];
    for (EKEvent *obj in self.allEvents) {
        
        [eventDays addObject:[datefomat stringFromDate:obj.startDate]];
    }
    return ([eventDays containsObject:currentDate]) ? [UIImage imageNamed:@"icon_line.png"] : nil;
    
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    NSDate *currentDate = calendar.currentPage;
    NSLog(@"%@",calendar.currentPage);
    self.selectedDate = currentDate;
    [calendar selectDate:currentDate];
//    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
//    [dateformat setDateFormat:@"MM"];
//    NSString *currentMonth = [dateformat stringFromDate:[NSDate date]];
//    NSString *selectedMonth = [dateformat stringFromDate:currentDate];
//    [dateformat setDateFormat:@"yyyy"];
//    NSString *currentYear = [dateformat stringFromDate:[NSDate date]];
//    NSString *selectedYear = [dateformat stringFromDate:currentDate];
//    if ([currentYear isEqualToString:selectedYear] && [currentMonth isEqualToString:selectedMonth]) {
//    }else {
//
//    }
    [self reloadEvents];
    
}


#pragma mark - Search delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setToolBar:searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchEventsWithTitle:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self.filteredEvents removeAllObjects];
    [self.filteredEvents addObjectsFromArray:self.events];
    [self.tableView reloadData];
}

- (void)setToolBar:(UISearchBar *)searchbar
{
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapped:)],
                           nil];
    [numberToolbar sizeToFit];
    searchbar.inputAccessoryView = numberToolbar;
    
}

- (IBAction)cancelButtonTapped:(id)sender
{
    
    [self.view endEditing:YES];
    
}

- (void)searchEventsWithTitle:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@",searchText];
    [self.filteredEvents removeAllObjects];
    NSArray *resultArray = [self.events filteredArrayUsingPredicate:predicate];//filterUsingPredicate:predicate
    [self.filteredEvents addObjectsFromArray:resultArray];
    [self.tableView reloadData];
}


@end
