//
//  GrievanceTrackViewController.m
//  HITPA
//
//  Created by Bhaskar C M on 12/23/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "GrievanceTrackViewController.h"
#import "Configuration.h"
#import "GrievanceTrackTableViewCell.h"
#import "Constants.h"
#import "Utility.h"
#import "HITPAAPI.h"
#import "UserManager.h"

@interface GrievanceTrackViewController ()<griveanceTrackTableViewCell, UITextViewDelegate>
@property (nonatomic,strong)     NSMutableArray     *  expandCollapse;
@property(nonatomic, readwrite)  CGFloat               shiftForKeyboard;
@property (nonatomic, strong)    NSMutableArray     *  trackDetails;
@property (nonatomic, readwrite) NSInteger             trackNumber;
@property (nonatomic, strong)    Greveance          *  details;
@property (nonatomic, strong)    NSString           *  remarksText;
@end

@implementation GrievanceTrackViewController


#pragma mark -

- (instancetype)initWithResponse:(Greveance *)response delegate:(id<GrievanceTrack>)delegate
{
    self = [super init];
    if (self)
    {
        self.details = response;
        self.delegate = delegate;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Complaint Track Detail", @"");
    self.trackDetails = [[NSMutableArray alloc]init];
    self.expandCollapse = [[NSMutableArray alloc]init];
    if(![self.details.serviceRequestStatus isEqualToString:@"Closed"]) {
        [self footerView];
    }
    [self headerView];
    [self getTrackDetail];
    [self reloadTableView];
    // Do any additional setup after loading the view.
}


- (void)getTrackDetail
{
    
    for (int i = 0; i < [self.details.grievanceHistory count]; i++) {
        //Date and Time
        NSString *dateStr = [[self.details.grievanceHistory objectAtIndex:i]valueForKey:@"ModifiedDateTIme"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
        NSDate *grievanceReqDate = [dateFormat dateFromString:dateStr];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        NSString *grievanceReqDateString = [dateFormat stringFromDate:grievanceReqDate];
        
        
//        NSString *raiseDateAndTime = [NSString stringWithFormat:@"%@",[dateFormat dateFromString:dateStr]];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[dateFormat dateFromString:dateStr]];
//        NSInteger hour = [components hour];
//        NSInteger minute = [components minute];
//        NSArray *dateArray = [raiseDateAndTime componentsSeparatedByString:@" "];
//        NSString *raiseDate = [NSString stringWithFormat:@"%@-%@-%@",[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2],[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1],[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0]];
//        NSString *raiseTime = [NSString stringWithFormat:@"%ld:%ld",hour,minute];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"hh:mm:ss a";
        NSString *raiseTime = [timeFormatter stringFromDate:grievanceReqDate];
        
        NSMutableDictionary *transactionDetails = [[NSMutableDictionary alloc]init];
        [transactionDetails setValue:[NSString stringWithFormat:@"@ Complaint raised @ %@ %@",grievanceReqDateString,raiseTime] forKey:@"header"];
        [transactionDetails setValue:([[[self.details.grievanceHistory objectAtIndex:i] valueForKey:@"Remarks"] isKindOfClass:[NSNull class]])?@"NA":[[self.details.grievanceHistory objectAtIndex:i] valueForKey:@"Remarks"] forKey:@"complaint"];
        [self.trackDetails addObject:transactionDetails];
        [self.expandCollapse addObject:[NSNumber numberWithBool:NO]];
        
    }
    
    
}

-(void)viewDidLayoutSubviews
{
    
    CGRect frame  = [self bounds];
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 64.0);
    [self.view layoutIfNeeded];
    
    
}

- (void)headerView
{
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    
    xPos = 0.0;
    yPos = 0.0;
    width = frame.size.width;
    height = 155.0;
    UIView *fullView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    fullView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = fullView;
    
    xPos = 2.0;
    yPos = 0.0;
    width = frame.size.width/2 - 20.0;
    height = fullView.frame.size.height/4;
    UILabel *raisedTime = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    raisedTime.backgroundColor = [UIColor whiteColor];
    [raisedTime setTextAlignment:NSTextAlignmentLeft];
    raisedTime.text = NSLocalizedString(@"Complaint raised at :", @"");
    //    CGSize textSize = [raisedTime.text sizeWithAttributes:@{NSFontAttributeName:[raisedTime font]}];
    // raisedTime.frame = CGRectMake(xPos, yPos, textSize.width, height);
    raisedTime.textColor = [UIColor darkGrayColor];
    raisedTime.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration] hitpaBoldFontWithSize:13.0];
    [fullView addSubview:raisedTime];
    
    yPos = raisedTime.frame.size.height - 5.0;
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    number.backgroundColor = [UIColor clearColor];
    [number setTextAlignment:NSTextAlignmentLeft];
    number.text = NSLocalizedString(@"Complaint number :", @"");
    //    CGSize numberSize = [number.text sizeWithAttributes:@{NSFontAttributeName:[number font]}];
    //    number.frame = CGRectMake(xPos, yPos, numberSize.width, height);
    number.textColor = [UIColor darkGrayColor];
    number.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration] hitpaBoldFontWithSize:13.0];
    [fullView addSubview:number];
    
    yPos = (raisedTime.frame.size.height * 2) - 10.0;
    //width = fullView.frame.size.width/2;
    UILabel *raisedFor = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    raisedFor.backgroundColor = [UIColor clearColor];
    [raisedFor setTextAlignment:NSTextAlignmentLeft];
    raisedFor.text = NSLocalizedString(@"Complaint Type :", @"");
    //    CGSize forSize = [raisedFor.text sizeWithAttributes:@{NSFontAttributeName:[raisedFor font]}];
    //    raisedFor.frame = CGRectMake(xPos, yPos, forSize.width, height);
    raisedFor.textColor = [UIColor darkGrayColor];
    raisedFor.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration] hitpaBoldFontWithSize:13.0];
    [fullView addSubview:raisedFor];
    
    
    yPos = (raisedTime.frame.size.height * 3) - 15.0;
    UILabel *remarks = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    remarks.backgroundColor = [UIColor clearColor];
    [remarks setTextAlignment:NSTextAlignmentLeft];
    remarks.text = NSLocalizedString(@"Complaint Sub-Type :", @"");
    //    CGSize remarksSize = [remarks.text sizeWithAttributes:@{NSFontAttributeName:[remarks font]}];
    //    remarks.frame = CGRectMake(xPos, yPos, remarksSize.width, height);
    remarks.textColor = [UIColor darkGrayColor];
    remarks.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration] hitpaBoldFontWithSize:13.0];
    [fullView addSubview:remarks];
    
    xPos = 5.0;
    yPos = fullView.frame.size.height - 2.0;
    width = frame.size.width;
    height = 2.0;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    line.backgroundColor = [UIColor grayColor];
    [fullView addSubview:line];
    
    //Date and Time
    NSString *dateStr = self.details.grievanceReqDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
    NSDate *grievanceReqDate = [dateFormat dateFromString:dateStr];

    
//    NSString *raiseDateAndTime = [NSString stringWithFormat:@"%@",[dateFormat dateFromString:dateStr]];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[dateFormat dateFromString:dateStr]];
//    NSInteger hour = [components hour];
//    NSInteger minute = [components minute];
//    NSArray *dateArray = [raiseDateAndTime componentsSeparatedByString:@" "];
//    NSString *raiseDate = [NSString stringWithFormat:@"%@-%@-%@",[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2],[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1],[[[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0]];
//    NSString *raiseTime = [NSString stringWithFormat:@"%ld:%ld",hour,minute];
//    
//    
//    timeFormatter.dateFormat = @"HH:mm";
//    NSDate *timeDate = [timeFormatter dateFromString:raiseTime];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"hh:mm:ss a";
    NSString *timeString = [timeFormatter stringFromDate:grievanceReqDate];

    
    NSString *strDate = self.details.grievanceReqDate;
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *rDate = [dateFormat dateFromString:strDate];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:rDate];
    
    xPos = frame.size.width > 320 ? raisedTime.frame.size.width + raisedTime.frame.origin.x + 2.0 : raisedTime.frame.size.width + 2.0;
    yPos = 0.0;
    width = 200.0;
    height = fullView.frame.size.height/4;
    UILabel *raisedTimeDetails = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    raisedTimeDetails.backgroundColor = [UIColor clearColor];
    raisedTimeDetails.text = [NSString stringWithFormat:@"%@ %@",dateString,timeString];
    //raisedTimeDetails.text = NSLocalizedString(@"6:05 PM on 20-Nov-2015", @"");
    raisedTimeDetails.textColor = [UIColor blackColor];
    raisedTimeDetails.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration] hitpaBoldFontWithSize:13.0];
    [raisedTimeDetails setNumberOfLines:2];
    [fullView addSubview:raisedTimeDetails];
    
    xPos = frame.size.width > 320 ? number.frame.size.width + number.frame.origin.x + 4.0 : number.frame.size.width + 2.0;
    yPos = raisedTime.frame.size.height - 5.0;
    UILabel *numberDetails = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    numberDetails.backgroundColor = [UIColor clearColor];
    NSString *str = self.details.serviceRequestId;
    numberDetails.text = NSLocalizedString(str, @"");
    numberDetails.textColor = [UIColor blackColor];
    numberDetails.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration] hitpaBoldFontWithSize:13.0];
    [fullView addSubview:numberDetails];
    
    xPos = frame.size.width > 320 ? raisedFor.frame.size.width + raisedFor.frame.origin.x + 2.0 : raisedFor.frame.size.width + 2.0;
    yPos = (raisedTime.frame.size.height * 2) - 10.0;
    UILabel *raisedForDetails = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    raisedForDetails.backgroundColor = [UIColor clearColor];
    raisedForDetails.text = NSLocalizedString(self.details.serviceRequestType, @"");
    raisedForDetails.textColor = [UIColor blackColor];
    raisedForDetails.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration] hitpaBoldFontWithSize:13.0];
    [raisedForDetails setNumberOfLines:2];
    //[raisedForDetails sizeToFit];
    [fullView addSubview:raisedForDetails];
    
    xPos = frame.size.width > 320 ? remarks.frame.size.width + remarks.frame.origin.x + 4.0 : remarks.frame.size.width + 2.0;
    yPos = (raisedTime.frame.size.height * 3) - 15.0;
    UILabel *remarksDetails = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    remarksDetails.backgroundColor = [UIColor clearColor];
    remarksDetails.text = NSLocalizedString(self.details.serviceRequestSubType, @"");
    remarksDetails.textColor = [UIColor blackColor];
    remarksDetails.numberOfLines = 0;
    remarksDetails.font = frame.size.width > 320 ? [[Configuration shareConfiguration] hitpaBoldFontWithSize:16.0] : [[Configuration shareConfiguration] hitpaBoldFontWithSize:13.0];
    [fullView addSubview:remarksDetails];
    
}

- (void)footerView
{
    CGRect frame = [self bounds];
    CGFloat xPos, yPos, width, height;
    
    xPos = 0.0;
    yPos = 0.0;
    width = frame.size.width;
    height = 220.0;
    UIView *fullView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    fullView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = fullView;
    
    xPos = 5.0;
    width = frame.size.width - 10.0;
    height = 90.0;
    yPos = 50.0;
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    textView.backgroundColor = [UIColor clearColor];
    textView.layer.cornerRadius = 5.0;
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    textView.layer.borderWidth = 2.0;
    textView.layer.masksToBounds = YES;
    [fullView addSubview:textView];
    
    xPos = 8.0;
    width = frame.size.width - 16.0;
    height = 84.0;
    yPos = textView.frame.origin.y + 3.0;
    UITextView *updateDetails = [[UITextView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    updateDetails.textColor = [UIColor blackColor];
    updateDetails.text = @"Remarks";
    updateDetails.textColor = [UIColor grayColor];
    updateDetails.delegate = self;
    updateDetails.tag = 23456;
    updateDetails.font = [[Configuration shareConfiguration] hitpaFontWithSize:16.0];
    [fullView addSubview:updateDetails];
    
    xPos = 13.0;
    height = 45.0;
    yPos = textView.frame.origin.y - 45.0;
    width = 150.0;
    UILabel *updateRemark = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    updateRemark.backgroundColor = [UIColor clearColor];
    updateRemark.text = NSLocalizedString(@"Update Remark", @"");
    updateRemark.textColor = [UIColor grayColor];
    updateRemark.font = [[Configuration shareConfiguration] hitpaBoldFontWithSize:18.0];
    [fullView addSubview:updateRemark];
    
    xPos = 15.0;
    yPos = textView.frame.origin.y + textView.frame.size.height + 10.0;
    width = 130.0;
    height = 45.0;
    UIButton *update = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [update setTitle:@"Update" forState:UIControlStateNormal];
    update.layer.cornerRadius = 8.0;
    update.layer.masksToBounds = YES;
    update.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:22.0];
    [update setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [update addTarget:self action:@selector(updateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    update.layer.masksToBounds = NO;
    update.layer.shadowColor = [UIColor blackColor].CGColor;
    update.layer.shadowOpacity = 0.8;
    update.layer.shadowRadius = 5;
    update.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    [fullView addSubview:update];
    
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration shareConfiguration]hitpaBoldFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

- (UIView *)createViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    return view;
    
}


#pragma mark - TextView Delegate

- (void)textViewDidEndEditing:(UITextView * _Nonnull)textView
{
    [textView resignFirstResponder];
    
    [self animateTextView:textView isUp:NO];
    
    [(UITextView *)[self.view viewWithTag:23456] setText:textView.text];
}

- (BOOL)textViewShouldEndEditing:(UITextView * _Nonnull)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView * _Nonnull)textView
{
    
    [self animateTextView:textView isUp:YES];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView * _Nonnull)textView
{
    
    if ([textView.text isEqualToString:@"Remarks"])
    {
        textView.text = @"";
    }
    
    
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        
        if ([textView.text  isEqual: @""]) {
            textView.text = NSLocalizedString(@"Remarks", @"");
        }
        
        return NO;
    }
    
    return YES;
}


-(void)animateTextView:(UITextView*)textView isUp:(BOOL)isUp
{
    UIView *view = [textView superview];
    
    
    if (isUp)
    {
        
        CGRect textFieldRect = [self.view convertRect:view.bounds fromView:textView];
        CGFloat bottomEdge = textFieldRect.origin.y + textFieldRect.size.height;
        CGFloat keyboardYpos = self.view.frame.size.height - 230;
        
        if (bottomEdge >= keyboardYpos)
        {
            
            CGRect viewFrame = self.view.frame;
            self.shiftForKeyboard = bottomEdge - 430.0f;
            viewFrame.origin.y -= self.shiftForKeyboard;
            [self.view setFrame:viewFrame];
            
        }
        else
        {
            self.shiftForKeyboard = 0.0f;
        }
        
    }else
    {
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += self.shiftForKeyboard;
        self.shiftForKeyboard = 0.0f;
        [self.view setFrame:viewFrame];
        
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    
}

#pragma mark - Button delegate
- (IBAction)updateButtonTapped:(UIButton *)sender
{
    
    UITextView *text = (UITextView *)[self.view viewWithTag:23456];
    
    if ([text.text length] == 0) {
        
        alertView(@"HITPA", @"Please enter remarks", self, @"Ok", nil, 1223);
        return;
        
    }
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        sender.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        
        
        sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            
            [self.view endEditing:YES];
            
            UITextView *remarks = (UITextView *)[self.view viewWithTag:23456];
            self.remarksText = remarks.text;
            
            [self showHUDWithMessage:@""];
            
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:8];
            [param setValue:[[self.details.grievanceHistory objectAtIndex:0] valueForKey:@"GrvRequestId"] forKey:@"GrvRequestId"];
            [param setValue:[[self.details.grievanceHistory objectAtIndex:0] valueForKey:@"ReferenceID"] forKey:@"ReferenceID"];
            [param setValue:[[self.details.grievanceHistory objectAtIndex:0] valueForKey:@"RequestResponseType"] forKey:@"RequestResponseType"];
            [param setValue:self.remarksText forKey:@"Remarks"];
            [param setValue:[[self.details.grievanceHistory objectAtIndex:0] valueForKey:@"Status"] forKey:@"Status"];
            [param setValue:[[self.details.grievanceHistory objectAtIndex:0] valueForKey:@"ModifiedDateTIme"] forKey:@"ModifiedDateTIme"];
            [param setValue:[[self.details.grievanceHistory objectAtIndex:0] valueForKey:@"UserName"] forKey:@"UserName"];
            [param setValue:[[self.details.grievanceHistory objectAtIndex:0] valueForKey:@"AssignTo"] forKey:@"AssignTo"];
            
            [[HITPAAPI shareAPI] postGrievanceUpdateDetailWithParam:param completionHandler:^(NSDictionary *response, NSError *error){
                [self didReceiveGrievanceWithResponse:response error:error];
            }];
            
            
        }];
        
        
    }];
    
}


- (void)didReceiveGrievanceWithResponse:(NSDictionary *)response error:(NSError *)error
{
    [self hideHUD];
    
    if ([[response valueForKey:@"successID"] isEqualToString:@"\"Remarks updated successfully\""]) {

        if([self.delegate respondsToSelector:@selector(getGrievanceTrackDetails)]) {
            [self.delegate getGrievanceTrackDetails];
        }
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM YYYY"];
        NSString *raiseDate=[dateFormatter stringFromDate:[NSDate date]];
        //NSString *raiseDate = [date_String stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *raiseTime = [dateFormat stringFromDate:[NSDate date]];
        NSDate *date = [dateFormat dateFromString:raiseTime];
        [dateFormatter setDateFormat:@"hh:mm:ss a"];

        NSString *time = [dateFormatter stringFromDate:date];
        
        UITextView *remarks = (UITextView *)[self.view viewWithTag:23456];
        remarks.text = @"";
        
        NSMutableDictionary *transactionDetails = [[NSMutableDictionary alloc]init];
        [transactionDetails setValue:[NSString stringWithFormat:@"@ Complaint raised @ %@ %@",raiseDate,time] forKey:@"header"];
        [transactionDetails setValue:self.remarksText forKey:@"complaint"];
        [self.trackDetails addObject:transactionDetails];
        [self.expandCollapse addObject:[NSNumber numberWithBool:NO]];
        
        [self.tableView reloadData];
        
        alertView(@"HITPA", @"Remarks updated successfully", self, @"Ok", nil, 1323);
        return;
        
    }else{
        alertView(@"HITPA", @"Service request update failed", self, @"Ok", nil, 1323);
        return;
    }
    
    
    
}

#pragma mark - Table datasource and delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.trackDetails count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat height = 35.0;
    CGFloat width = frame.size.width;
    UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewMain.tag = section;
    viewMain.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *sectionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionGestureTapped:)];
    [viewMain addGestureRecognizer:sectionTap];
    
    xPos = 5.0;
    width = frame.size.width - xPos;
    UILabel *statusDetails = [self createLabelWithFrame:CGRectMake(xPos,yPos, width, height) title:[[self.trackDetails objectAtIndex:section] valueForKey:@"header"] fontSize:frame.size.width > 320 ? 16.0:14.0 fontColor:[UIColor colorWithRed:(25.0/255.0) green:(102.0/255.0) blue:(149.0/255.0) alpha:1.0f] alignment:NSTextAlignmentLeft];
    statusDetails.numberOfLines = 3;
    [viewMain addSubview:statusDetails];
    
    xPos = 5.0;
    yPos = viewMain.frame.size.height - 2.0;
    width = frame.size.width;
    height = 2.0;
    UIView *viewline = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
    viewline.backgroundColor = [UIColor grayColor];
    [viewMain addSubview:viewline];
    
    return viewMain;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[self.expandCollapse objectAtIndex:indexPath.section]boolValue])
    {
        return 60.0;
    }
    
    return 0.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([[self.expandCollapse objectAtIndex:section]boolValue])
    {
        return 1;
    }
    
    return 0;
    
}

-(GrievanceTrackTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GrievanceTrackTableViewCell *cell;
    if (cell == nil)
    {
        
        cell = [[GrievanceTrackTableViewCell alloc]initWithDelegate:self indexPath:indexPath complaint:[[self.trackDetails objectAtIndex:indexPath.section] valueForKey:@"complaint"]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        
    }
    
    return cell;
    
    
}

#pragma mark - Gesture Recognizer

- (void)sectionGestureTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:gestureRecognizer.view.tag];
    BOOL isBoolValue = [[self.expandCollapse objectAtIndex:indexPath.section] boolValue];
    isBoolValue = !isBoolValue;
    [self.expandCollapse replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:isBoolValue]];
    NSRange range = NSMakeRange(indexPath.section, 1);
    NSIndexSet *set  = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:set withRowAnimation:UITableViewAutomaticDimension];
    
}


#pragma mark - didReceiveMemoryWarning
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
