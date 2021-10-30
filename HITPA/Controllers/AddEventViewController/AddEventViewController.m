//
//  AddEventViewController.m
//  HITPA
//
//  Created by Selma D. Souza on 09/01/18.
//  Copyright © 2018 Bathi Babu. All rights reserved.
//

#import "AddEventViewController.h"
#import "Gradients.h"
//#import "KeyboardHelper.h"
#import "Configuration.h"
#import "Constants.h"
#import "Helper.h"
#import "Utility.h"
#import "NIDropDown.h"
#import "HITPAAppDelegate.h"

NSInteger  const kEventDatePickerViewTag         = 10000;
NSInteger  const kEventDatePickerTag             = 20000;

@interface AddEventViewController () <NIDropDownDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *dateview;
@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UITextField *eventNote;
@property (weak, nonatomic) IBOutlet UITextField *eventLocation;
@property (weak, nonatomic) IBOutlet UITextField *notificationTime;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (strong, nonatomic)       UIView              * dropDownViews;
@property (nonatomic, strong)       NIDropDown          * nIDropDown;
@property (strong, nonatomic)       NSMutableDictionary * eventDetails;
@property (nonatomic, strong) HITPAAppDelegate *appDelegate;
@property (nonatomic, strong) NSDate *eventStartDate;
@property (nonatomic, strong) EKEvent *event;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *eventNoteView;
@property (weak, nonatomic) IBOutlet UIView *eventLocationView;

@property (weak, nonatomic) IBOutlet UILabel *eventDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLbl;

@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation AddEventViewController

- (instancetype)initWithCalendar:(EKCalendar *)calendar eventDate:(NSDate *)eventDate event:(EKEvent *)event
{
    self = [super init];
    {
        self.calender = calendar;
        self.event = event;
        self.eventStartDate = eventDate;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.appDelegate = (HITPAAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.navigationItem.title = NSLocalizedString(((self.isMedReminder) ? @"Add Med Reminder" : @"Add Event"), @"");
    self.eventTitle.placeholder = ((self.isMedReminder) ? @"Med Name" : @"Event Title");
    self.eventDateLbl.text = self.isMedReminder ? @"Medicine Date" : @"Event Date";
    self.eventTimeLbl.text = self.isMedReminder ? @"Medicine Time" : @"Event Time";
    if(self.isMedReminder){
        [self.eventNoteView setHidden:YES];
        [self.eventLocationView setHidden:YES];
    }
    CAGradientLayer *backgroundGradient = [[Gradients shareGradients]background];
    backgroundGradient.frame = [self bounds];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
    [self barItems];
    self.eventDetails = [[NSMutableDictionary alloc]init];
    if (self.eventStartDate != nil) {
        [self.eventDetails setValue:@"5 mins before" forKey:@"notificationTime"];
        [self.eventDetails setValue:[self convertDateFormatWithDate:self.eventStartDate] forKey:@"eventDate"];
        [self.eventDetails setValue:[self convertTimeFormatWithTime:self.eventStartDate] forKey:@"eventTime"];
        
    }else {
        NSDate *eventStartDate = self.event.startDate;
        NSDate *alarmDate = [[self.event.alarms objectAtIndex:0]absoluteDate];
        NSTimeInterval differenceTime = [eventStartDate timeIntervalSinceDate:alarmDate] / 60;
        NSInteger notificationTime = differenceTime;
        if (differenceTime == 60) {
            [self.eventDetails setValue:@"1 hour before" forKey:@"notificationTime"];
        }else if (differenceTime == 1440) {
            [self.eventDetails setValue:@"1 day before" forKey:@"notificationTime"];
        }else {
            [self.eventDetails setValue:[NSString stringWithFormat:@"%d mins before",notificationTime] forKey:@"notificationTime"];
        }
        [self.eventDetails setValue:[self convertDateFormatWithDate:self.event.startDate] forKey:@"eventDate"];
        [self.eventDetails setValue:[self convertTimeFormatWithTime:self.event.startDate] forKey:@"eventTime"];
        [self.eventDetails setValue:self.event.title forKey:@"eventTitle"];
        [self.eventDetails setValue:self.event.notes forKey:@"eventNote"];
        [self.eventDetails setValue:self.event.location forKey:@"eventLocation"];
        self.eventNote.text = [self.eventDetails valueForKey:@"eventNote"];
        self.eventLocation.text = [self.eventDetails valueForKey:@"eventLocation"];
        //[self.eventDetails setValue:@"5 mins before" forKey:@"notificationTime"];
        self.eventTitle.text = [self.eventDetails valueForKey:@"eventTitle"];
        self.eventNote.text = [self.eventDetails valueForKey:@"eventNote"];
        self.eventLocation.text = [self.eventDetails valueForKey:@"eventLocation"];
        self.notificationTime.text = [self.eventDetails valueForKey:@"notificationTime"];
        [self enableDisableView:NO];
    }
    self.eventDate.text = [self.eventDetails valueForKey:@"eventDate"];
    self.eventTime.text = [self.eventDetails valueForKey:@"eventTime"];
    self.eventNote.delegate = self;
    self.eventLocation.delegate = self;
    self.eventTitle.delegate = self;

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
    
    UIImage *saveImage = (self.eventStartDate != nil) ? [UIImage imageNamed:@"ic_done_white.png"] : [UIImage imageNamed:@"ic_mode_edit_white.png"];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setBackgroundImage:saveImage forState:UIControlStateNormal];
    self.saveBtn.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    self.saveBtn.tag = (self.eventStartDate != nil) ? 0 : 1;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    
    [self.saveBtn addTarget:self action:@selector(saveBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, 1.0)];
//    lineView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lineView];
    
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen] bounds];
    
}

- (void)enableDisableView:(BOOL)isEnable {
    if (isEnable) {
        [self.eventTitle setEnabled:YES];
        [self.eventNote setEnabled:YES];
        [self.eventLocation setEnabled:YES];
        [self.notificationView setUserInteractionEnabled:YES];
        [self.dateview setUserInteractionEnabled:YES];
        [self.timeView setUserInteractionEnabled:YES];
    }else {
        [self.eventTitle setEnabled:NO];
        [self.eventNote setEnabled:NO];
        [self.eventLocation setEnabled:NO];
        [self.notificationView setUserInteractionEnabled:NO];
        [self.dateview setUserInteractionEnabled:NO];
        [self.timeView setUserInteractionEnabled:NO];
    }
}

#pragma mark - Button delegate
- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteButtonTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    alertView([[Configuration shareConfiguration] appName], @"Do you want to delete the event?", self, @"Yes", @"No", 1);
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        if (buttonIndex == 0)
        {
            
            NSError *error;
            if (![self.appDelegate.eventManger.eventStore removeEvent:self.event span:EKSpanFutureEvents error:&error])
            {
                NSLog(@"%@",[error description]);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        else if (buttonIndex == 1)
        {
            
        }
    }
    
}



#pragma mark - Save delegate
- (IBAction)saveBtnTapped:(UIButton *)sender
{
    if (sender.tag == 0 || sender.tag == 2) {
        [self.view endEditing:YES];
        NSArray *error = nil;
        if([[Helper shareHelper] validateCalendarEventWithError:&error parmas:self.eventDetails]) {
            
            EKEvent *event = (sender.tag == 2) ? self.event : [EKEvent eventWithEventStore:self.appDelegate.eventManger.eventStore];
            [event setTitle:[self.eventDetails valueForKey:@"eventTitle"]];
            event.calendar = self.calender;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"dd MMM yyyy hh:mm a"];
            event.startDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",[self.eventDetails valueForKey:@"eventDate"],[self.eventDetails valueForKey:@"eventTime"]]];
            event.endDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",[self.eventDetails valueForKey:@"eventDate"],[self.eventDetails valueForKey:@"eventTime"]]];
            event.notes = [self.eventDetails valueForKey:@"eventNote"];
            event.location = (self.isMedReminder) ? @"MedReminder" : [self.eventDetails valueForKey:@"eventLocation"];
            NSError *error;
            
            CGFloat notificationTime = [[[[self.eventDetails valueForKey: @"notificationTime"]componentsSeparatedByString:@" "]objectAtIndex:0]floatValue];
            if (notificationTime == 1) {
                if ([[[[self.eventDetails valueForKey: @"notificationTime"]componentsSeparatedByString:@" "]objectAtIndex:1]isEqualToString:@"hour"]) {
                    notificationTime = 60;
                }else {
                    notificationTime = 24 * 60;
                }
            }
            
            NSDate *alarmDate = [event.startDate dateByAddingTimeInterval:notificationTime * -60];
            EKAlarm *alarm = (sender.tag == 2) ? [[self.event alarms]objectAtIndex:0] : [[EKAlarm alloc]init];
            [alarm setAbsoluteDate:alarmDate];
            [event addAlarm:alarm];
            
            
            if ([self.appDelegate.eventManger.eventStore saveEvent:event span:EKSpanFutureEvents error:&error])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                NSLog(@"%@",[error description]);
            }
            
        }else {
            NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
            alertView([[Configuration shareConfiguration] appName], errorMessage, self, @"Ok", nil, 0);
            return;
        }
    }else {
        [self enableDisableView:YES];
        [self.deleteButton setHidden:NO];
        [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"ic_done_white.png"] forState:UIControlStateNormal];
        self.saveBtn.tag = 2;
        

    }
}


- (IBAction)eventDateTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self createDatePickerView:sender];
}

- (void)createDatePickerView:(UITapGestureRecognizer *)sender
{
    
    CGRect frame = [self bounds];
    
    //view
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    UIView * datePickerView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos,width, height)];
    datePickerView.tag = kEventDatePickerViewTag;
    [datePickerView setBackgroundColor:[UIColor colorWithRed:(6.0/255.0) green:(6.0/255.0) blue:(6.0/255.0) alpha:0.4f]];
    [self.view addSubview:datePickerView];
    
    //set
    xPos    = datePickerView.frame.origin.x;
    yPos    = frame.size.height -  (datePickerView.frame.size.height * 0.3 + 30.0);
    width   = round(datePickerView.frame.size.width / 2);
    height  = 30.0;
    UIButton *set = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    set.tag = sender.view.tag;
    [set setTitle:NSLocalizedString(@"Set", nil) forState:UIControlStateNormal];
    set.backgroundColor = [UIColor colorWithRed:(46.0/255.0) green:(204.0/255.0) blue:(113.0/255.0) alpha:1.0f];
    [set addTarget:self action:@selector(dateSelectTapped:) forControlEvents:UIControlEventTouchUpInside];
    [datePickerView addSubview:set];
    
    //cancel
    xPos = set.frame.size.width;
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [cancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor colorWithRed:(231.0/255.0) green:(76.0/255.0) blue:(60.0/255.0) alpha:1.0f];
    [cancel addTarget:self action:@selector(dateCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    [datePickerView addSubview:cancel];
    
    //dataPicker
    xPos = 0.0;
    yPos = cancel.frame.origin.y + cancel.frame.size.height;
    width = datePickerView.frame.size.width;
    height = datePickerView.frame.size.height * 0.3;
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(xPos, yPos,width, height)];
    datePicker.tag = kEventDatePickerTag;
    datePicker.backgroundColor = [UIColor grayColor];
    datePicker.datePickerMode = (sender.view.tag == 0) ? UIDatePickerModeDate: UIDatePickerModeTime;
    datePicker.date = [NSDate date];
    
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setDay:1];
    [components setMonth:1];
    [components setYear:2014];
    NSDate *minDate = [calendar dateFromComponents:components];
    
    [datePicker setMinimumDate:minDate];
    
    //    [datePicker setMaximumDate:];
    
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [datePickerView addSubview:datePicker];
}
-(void)dateSelectTapped:(UIButton *)sender
{
    if(sender.tag == 0) {
        NSString *date = [self convertDateFormatWithDate:[(UIDatePicker *)[self.view viewWithTag:kEventDatePickerTag] date]];
        self.eventDate.text = date;
        [self.eventDetails setValue:date forKey:@"eventDate"];
    }else {
        NSString *time = [self convertTimeFormatWithTime:[(UIDatePicker *)[self.view viewWithTag:kEventDatePickerTag] date]];
        self.eventTime.text = time;
        [self.eventDetails setValue:time forKey:@"eventTime"];
    }
    [[self.view viewWithTag:kEventDatePickerViewTag] removeFromSuperview];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    
}

- (NSString *)convertDateFormatWithDate:(NSDate *)selectDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    return [dateFormatter stringFromDate:selectDate];
}

- (NSString *)convertTimeFormatWithTime:(NSDate *)selectDate
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    return [dateFormatter stringFromDate:selectDate];
}



- (IBAction)dateCancelTapped:(id)sender
{
    
    [[self.view viewWithTag:kEventDatePickerViewTag] removeFromSuperview];
    
}

- (IBAction)eventTimeTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self createDatePickerView:sender];
}

- (IBAction)notificationTimeTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    CGRect frame = [self bounds];
    if (self.nIDropDown == nil)
    {
        CGRect buttonFrame = [sender.view convertRect:sender.view.frame toView:self.view];
        self.dropDownViews = [[UIView alloc]initWithFrame:CGRectMake(-8.0,buttonFrame.origin.y - 64.0,frame.size.width, 200.0)];
        //[self.dropDownViews setBackgroundColor:[UIColor greenColor]];
        self.dropDownViews.tag = 40000;
        UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.dropDownViews.frame.size.width, self.dropDownViews.frame.size.height)];
        CGRect btnFrame=locationBtn.frame;
        btnFrame.origin.y=0.0;
        btnFrame.origin.x = 0.0;
        btnFrame.size.height=0.0;
        locationBtn.frame=btnFrame;
        locationBtn.backgroundColor=[UIColor clearColor];
        
        CGFloat f = ([UIScreen mainScreen].bounds.size.height > 480)?186.0:121.0;
        self.nIDropDown = [[NIDropDown alloc]showDropDown:locationBtn height:&f arr:[NSArray arrayWithObjects:@"5 mins before",@"30 mins before",@"1 hour before",@"1 day before", nil] imgArr:nil direction:@"down" isIndex:80000];
        self.nIDropDown.delegate = self;
        [self.dropDownViews addSubview:self.nIDropDown];
        [self.view addSubview:self.dropDownViews];
        
    }else
    {
        [self.dropDownViews removeFromSuperview];
        self.nIDropDown = nil;
        
    }
}

- (void)notificationTime:(NSString *)notificationTime {
    [self.dropDownViews removeFromSuperview];
    self.nIDropDown = nil;
    self.notificationTime.text = notificationTime;
    [self.eventDetails setValue:notificationTime forKey:@"notificationTime"];

}


#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == 0) {
        [self.eventDetails setValue:textField.text forKey:@"eventTitle"];
    }else if (textField.tag == 1) {
        [self.eventDetails setValue:textField.text forKey:@"eventNote"];
    }else if (textField.tag == 2) {
        [self.eventDetails setValue:textField.text forKey:@"eventLocation"];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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

@end
