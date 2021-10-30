//
//  ClaimsViewController.m
//  HITPA
//
//  Created by Selma D. Souza on 07/12/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "ClaimsViewController.h"
#import "ClaimsTableViewCell.h"
#import "Configuration.h"
#import "ClaimsTableViewCell.h"
#import "Gradients.h"
#import "Helper.h"
#import "Utility.h"
#import "NIDropDown.h"
#import "Constants.h"
#import "MyPolicyModel.h"
#import "CoreData.h"
#import "HITPAAPI.h"
#import "UserManager.h"
#import "HITPAUserDefaults.h"
#import "NearMeViewController.h"
#import "HospitalModel.h"
#import "ClaimsJunction.h"
//#import "KeyboardHelper.h"
#import "KeyboardConstants.h"
#import "FeedbackViewController.h"
#import "DocumentDirectory.h"
#import "FTPHelper.h"
#import "CreateDirController.h"

NSString * const kHospitalName              = @"hospitalName";
NSString * const kPincode                   = @"pincode";
NSString * const kIntimationHospitalCode    = @"hospitalcode";
NSString * const kCity                      = @"city";
NSString * const kPatientName               = @"patientName";
NSString * const kIntimationClaimType       = @"claimType";
NSString * const kPhoneNumber               = @"phoneNo";
NSString * const kEmailAddress              = @"emailAddress";
NSString * const kDiagnosis                 = @"diagnosis";
NSString * const kAdmissionDate             = @"admissionDate";
NSString * const kDischargeDate             = @"dischargeDate";
NSString * const kClaimAmount               = @"claimAmount";
NSString * const kIntiUHID                  = @"UHID";
NSString * const kIntiRemarks               = @"remarks";
NSString * const kIntiPolicyNumber          = @"MemberPolicyNumber";
NSString * const kIntiRelationship          = @"MemberRelationship";
NSInteger  const kDatePickerViewTag         = 1000;
NSInteger  const kDatePickerTag             = 2000;
NSInteger  const kClaimsAlertTag            = 543221;
NSInteger  const kClaimHistoryStausLabelTag = 55555;
NSInteger  const kIntimationUploadScreenTag = 54322;
NSInteger  const kIntimationUploadPopUpTag  = 55556;
NSString * const kFeedbackMessage           = @"Feedback is already given!";



@interface ClaimsViewController () <claimsTableViewCell,nearMe,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,FTPHelperDelegate>

@property (nonatomic, strong)   NSMutableArray      *   claimsExpandCollapse,*imagesArray,*selectedArray;
@property (nonatomic, strong)   NSMutableArray      *   claimsExpandCollapseHistory;
@property (nonatomic, strong)   NSMutableDictionary *   claimsHistoryDetails;
@property (nonatomic, strong)   NSIndexPath         *   indexPath;
@property (nonatomic, strong)   NSString            *   selectedDate;
@property (nonatomic, strong)   NSString            *   searchText;
@property (nonatomic, strong)   NSMutableDictionary *   dict;
@property (nonatomic, readwrite) CGFloat                shiftForKeyboard;
@property (strong, nonatomic)   UIView              *   dropDownViews;
@property (nonatomic, strong)   UISegmentedControl  *   segmentedControl;

@property (nonatomic, strong)   NIDropDown          *   nIDropDown;
@property (nonatomic, strong)   MyPolicyModel       *   myPolicyDetails;
@property (nonatomic, strong)   NSMutableDictionary *   hospitalDetail;
@property(readwrite)                BOOL                  isAttach;
@property (nonatomic, strong)   NSString              * claimID;

@end

@implementation ClaimsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[KeyboardHelper sharedKeyboardHelper]notificationCenter:self.tableView view:self.view];
    // Do any additional setup after loading the view.
    
    self.claimsHistoryDetails = [[NSMutableDictionary alloc]init];
    self.hospitalDetail = [[NSMutableDictionary alloc]init];
    
    self.claimsExpandCollapse = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
    
    self.dict = [[NSMutableDictionary alloc]init];
    
    self.navigationItem.title = NSLocalizedString(@"Claims", @"");
    CGRect frame = [self bounds];
    CGFloat xPos , yPos ,width , height;
    
    xPos   = 10.0;
    yPos   = 10.0;
    width  = frame.size.width -20;
    height = 30.0;
    NSArray *selectionsArray = [NSArray arrayWithObjects: @"INTIMATE", @"HISTORY", nil];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:selectionsArray];
    self.segmentedControl.frame = CGRectMake(xPos , yPos, width, height);
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.layer.cornerRadius = 5.0;
    self.segmentedControl.layer.masksToBounds = YES;
    self.segmentedControl.tintColor = [UIColor colorWithRed:23.0/255.0 green:131.0/255.0 blue:75.0/255 alpha:1.0];
    [self.segmentedControl addTarget:self action:@selector(segmentSelection:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    if ([[[CoreData shareData] getPolicyDetail] count] > 0) {
        
        self.myPolicyDetails = [MyPolicyModel getPolicyDetailsByResponse:[[CoreData shareData] getPolicyDetail]];
        
        
    }else{
        
        [self showHUDWithMessage:@""];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
        [param setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
        [[HITPAAPI shareAPI] policyDetailsWithParams:param completionHandler:^(NSDictionary *response, NSError *error){
            [self didReceivePolicyHistoryResponse:response error:error];
        }];
        
        
    }
    
   // [self.hospitalDetail setValue:self.myPolicyDetails.memberName forKey:@"patientName"];
   // [self.hospitalDetail setValue:self.myPolicyDetails.policyNumber forKey:@"MemberPolicyNumber"];
   // [self.hospitalDetail setValue:self.myPolicyDetails.relationship forKey:@"MemberRelationship"];
    [self.hospitalDetail setValue:self.myPolicyDetails.memberID forKey:@"UHID"];

    
    //Status Label
    width = frame.size.width * 0.8;
    height = 40.0;
    xPos = roundf(frame.size.width - width)/2;
    yPos = roundf((frame.size.height - height - self.segmentedControl.frame.size.height - 50.0 - 64.0)/2);
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    statusLabel.tag = kClaimHistoryStausLabelTag;
    [statusLabel setHidden:YES];
    statusLabel.text = @"No Claim History";
    [statusLabel setTextColor:[UIColor whiteColor]];
    [statusLabel setTextAlignment:NSTextAlignmentCenter];
    [statusLabel setFont:[[Configuration shareConfiguration] hitpaBoldFontWithSize:14.0]];
    [self.tableView addSubview:statusLabel];
     [self loadTableView];
    [self reloadTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.segmentedControl.selectedSegmentIndex == 1)
    {
        [self showHUDWithMessage:@""];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
        [param setValue:[[UserManager sharedUserManager] userName] forKey:@"userid"];
//        [param setValue:@"CompletedTransactions" forKey:@"statusType"];
        [param setValue:@"LiveTransactions" forKey:@"statusType"];
        [[HITPAAPI shareAPI] getIntimationWithParam:param completionHandler:^(NSDictionary *response, NSError *error){
            
            [self didReceiveClaimsHistoryResponse:response error:error];
            
        }];
    }
}

- (void)loadTableView {
    
    self.imagesArray = [[NSMutableArray alloc]init];
    self.selectedArray = [[NSMutableArray alloc]init];
//    self.imagesArray = [[DocumentDirectory shareDocumentDirectory] getImagesOrPdfsFromDocumentDirectory];
//    if (self.imagesArray.count > 0) {
////        [self.tableView reloadData];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//    }
}

- (void)viewDidLayoutSubviews
{
    CGRect frame  = [self bounds];
    self.view.frame = CGRectMake(frame.origin.x, frame.origin.y + 60.0, frame.size.width, frame.size.height - 60.0);
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 74.0);
      [self.view layoutIfNeeded];
}

- (CGRect)bounds
{
    return [[UIScreen mainScreen]bounds];
}

- (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:backgroundColor];
    return view;
}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor alignment:(NSTextAlignment)alignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = NSLocalizedString(title,@"");
    label.font = [[Configuration shareConfiguration]hitpaFontWithSize:fontSize];
    label.textColor = fontColor;
    [label setTextAlignment:alignment];
    return label;
}

#pragma mark - Segment control
- (void)segmentSelection:(UISegmentedControl *)segment
{
    [self viewDidLayoutSubviews];
    
    if (segment.selectedSegmentIndex == 1)
    {
        [self showHUDWithMessage:@""];
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
        [param setValue:[[UserManager sharedUserManager] userName] forKey:@"userid"];
//        [param setValue:@"CompletedTransactions" forKey:@"statusType"];
        [param setValue:@"LiveTransactions" forKey:@"statusType"];
        [[HITPAAPI shareAPI] getIntimationWithParam:param completionHandler:^(NSDictionary *response, NSError *error){
            
            [self didReceiveClaimsHistoryResponse:response error:error];
            
        }];
    }else if (segment.selectedSegmentIndex == 0)
    {
        [(UILabel *)[self.view viewWithTag:kClaimHistoryStausLabelTag] setHidden:YES];

        [self reloadTableView];
    }
    
}

#pragma mark - Table View datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        return 6;
    }
    else
    {
        return [[self.claimsHistoryDetails valueForKey:@"history"] count];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    [[KeyboardHelper sharedKeyboardHelper]notificationCenter:tableView view:self.view];
    HospitalModel *detial = (HospitalModel *)[self.hospitalDetail valueForKey:@"hospitaldetail"];
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        if (section < 3)
        {
            if ([[self.claimsExpandCollapse objectAtIndex:section]boolValue])
            {
                if(section == 1)
                    return  7;
                else
                    
                    if (detial.hospitalName != nil && section == 0)
                    {
                        return 1;
                        
                    }else
                    {
                        return 4;
                    }
                
                
            }
            else
                return 0;
        }else if (section == 5)
        {
            return 0;
        }else if(section == 4){
            return (self.imagesArray.count > 0) ? 1 : 0;
        }
        return 0;
    }
    else
    {
        if ([[self.claimsExpandCollapseHistory objectAtIndex:section]boolValue])
        {
            ClaimsJunction *claimJunction = (ClaimsJunction *)[[self.claimsHistoryDetails valueForKey:@"history"] objectAtIndex:section];
            if([claimJunction.claimStatus isEqualToString:@"Claim Settled"] || [claimJunction.claimStatus isEqualToString:@"Settled"])
                return  15;
            return 9;
        }
        else
        {
            return 0;
        }
        
        
    }
    
    
}

- (CGFloat )getHeightWithText:(NSString *)text font:(UIFont *)font
{
    
    CGRect frame = [self bounds];
    
    CGFloat xPos = 3.0;
    CGFloat yPos = 5.0;
    CGFloat width = frame.size.width - 12.0;
    CGFloat height = 20.0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    [label setText:[text capitalizedString]];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label sizeToFit];
    
    return label.frame.size.height;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        if (indexPath.section < 3)
        {
            if ([[self.claimsExpandCollapse objectAtIndex:indexPath.section]boolValue])
            {
                HospitalModel *detial = (HospitalModel *)[self.hospitalDetail valueForKey:@"hospitaldetail"];
                
                if (detial.hospitalName != nil && indexPath.section == 0)
                {
                    NSLog(@"indexPathSection => %ld",(long)indexPath.section);
                    
                    if (indexPath.row == 0)
                        return [self getHeightWithText:detial.address font:[UIFont fontWithName:@"Helvetica" size:16.0f]] + 200.0;
                    else
                        return 0.0;
                    
                }else
                {
                    return 70.0;
                }
                
                
            }
            else
                return 0.0;
        }else if (indexPath.section == 4)
        {
            if([self.imagesArray count]){
                long int isDivison=[self.imagesArray count]/3;
                int isPosition = 10;
                NSMutableArray *height=[[NSMutableArray alloc]init];
                for (int r=0; r< isDivison+1; r++) {
                    [height addObject:[NSString stringWithFormat:@"%d",isPosition]];
                    isPosition = isPosition + 70;
                }
                return isPosition + 10;
            }else{
                return 0.0;
            }
        }else if (indexPath.section == 5)
        {
            return  0.0;
        }
        return 0.0;
        
    }
    else
    {
        if([[self.claimsHistoryDetails valueForKey:@"history"]count] > 0)
        {
            if ([[self.claimsExpandCollapseHistory objectAtIndex:indexPath.section]boolValue])
            {
                ClaimsJunction *claimJunction = (ClaimsJunction *)[[self.claimsHistoryDetails valueForKey:@"history"] objectAtIndex:indexPath.section];
                if([claimJunction.claimStatus isEqualToString:@"Claim Settled"] || [claimJunction.claimStatus isEqualToString:@"Settled"]) {
                    if(indexPath.row == 9)
                        return 40.0;
                }
                else {
                    if(indexPath.row == 4)
                        return 40.0;
                }
                return 30.0;
            }
            else
            {
                return 0.0;
            }
        }
        return 0.0;

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        UIView *sectionFooter = [[UIView alloc]init];
        sectionFooter.backgroundColor = [UIColor clearColor];
        return  sectionFooter;
        
    }
    else
    {
        UIView *sectionFooter = [[UIView alloc]init];
        sectionFooter.backgroundColor = [UIColor clearColor];
        return  sectionFooter;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        return 16.0;
    }
    else
    {
        return 4.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = [self bounds];
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat width =  frame.size.width;
    CGFloat height = 50.0;
    UIView *sectionHeader = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        
        if(section < 3)
        {
            UIImage * rightImage;
            NSString *title;
            UIColor *color;
            switch (section)
            {
                case 0:
                    title = @"Hospital Search";
                    rightImage = [UIImage imageNamed:@""];
                    color = [UIColor colorWithRed:216/255.0 green:66/255.0 blue:72/255.0 alpha:1.0];
                    break;
                    
                case 1:
                    title = @"Patient Details";
                    rightImage = [UIImage imageNamed:@""];
                    color = [UIColor colorWithRed:5/255.0 green:143/255.0 blue:134/255.0 alpha:1.0];
                    break;
                case 2:
                    title = @"Hospitalization Details";
                    rightImage = [UIImage imageNamed:@""];
                    color = [UIColor colorWithRed:155/255.0 green:74/255.0 blue:211/255.0 alpha:1.0];
                    break;
                    
                default:
                    break;
            }
            
            if([[self.claimsExpandCollapse objectAtIndex:section]boolValue])
            {
                rightImage = minusImage;
            }
            else
            {
                rightImage = plusImage;
            }
            
            
            UIView *sectionView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:color];
            sectionView.tag = section;
            
            UITapGestureRecognizer *sectionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionGestureTapped:)];
            [sectionView addGestureRecognizer:sectionTap];
            
            [sectionHeader addSubview:sectionView];
            
            xPos =  10.0;
            yPos =  10.0;
            width = frame.size.width - xPos - 40.0;
            height = 30.0;
            UILabel *sectionTitle = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:title fontSize:16.0 fontColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
            [sectionView addSubview:sectionTitle];
            
            xPos = sectionTitle.frame.origin.x + sectionTitle.frame.size.width + 10.0;
            yPos = 15.0;
            width = 20.0;
            height = 20.0;
            UIImageView *rightImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:rightImage];
            rightImageView.tag = section;
            rightImageView.backgroundColor = [UIColor grayColor];
            [sectionView addSubview:rightImageView];
        }
        else if (section == 4)
        {
            
            xPos = 0.0;
            yPos = 0.0;
            width =  frame.size.width;
            height = 50.0;
            UIView *raiseGrievanceView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
            
            xPos = 15.0;
            yPos = 0.0;
            width =  frame.size.width/2;
            height = 50.0;
            UILabel *uploadAttachment = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            uploadAttachment.text = @"Upload Attachments:";
            uploadAttachment.textColor = [UIColor whiteColor];
            uploadAttachment.font = [UIFont systemFontOfSize:15.0];
            [raiseGrievanceView addSubview:uploadAttachment];
            
            xPos = uploadAttachment.frame.size.width + 20.0;
            yPos = 10.0;
            width =  (frame.size.width/2) - 30.0;
            height = 30.0;
            UIButton *addAttachment = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            [addAttachment setTitle:@"Attach File" forState:UIControlStateNormal];
            addAttachment.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
            [addAttachment addTarget:self action:@selector(uploadAttachments:) forControlEvents:UIControlEventTouchUpInside];
            addAttachment.layer.cornerRadius = 5.0;
            addAttachment.layer.borderColor = [UIColor colorWithRed:214/255.0 green:213/255.0 blue:215/255.0 alpha:1.0].CGColor;
            addAttachment.layer.borderWidth = 1.0;
            addAttachment.layer.masksToBounds = YES;
            addAttachment.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
            [addAttachment setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
            [raiseGrievanceView addSubview:addAttachment];
            [sectionHeader addSubview:raiseGrievanceView];
            
        }else if (section == 5)
        {
            
            xPos = sectionHeader.frame.size.width / 3.25;
            yPos = 0.0;
            width = sectionHeader.frame.size.width / 2.5;
            height = 40.0;
            UIButton *intimateButton = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            [intimateButton setTitle:@"Intimate Claim" forState:UIControlStateNormal];
            intimateButton.layer.cornerRadius = 4.0;
            intimateButton.layer.borderColor = [UIColor colorWithRed:214/255.0 green:213/255.0 blue:215/255.0 alpha:1.0].CGColor;
            intimateButton.layer.borderWidth = 1.0;
            intimateButton.layer.masksToBounds = YES;
            intimateButton.titleLabel.font = [[Configuration shareConfiguration]hitpaFontWithSize:16.0];
            [intimateButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
            [intimateButton addTarget:self action:@selector(intimateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [sectionHeader addSubview:intimateButton];
            
        }else if (section == 3)
        {
            height = 120.0;
            UIView *sectionView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor clearColor]];
             [sectionHeader addSubview:sectionView];
            xPos =  10.0;
            yPos =  4.0;
            width = frame.size.width - xPos - 40.0;
            height = 30.0;
            UILabel *sectionTitle = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:@"Remarks" fontSize:16.0 fontColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
            [sectionView addSubview:sectionTitle];
            yPos = sectionTitle.frame.origin.y + sectionTitle.frame.size.height;
            width = frame.size.width - (xPos * 2);
            height = 80.0;
            UITextView *remarks = [[UITextView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            [remarks setDelegate:self];
            remarks.text = @"Remarks";
            remarks.textColor = [UIColor grayColor];
            if([self.hospitalDetail valueForKey:@"remarks"]) {
                remarks.text = [self.hospitalDetail valueForKey:@"remarks"];
                remarks.textColor = [UIColor blackColor];

            }
            [remarks.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [remarks.layer setBorderWidth:0.5];
            [remarks.layer setCornerRadius:5.0];
            [remarks.layer setMasksToBounds:YES];
            [sectionView addSubview:remarks];
        }
    
    }else
    {
        
        height = 40.0;
        UIColor *color = [UIColor whiteColor];
        UIView *claimsHistory = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:color];
        claimsHistory.tag = section;
        UITapGestureRecognizer *sectionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(historyGestureTapped:)];
        
        [claimsHistory addGestureRecognizer:sectionTap];
        [sectionHeader addSubview:claimsHistory];
        
        xPos =  10.0;
        yPos = 0.0;
        width = frame.size.width - 50.0;
        height = 40.0;
        UILabel *sectionTitle = [self createLabelWithFrame:CGRectMake(xPos, yPos, width, height) title:[NSString stringWithFormat:@"Claim @ %@",([[[self.claimsHistoryDetails valueForKey:@"history"] valueForKey:@"hospitalName"] objectAtIndex:section] == [NSNull null])? @"NA": [[[self.claimsHistoryDetails valueForKey:@"history"] valueForKey:@"hospitalName"] objectAtIndex:section]] fontSize:16.0 fontColor:[UIColor colorWithRed:45.0f/255.0f green:60.0f/255.0f blue:145.0f/255.0f alpha:1.0] alignment:NSTextAlignmentCenter];
        [claimsHistory addSubview:sectionTitle];
        
        //Line
        xPos = 0.0;
        yPos = claimsHistory.frame.size.height - 1.0;
        height = 1.0;
        width = claimsHistory.frame.size.width;
        UIView *lineView = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height) backgroundColor:[UIColor colorWithRed:43.0/255.0 green:63.0/255.0 blue:98.0/255.0 alpha:1.0]];
        [claimsHistory addSubview:lineView];
        
        UIImage *rightImage = [UIImage imageNamed:@""];
        if([[self.claimsExpandCollapseHistory objectAtIndex:section]boolValue])
        {
            rightImage = minusgreenImage;
        }
        else
        {
            rightImage = plusgreenImage;
        }
        
        xPos = sectionTitle.frame.origin.x + sectionTitle.frame.size.width + 10.0;
        width = 20.0;
        height = 20.0;
        yPos = (claimsHistory.frame.size.height - height)/2;
        UIImageView *rightImageView = [self createImageViewWithFrame:CGRectMake(xPos, yPos, width, height) image:rightImage];
        rightImageView.tag = section;
        [claimsHistory addSubview:rightImageView];
        
    }
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return (section == 3 && self.segmentedControl.selectedSegmentIndex == 0)?120.0:40.0;
    
}

- (ClaimsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClaimsTableViewCell *cell;
    
    if(cell == nil)
    {
        [self.hospitalDetail setValue:self.myPolicyDetails.email forKey:@"emailAddress"];
        [self.hospitalDetail setValue:self.myPolicyDetails.contactNo forKey:@"phoneNo"];
        
        cell = [[ClaimsTableViewCell alloc]initWithIndexPath:indexPath delegate:self segment:self.segmentedControl.selectedSegmentIndex response:[self.claimsHistoryDetails valueForKey:@"history"] hospitalDetail:self.hospitalDetail imagesArray: self.imagesArray isAttach : self.isAttach selectedArray: self.selectedArray];
    }
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        
        if (indexPath.section < 3)
        {
            if ([[self.claimsExpandCollapse objectAtIndex:indexPath.section]boolValue])
            {
                cell.backgroundColor = [UIColor whiteColor];
                
            }
        }
        
        
    }
    else
    {
        
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //To Hide enabled ClaimsTableViewCell when User scrolled
    ClaimsTableViewCell *patientNameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
     NSLog(@"patientNameCell:%@", patientNameCell);
    if (patientNameCell.dropDownViews != nil) {
        [patientNameCell.dropDownViews removeFromSuperview];
        patientNameCell.nIDropDown = nil;
    }
    
    ClaimsTableViewCell *claimCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    NSLog(@"claimCell:%@", claimCell);
    if (claimCell.dropDownViews != nil) {
        [claimCell.dropDownViews removeFromSuperview];
        claimCell.nIDropDown = nil;
    }
}

#pragma  mark  - Protocol

- (void)memberWithDetails:(NSDictionary *)details
{
    
    [self.hospitalDetail setValue:[details valueForKey:@"MemberName"] forKey:kPatientName];
    [self.hospitalDetail setValue:[details valueForKey:@"UHID"] forKey:kIntiUHID];
    [self.hospitalDetail setValue:[details valueForKey:@"MemberPolicyNumber"] forKey:kIntiPolicyNumber] ;
     [self.hospitalDetail setValue:[details valueForKey:@"MemberRelationship"] forKey:kIntiRelationship] ;
    //23213
    NSArray *tableSubViews = [self.tableView subviews];
    if ([tableSubViews count] > 0)
    {
        for (ClaimsTableViewCell  * cell in tableSubViews)
        {
            NSArray *cellSubViews = [cell subviews];
            if ([cellSubViews count] > 0)
            {
                NSArray *subView = [[cellSubViews objectAtIndex:0] subviews];
                if ([subView count] > 0)
                {
                    UIView *view = [subView objectAtIndex:0];
                    if (view.tag == 23213)
                    {
                        UILabel *label =  [[view subviews] objectAtIndex:0];
                        UITextField *textFiled = [[view subviews] objectAtIndex:1];
                        if (textFiled.tag == 0)
                        {
                            textFiled.text = [details valueForKey:@"MemberName"];
                        }else if (textFiled.tag == 1)
                        {
                            label.text = @"UHID";
                            textFiled.text = [details valueForKey:@"UHID"];
                            [textFiled setEnabled:(textFiled.text.length >0) ? false : true];
                        }else if (textFiled.tag == 2)
                        {
                            label.text = @"Policy Number";
                            textFiled.text = [details valueForKey:@"MemberPolicyNumber"];
                            [textFiled setEnabled:(textFiled.text.length >0) ? false : true];
                        }else if (textFiled.tag == 4)
                        {
                            label.text = @"Relationship";
                            textFiled.text = [details valueForKey:@"MemberRelationship"];
                            [textFiled setEnabled:(textFiled.text.length >0) ? false : true];
                        }
                    }
                }
            }

        }
    }
    
}

- (void)claimType:(NSString *)claimType
{
    
    [self.hospitalDetail setValue:claimType forKey:kIntimationClaimType];
    
    
}

- (void)searchAgain
{
    
    self.hospitalDetail = nil;
    [self.tableView reloadData];
    
    //    NSArray *indexPath = [[NSArray alloc]initWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
    //    [self.tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
    
}


- (void)nearMeHospital
{
    
    NearMeViewController *vctr = [[NearMeViewController alloc]initWithDelegate:self];
    [self.navigationController pushViewController:vctr animated:YES];
    
}


- (void)hospitaWithDetail:(HospitalModel *)hospital
{
    
    if (!self.dict)
        self.dict  = [[NSMutableDictionary alloc]init];
    [self.dict setValue:hospital.hospitalName forKey:kHospitalName];
    [self.dict setValue:hospital.hospitalCode forKey:kIntimationHospitalCode];
    self.hospitalDetail = [[NSMutableDictionary alloc]init];
    //[self.hospitalDetail setValue:self.myPolicyDetails.memberName forKey:@"patientName"];
    //[self.hospitalDetail setValue:self.myPolicyDetails.policyNumber forKey:@"MemberPolicyNumber"];
    //[self.hospitalDetail setValue:self.myPolicyDetails.relationship forKey:@"MemberRelationship"];
    //[self.hospitalDetail setValue:self.myPolicyDetails.memberID forKey:@"UHID"];
    [self.hospitalDetail setValue:hospital forKey:@"hospitaldetail"];
    
    [self.tableView reloadData];
        
    //    NSArray *indexPath = [[NSArray alloc]initWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
    //    [self.tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)postClaimsWithParams:(NSMutableDictionary *)params
{
    
    
}

- (void)createDatePickerView:(UIButton *)sender indexPath:(NSIndexPath *)indexPath
{
    
    self.indexPath = indexPath;
    CGRect frame = [self bounds];
    
    //view
    CGFloat xPos = 0.0;
    CGFloat yPos = 0.0;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    UIView * datePickerView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos,width, height)];
    datePickerView.tag = kDatePickerViewTag;
    [datePickerView setBackgroundColor:[UIColor colorWithRed:(6.0/255.0) green:(6.0/255.0) blue:(6.0/255.0) alpha:0.4f]];
    [self.view addSubview:datePickerView];
    
    //set
    xPos    = datePickerView.frame.origin.x;
    yPos    = frame.size.height -  (datePickerView.frame.size.height / 2.0 + 30.0);
    width   = round(datePickerView.frame.size.width / 2);
    height  = 30.0;
    UIButton *set = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    set.tag = sender.tag;
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
    height = datePickerView.frame.size.height / 2.0;
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(xPos, yPos,width, height)];
    datePicker.tag = kDatePickerTag;
    datePicker.backgroundColor = [UIColor grayColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
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

- (void)getChoosedImages:(NSMutableArray *)selectedArray
{
    self.selectedArray = selectedArray;
    NSLog(@"imagesArray1:%@", self.imagesArray);
    NSLog(@"selectedArray:%@", self.selectedArray);
    if (self.selectedArray.count) {
        
        for (int i = 0; i < [self.selectedArray count]; i++) {
            NSString *index = [self.selectedArray objectAtIndex:i];
            [[DocumentDirectory shareDocumentDirectory] removeImageOrPdfWithName:[self.imagesArray objectAtIndex:[index integerValue]-1]];
            [self.imagesArray removeObjectAtIndex:[index integerValue]-1];
        }
        [self.selectedArray removeAllObjects];
//        [self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSLog(@"imagesArray2:%@", self.imagesArray);
}

- (void)populateDictWithFieldText:(NSString *)string tag:(NSInteger)tag
{
    switch (tag) {
        case HospitalName:
            
            [self.dict setValue:string forKey:kHospitalName];
            break;
        case Pincode:
            [self.dict setValue:string forKey:kPincode];
            break;
        case City:
            [self.dict setValue:string forKey:kCity];
            break;
        case PatientName:
            [self.hospitalDetail setValue:string forKey:kPatientName];
            [self.dict setValue:string forKey:kPatientName];
            break;
        case PhoneNo:
            [self.hospitalDetail setValue:string forKey:kPhoneNumber];
            [self.dict setValue:string forKey:kPhoneNumber];
            break;
        case EmailAddress:
            [self.hospitalDetail setValue:string forKey:kEmailAddress];
            [self.dict setValue:string forKey:kEmailAddress];
            break;
        case Diagnosis:
            [self.hospitalDetail setValue:string forKey:kDiagnosis];
            [self.dict setValue:string forKey:kDiagnosis];
            break;
        case AdmissionDate:
            [self.hospitalDetail setValue:string forKey:kAdmissionDate];
            [self.dict setValue:string forKey:kAdmissionDate];
            break;
        case DischargeDate:
            
            [self validateDate:[self.dict valueForKey:kAdmissionDate] dischargeDate:string];
            
//            [self.hospitalDetail setValue:string forKey:kDischargeDate];
//            [self.dict setValue:string forKey:kDischargeDate];
            break;
        case ClaimAmount:
            [self.hospitalDetail setValue:string forKey:kClaimAmount];
            [self.dict setValue:string forKey:kClaimAmount];
            break;
        default:
            break;
    }
}

- (void)validateDate:(NSString *)admissionDate dischargeDate:(NSString *)dischargeDate
{
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *admissiondate = [dateFormat dateFromString:admissionDate];
    NSDate *dischargedate = [dateFormat dateFromString:dischargeDate];

    if ([admissiondate compare:dischargedate] == NSOrderedAscending || [admissiondate compare:dischargedate] == NSOrderedSame)
    {
//        NSLog(@"right");
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        
        NSArray *subviews = [cell subviews];
        if ([subviews count] > 0)
        {
            
            UITextField *textField = (UITextField *) [[[[[subviews objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0];
            
//            NSLog(@"tag:%ld",(long)textField.tag);
            
            textField.text = (textField.text == nil || [textField.text length] <= 0)?dischargeDate:dischargeDate;
            
        }


        [self.hospitalDetail setValue:dischargeDate forKey:kDischargeDate];
        [self.dict setValue:dischargeDate forKey:kDischargeDate];
        

    }
    else
    {
//        NSLog(@"wrong");
        alertView([[Configuration shareConfiguration] appName], @"Date of Discharge should be greater than date of Admission", nil, @"Ok", nil, 0);
        return ;
    }
}

-(void)dateSelectTapped:(UIButton *)sender
{
    
    NSString *date = [self convertDateFormatWithDate:[(UIDatePicker *)[self.view viewWithTag:kDatePickerTag] date]];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    
    NSArray *subviews = [cell subviews];
    if ([subviews count] > 0)
    {
        
        UITextField *textField = (UITextField *) [[[[[subviews objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0];
        
        NSLog(@"tag:%ld",(long)textField.tag);
        
        if (textField.tag == AdmissionDate) {
            textField.text = (textField.text == nil || [textField.text length] <= 0)?date:date;

        }
//        textField.text = (textField.text == nil || [textField.text length] <= 0)?date:date;
        
        
        [self populateDictWithFieldText:date tag:textField.tag];
        
    }
    
    [[self.view viewWithTag:kDatePickerViewTag] removeFromSuperview];
    
    
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    
    self.selectedDate = [self convertDateFormatWithDate:datePicker.date];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    
    NSArray *subviews = [cell subviews];
    
    if ([subviews count] > 0)
    {
        
        UITextField *textField = (UITextField *) [[[[[subviews objectAtIndex:0] subviews] objectAtIndex:0] subviews]objectAtIndex:0];
        
//        textField.text = self.selectedDate;
        
    }
    
    
}

- (NSString *)convertDateFormatWithDate:(NSDate *)selectDate
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:selectDate];
    
    
}

- (IBAction)dateCancelTapped:(id)sender
{
    
    [[self.view viewWithTag:kDatePickerViewTag] removeFromSuperview];
    
}

- (void)feedbackWithIndex:(NSInteger)index feedbackStatus:(NSString *)status {
    
    if([status isEqualToString:@"True"]) {
        alertView([[Configuration shareConfiguration] appName], kFeedbackMessage, nil, @"Ok", nil, 0);
    }
    else {
        ClaimsJunction *details = [[self.claimsHistoryDetails valueForKey:@"history"]objectAtIndex:index];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[[UserManager sharedUserManager] userName] forKey:@"UHID"];
        [dict setValue:details.claimNumber forKey:@"ClaimNo"];
        [dict setValue:details.coverage forKey:@"amountEnhanced"];
        [dict setValue:details.consumed forKey:@"dischargeAmount"];
        FeedbackViewController *vctr = [[FeedbackViewController alloc]initWithUpdateDetails:dict];
        [self.navigationController pushViewController:vctr animated:YES];
    }
}

- (UIView *)createViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    return view;
    
}

#pragma mark - Button Delegate

- (IBAction)uploadAttachments:(UIButton *)sender
{
    NSLog(@"uploadAttachments");
    [self.view endEditing:YES];
    self.isAttach = YES;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        sender.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        } completion:^(BOOL finished) {
            sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.navigationController.navigationBarHidden = YES;
            CGRect frame = [[UIScreen mainScreen] bounds];
            CGFloat xPos = 0.0;
            CGFloat yPos = 0.0;
            CGFloat height = frame.size.height;
            CGFloat width = frame.size.width;
            UIView *viewMain = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
            viewMain.backgroundColor = [UIColor blackColor];
            viewMain.tag = kIntimationUploadScreenTag;
            viewMain.alpha = 0.6;
            [self.view addSubview:viewMain];
            
            width = frame.size.width - 40.0;
            height = 225.0;
            xPos = (frame.size.width - width)/2;
            yPos = (frame.size.height - height)/2;
            UIView *popUp = [self createViewWithFrame:CGRectMake(xPos, yPos, width, height)];
            popUp.backgroundColor = [UIColor whiteColor];
            popUp.tag = kIntimationUploadPopUpTag;
            popUp.layer.cornerRadius = 5.0;
            [self.view addSubview:popUp];
            
            width = popUp.frame.size.width;
            height = 40.0;
            xPos = 0.0;
            yPos = 0.0;
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            title.text = @"Intimation";
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor colorWithRed:(96.0/255.0) green:(193.0/255.0) blue:(244.0/255.0) alpha:1.0f];
            title.font = [UIFont boldSystemFontOfSize:20.0];
            [popUp addSubview:title];
            
            height = 2.0;
            yPos = 40.0;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            line.backgroundColor = [UIColor colorWithRed:(96.0/255.0) green:(193.0/255.0) blue:(244.0/255.0) alpha:1.0f];
            [popUp addSubview:line];
            
            height = 40.0;
            yPos = 42.0;
            UILabel *option = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            option.text = @"How would you like to upload ?";
            option.textAlignment = NSTextAlignmentCenter;
            option.textColor = [UIColor blackColor];
            option.font = [UIFont systemFontOfSize:16.0];
            [popUp addSubview:option];
            
            height = 100.0;
            yPos = 82.0;
            xPos = 0.0;
            width = popUp.frame.size.width/3;
            UIView *capture = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//            capture.backgroundColor = [UIColor blueColor]; //Need to Remove
            [popUp addSubview:capture];
            
            height = 100.0;
            yPos = 82.0;
            xPos = popUp.frame.size.width/3;
            width = popUp.frame.size.width/3;
            UIView *gallery = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//            gallery.backgroundColor = [UIColor redColor]; //Need to Remove
            [popUp addSubview:gallery];
            
            //File Manager
            height = 100.0;
            yPos = 82.0;
            xPos = (popUp.frame.size.width/3) + (popUp.frame.size.width/3);
            width = popUp.frame.size.width/3;
            UIView *fileManager = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
//            fileManager.backgroundColor = [UIColor greenColor]; //Need to Remove
            [popUp addSubview:fileManager];
            
            width = 120.0;
            height = 35.0;
            yPos = 185.0;
            xPos = (popUp.frame.size.width - width)/2;
            UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:18.0];
            cancel.backgroundColor = [UIColor colorWithRed:(96.0/255.0) green:(193.0/255.0) blue:(244.0/255.0) alpha:1.0f];
            [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            cancel.layer.cornerRadius = 5.0;
            [popUp addSubview:cancel];
            
            height = 30.0;
            yPos = 70.0;
            xPos = 0.0;
            width = capture.frame.size.width;
            UILabel *captureTitle = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            captureTitle.text = @"Capture";
            captureTitle.textAlignment = NSTextAlignmentCenter;
            captureTitle.textColor = [UIColor blackColor];
            captureTitle.font = [UIFont systemFontOfSize:16.0];
            [capture addSubview:captureTitle];
            
            UILabel *galleryTitle = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            galleryTitle.text = @"Gallery";
            galleryTitle.textAlignment = NSTextAlignmentCenter;
            galleryTitle.textColor = [UIColor blackColor];
            galleryTitle.font = [UIFont systemFontOfSize:16.0];
            [gallery addSubview:galleryTitle];
            
            UILabel *fileManagerTitle = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            fileManagerTitle.text = @"File Manager";
            fileManagerTitle.textAlignment = NSTextAlignmentCenter;
            fileManagerTitle.textColor = [UIColor blackColor];
            fileManagerTitle.font = [UIFont systemFontOfSize:16.0];
            [fileManager addSubview:fileManagerTitle];
            
            height = 60.0;
            yPos = 5.0;
            width = 60.0;
            xPos = (capture.frame.size.width - width)/2;
            UIImageView *captureImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            captureImage.image = [UIImage imageNamed:@"icon_camera.png"];
            [capture addSubview:captureImage];
            
            UIImageView *chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            chooseImage.image = [UIImage imageNamed:@"icon_gallery.png"];
            [gallery addSubview:chooseImage];
            
            UIImageView *fileManagerImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
            fileManagerImage.image = [UIImage imageNamed:@"ic_folder.png"];
            [fileManager addSubview:fileManagerImage];
            
            UITapGestureRecognizer *captureTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachCapturedImage:)];
            [capture addGestureRecognizer:captureTapped];
            
            UITapGestureRecognizer *galleryTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachGalleryImage:)];
            [gallery addGestureRecognizer:galleryTapped];
            
            UITapGestureRecognizer *fileManagerTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachFileManagerPdf:)];
            [fileManager addGestureRecognizer:fileManagerTapped];
            
        }];
        
    }];
    
    
}

- (void)attachCapturedImage:(UITapGestureRecognizer *)gesture
{
    self.navigationController.navigationBarHidden = NO;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        alertView(@"Camera", @"Device has no Camera.", nil, @"Ok", nil, 0);
    } else {
        //UIImagePickerControllerSourceTypeCamera is Available
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:Nil];
        
        [(UIView *) [self.view viewWithTag:kIntimationUploadScreenTag] removeFromSuperview];
        [(UIView *) [self.view viewWithTag:kIntimationUploadPopUpTag] removeFromSuperview];
    }
}

- (void)attachGalleryImage:(UITapGestureRecognizer *)gesture
{
    self.navigationController.navigationBarHidden = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:Nil];
    
    [(UIView *) [self.view viewWithTag:kIntimationUploadScreenTag] removeFromSuperview];
    [(UIView *) [self.view viewWithTag:kIntimationUploadPopUpTag] removeFromSuperview];
    
}

- (void)attachFileManagerPdf:(UITapGestureRecognizer *)gesture
{
    NSLog(@"attachFileManagerPdf");
    self.navigationController.navigationBarHidden = NO;
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"com.apple.iwork.pages.pages", @"com.apple.iwork.numbers.numbers", @"com.apple.iwork.keynote.key", @"public.image", @"com.apple.application", @"public.item", @"public.data", @"public.content", @"public.audiovisual-content", @"public.movie", @"public.audiovisual-content", @"public.video", @"public.audio", @"public.text", @"public.data", @"public.composite-content", @"public.text"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
    
    [(UIView *) [self.view viewWithTag:kIntimationUploadScreenTag] removeFromSuperview];
    [(UIView *) [self.view viewWithTag:kIntimationUploadPopUpTag] removeFromSuperview];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        
        NSLog(@"lastPathComponent:%@", [url lastPathComponent]);
        NSLog(@"pathExtension:%@", [url pathExtension]);
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        if (imageData.length > 0) {
            //To Check Duplicate Array Name and Maintain unique names in Array
            NSString *imageName = [NSString stringWithFormat:@"%@", url.lastPathComponent];
            BOOL isTheObjectThere = [self.imagesArray containsObject:imageName];
            if (isTheObjectThere) {
                NSLog(@"isTheObjectThere1");
                for (long int i = 1; i <= [self.imagesArray count]+1; i++) {
                    imageName = [NSString stringWithFormat:@"%@%lu.%@", imageName, i, url.pathExtension];
                    BOOL isTheObjectThere = [self.imagesArray containsObject:imageName];
                    if (isTheObjectThere) {
                        NSLog(@"isTheObjectThere2");
                    } else {
                        i = [self.imagesArray count]+1;
                    }
                }
            }
            
            if ([[DocumentDirectory shareDocumentDirectory] writeImageOrPdfIntoDocumentDirectory:imageData imageName:imageName]) {
                [self.imagesArray addObject:imageName];
                NSLog(@"UIDocumentPickerViewController:%@", self.imagesArray);
                [controller dismissViewControllerAnimated:YES completion:nil];
                
//                [self.tableView reloadData];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

#pragma mark-imagePickerControler
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    
    if (imageData.length > 0) {
        //To Check Duplicate Array Name and Maintain unique names in Array
        NSString *imageName = [NSString stringWithFormat:@"Image%lu.jpg", [self.imagesArray count]+1];
        BOOL isTheObjectThere = [self.imagesArray containsObject:imageName];
        if (isTheObjectThere) {
             NSLog(@"isTheObjectThere1");
            for (long int i = 1; i <= [self.imagesArray count]+1; i++) {
                imageName = [NSString stringWithFormat:@"Image%lu.jpg", i];
                BOOL isTheObjectThere = [self.imagesArray containsObject:imageName];
                if (isTheObjectThere) {
                    NSLog(@"isTheObjectThere2");
                } else {
                    i = [self.imagesArray count]+1;
                }
            }
        }
        
        if ([[DocumentDirectory shareDocumentDirectory] writeIntimateImageIntoDocumentDirectory:imageData imageName:imageName]) {
            
//            NSMutableDictionary *dic_Images=[[NSMutableDictionary alloc]init];
//            [dic_Images setValue:selectedImage forKey:[NSString stringWithFormat:@"Image%lu", imageName]];
            
//            [self.imagesArray mutableCopy];
//            [self.imagesArray addObject:dic_Images];
            [self.imagesArray addObject:imageName];
             NSLog(@"imagePickerController:%@", self.imagesArray);
            [picker dismissViewControllerAnimated:YES completion:nil];
            
//            [self.tableView reloadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)uploadImagesUsingFTP:(NSString *)claimID {

//    [[DocumentDirectory shareDocumentDirectory] uploadMediaFolderToServer]; //Need to Remove
    
    BOOL compressStatus = [[DocumentDirectory shareDocumentDirectory] compressImagesWithUserName:true];
    if (compressStatus) {
        
        BOOL folderZipFile = [[DocumentDirectory shareDocumentDirectory] zipWithUserName: @"ftpuser_intimate"];
        if (folderZipFile) {
            NSLog(@"Zip File Created");
            NSString *zipFileName = [NSString stringWithFormat:@"%@.zip",  @"ftpuser_intimate"];
            NSURL *zipPathUrl = [[[DocumentDirectory shareDocumentDirectory] directoryPath] URLByAppendingPathComponent:zipFileName];
            NSLog(@"zipPathUrl:%@", zipPathUrl);
            
            [self createDirectory:zipPathUrl.absoluteString claimId:claimID completionHandler:^(BOOL status) {
//                if (status) {
                    // get zip file path here
                    NSString *zipPath = [self returnZipPathWithUserName];
                    NSLog(@"zipPath%@", zipPath);
                    
                    if ([zipPath length] > 0) {
                        [self uploadMediaWithPath:zipPath claimID:self.claimID];
                    }
                //}
            }];
        } else {
            NSLog(@"Zip File Not Created");
        }
    }
}


- (void)createDirectory:(NSString *)path claimId:(NSString *)claimID  completionHandler:(DirCompletionHandler)dirCompletionHandler {
    CreateDirController *createDirController = [CreateDirController sharedCreateDirController];
//    NSString *ftpPath = [NSString stringWithFormat:@"%@%@",[[Configuration shareConfiguration] ftpDirPath],[[UserManager sharedUserManager]userName]];
    NSString *ftpPath = [NSString stringWithFormat:@"%@%@",@"/IntimationDocxFiles/",self.claimID];
    NSLog(@"ftpPath------> %@", ftpPath);
    
    [createDirController createDirectory:ftpPath
             completionHandler:(DirCompletionHandler) dirCompletionHandler];
}

- (NSString *)returnZipPathWithUserName {
    
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    NSString *fileName = [NSString stringWithFormat:@"%@.zip",@"ftpuser_intimate"];
    NSURL *fileURL = [[[DocumentDirectory shareDocumentDirectory] directoryPath]URLByAppendingPathComponent:fileName];
    NSLog(@"%@",fileURL);
    if ([filemanager fileExistsAtPath:fileURL.path]) {
        return fileURL.path;
    } else {
        return @"";
    }
}

- (void)uploadMediaWithPath:(NSString *)zipPath claimID:(NSString *)claimID {
    
    NSString *hostName = [NSString stringWithFormat:@"%@%@", [[Configuration shareConfiguration] ftpIntimateHostName],claimID];
    [FTPHelper sharedInstance].delegate = self;
    [FTPHelper sharedInstance].uname = [[Configuration shareConfiguration] ftpUserName];
    [FTPHelper sharedInstance].pword = [[Configuration shareConfiguration] ftpPassword];
//    [FTPHelper sharedInstance].urlString = [[Configuration shareConfiguration] ftpHostName];
    [FTPHelper sharedInstance].urlString = hostName;
    [FTPHelper upload:zipPath];
}

- (void) dataUploadFinished: (NSNumber *) bytes {
    
    [[DocumentDirectory shareDocumentDirectory] removeZipPathWithUserName:@"ftpuser_intimate"];
    [[DocumentDirectory shareDocumentDirectory] removeZipPathWithUserName:@"Intimate"];
    
    alertView(@"Your Claim ID is", self.claimID, self, @"Ok", nil, kClaimsAlertTag);
                  self.hospitalDetail = [[NSMutableDictionary alloc]init];
       [self.hospitalDetail setValue:self.myPolicyDetails.memberID forKey:@"UHID"];
       self.claimsExpandCollapse = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];
    //Remove All Array Elements
    [self.imagesArray removeAllObjects];
    [self.tableView reloadData];
//    alertView(@"Images or Documents Uploaded", @"Images or Documents Uploaded Successfully", nil, @"Ok", nil, 0);
}

- (void) dataUploadFailed: (NSString *) reason {
    alertView(@"Data Upload Failed", reason, nil, @"Ok", nil, 0);
}


- (IBAction)cancelAction:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    self.isAttach = NO;
    [(UIView *) [self.view viewWithTag:kIntimationUploadScreenTag] removeFromSuperview];
    [(UIView *) [self.view viewWithTag:kIntimationUploadPopUpTag] removeFromSuperview];
    
}

- (IBAction)intimateButtonTapped:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    

    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        sender.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
    } completion:^(BOOL finished) {
        
        sender.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
        HospitalModel *detail = (HospitalModel *)[self.hospitalDetail valueForKey:@"hospitaldetail"];
        [params setValue:detail.hospitalName forKey:@"ProviderName"];
        [params setValue:detail.hospitalCode forKey:@"HospitalCode"];
        [params setValue:detail.address forKey:@"ProviderAddress"];
        [params setValue:[self.hospitalDetail valueForKey:kPatientName] forKey:@"PatientName"];
        [params setValue:[self.hospitalDetail valueForKey:kPhoneNumber] forKey:@"Contactno"];
        [params setValue:[self.hospitalDetail valueForKey:kEmailAddress] forKey:@"Email"];
        [params setValue:([self.hospitalDetail valueForKey:kDiagnosis])?[self.hospitalDetail valueForKey:kDiagnosis]:@"" forKey:@"Ailment"];
        [params setValue:[self.hospitalDetail valueForKey:kAdmissionDate] forKey:@"DateOfAdmission"];
        [params setValue:[self.hospitalDetail valueForKey:kDischargeDate] forKey:@"DateOfDischarge"];
        [params setValue:[self.hospitalDetail valueForKey:kClaimAmount] forKey:@"EstimatedExpense"];
        [params setValue:[self.hospitalDetail valueForKey:@"UHID"] forKey:@"UHID"];
        [params setValue:([self.hospitalDetail valueForKey:kIntimationClaimType])?[self.hospitalDetail valueForKey:kIntimationClaimType]:@"" forKey:@"ClaimType"];
        [params setValue:self.myPolicyDetails.policyType forKey:@"CallerType"];
        [params setValue:[self.hospitalDetail valueForKey:kIntiRemarks] forKey:@"Remarks"];
        [params setValue:[self.hospitalDetail valueForKey:kIntiRelationship] forKey:@"Relationship"];
        [params setValue:@"ftpuser_intimate" forKey:@"DocumentName"];
        NSArray *error = nil;
        BOOL isValidate = [[Helper shareHelper] validateRiaseClaimWithError:&error parmas:params];
        if (!isValidate)
        {
            NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
            alertView([[Configuration shareConfiguration] appName], errorMessage, nil, @"Ok", nil, 0);
            return ;
        }
        [params  removeObjectForKey:@"HospitalCode"];
        [params  removeObjectForKey:@"Email"];
        [params  removeObjectForKey:@"Contactno"];
        [self showHUDWithMessage:@""];
        [[HITPAAPI shareAPI] postClaimsWithParams:params completionHandler:^(NSDictionary *response , NSError *error){
            
            [self didReceiveClaimsResponse:response error:error];
            
        }];
    }];
    
}

#pragma mark - TextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    [[KeyboardHelper sharedKeyboardHelper]animateTextView:textView isUp:YES View:self.view];
    textView.textColor = [UIColor blackColor];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        if ([textView.text  isEqual: @""]) {
            textView.text = NSLocalizedString(@"Remarks", @"");
            textView.textColor = [UIColor grayColor];
            
        }
        
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    [[KeyboardHelper sharedKeyboardHelper]animateTextView:textView isUp:NO View:self.view];
    [self.hospitalDetail setValue:textView.text forKey:kIntiRemarks];
}

- (void)textViewDidChange:(UITextView *)textView{
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView * _Nonnull)textView
{
    
    if ([textView.text isEqualToString:@"Remarks"])
    {
        textView.text = @"";
    }
    
    
    return YES;
}

- (NSString *)extractNumberFromText:(NSString *)text
{
  NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  return [[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

#pragma mark  - Handler
- (void)didReceiveClaimsResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    if([response isKindOfClass:[NSDictionary class]]) {

        NSString *responseId = [response valueForKey:@"successID"];
        responseId = [responseId stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSLog(@"%@", responseId);
        //self.claimID = [response valueForKey:@"successID"];
        self.claimID  = [self extractNumberFromText:[response valueForKey:@"successID"]];
        if ([self .claimID length] > 0 ){
             [self uploadImagesUsingFTP:self.claimID];
        }
        //[self.claimID stringByReplacingOccurrencesOfString:@"'\"'" withString:@""];
       
      //   [self.hospitalDetail setValue:self.myPolicyDetails.memberName forKey:@"patientName"];
       // [self.hospitalDetail setValue:self.myPolicyDetails.policyNumber forKey:@"MemberPolicyNumber"];
       // [self.hospitalDetail setValue:self.myPolicyDetails.relationship forKey:@"MemberRelationship"];
        
    }
    else {
        if(error != nil) {
            alertView([[Configuration shareConfiguration] appName], @"No internet connection. Connect to internet to proceed", nil, @"Ok", nil, 0);
            return;
        }
        
    }
    
}

- (void)didReceivePolicyHistoryResponse:(NSDictionary *)response error:(NSError *)error
{
    
    [self hideHUD];
    
    if ([[response valueForKey:@"Message"] length] > 0) {
        
    }
    else
    {
        [[HITPAUserDefaults shareUserDefaluts] setValue:[response valueForKey:@"ProductName"] forKey:@"product"];
        [[HITPAUserDefaults shareUserDefaluts] synchronize];
        
        [[CoreData shareData] setMyPolicyDetailsWithResponse:response];
        self.myPolicyDetails = [MyPolicyModel getPolicyHistoryDetailsByResponse:response];

    }
    
}

- (void)didReceiveClaimsHistoryResponse:(NSDictionary *)response error:(NSError *)error
{
    [(UILabel *)[self.view viewWithTag:kClaimHistoryStausLabelTag] setHidden:YES];

    [self hideHUD];
    
    NSMutableArray *claimsHistory = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dictionary in response) {
        
        if ([dictionary isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            [dict setValue:self.myPolicyDetails.contactNo forKey:@"Contactno"];
            [dict setValue:self.myPolicyDetails.email forKey:@"Email"];
            ClaimsJunction *history = [ClaimsJunction getClaimsHistoryDetailsByResponse:dict];
            [claimsHistory addObject:history];
        }
    }
    
    [self.claimsHistoryDetails setValue:claimsHistory forKey:@"history"];
    
    
    self.claimsExpandCollapseHistory = [[NSMutableArray alloc]init];
    for (int i = 0; i < [claimsHistory count]; i++) {
        
        [self.claimsExpandCollapseHistory addObject:[NSNumber numberWithBool:NO]];
        
    }
    
    if ([claimsHistory count] == 0) {
        
        [(UILabel *)[self.view viewWithTag:kClaimHistoryStausLabelTag] setHidden:NO];

    }
    [self reloadTableView];
    
}

#pragma mark - Gesture Recognizer

- (void)sectionGestureTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.view.tag == 1 || gestureRecognizer.view.tag == 2)
    {
        
        HospitalModel *detail = (HospitalModel *)[self.hospitalDetail valueForKey:@"hospitaldetail"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setValue:detail.hospitalName forKey:kHospitalName];
//        [params setValue:detail valueForKey:kPincode] forKey:kPincode];
//        [params setValue:detail forKey:kCity];
        
        NSArray *error = nil;
        BOOL isValidate = [[Helper shareHelper] validateSectionWithError:&error params:params];
        if (!isValidate)
        {
            
            NSString *errorMessage = [[Helper shareHelper] getErrorStringFromErrorDescription:error];
            alertView(@"ErrorMessage", errorMessage, nil, @"Ok", nil, 0);
            return;
            
        }
        else
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:gestureRecognizer.view.tag];
            BOOL isBoolValue = [[self.claimsExpandCollapse objectAtIndex:indexPath.section] boolValue];
            isBoolValue = !isBoolValue;
            [self.claimsExpandCollapse replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:isBoolValue]];
            NSRange range = NSMakeRange(indexPath.section, 1);
            NSIndexSet *set  = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.tableView reloadSections:set withRowAnimation:UITableViewAutomaticDimension];
            if (isBoolValue) {
                for (int i = 0;i < 3;i ++) {
                    if (i != gestureRecognizer.view.tag) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
                        BOOL isBoolValue = [[self.claimsExpandCollapse objectAtIndex:indexPath.section] boolValue];
                        if (isBoolValue) {
                            isBoolValue = !isBoolValue;
                            [self.claimsExpandCollapse replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:isBoolValue]];
                            NSRange range = NSMakeRange(indexPath.section, 1);
                            NSIndexSet *set  = [NSIndexSet indexSetWithIndexesInRange:range];
                            [self.tableView reloadSections:set withRowAnimation:UITableViewAutomaticDimension];
                        }
                       
                    }
                }
            }
        }
    }
    else
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:gestureRecognizer.view.tag];
        BOOL isBoolValue = [[self.claimsExpandCollapse objectAtIndex:indexPath.section] boolValue];
        isBoolValue = !isBoolValue;
        [self.claimsExpandCollapse replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:isBoolValue]];
        NSRange range = NSMakeRange(indexPath.section, 1);
        NSIndexSet *set  = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:set withRowAnimation:UITableViewAutomaticDimension];
        if (isBoolValue) {
            for (int i = 0;i < 3;i ++) {
                if (i != gestureRecognizer.view.tag) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
                    BOOL isBoolValue = [[self.claimsExpandCollapse objectAtIndex:indexPath.section] boolValue];
                    if (isBoolValue) {
                        isBoolValue = !isBoolValue;
                        [self.claimsExpandCollapse replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:isBoolValue]];
                        NSRange range = NSMakeRange(indexPath.section, 1);
                        NSIndexSet *set  = [NSIndexSet indexSetWithIndexesInRange:range];
                        [self.tableView reloadSections:set withRowAnimation:UITableViewAutomaticDimension];
                    }
                    
                }
            }
        }
    }
    
}

- (void)historyGestureTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:gestureRecognizer.view.tag];
    BOOL isBoolValue = [[self.claimsExpandCollapseHistory objectAtIndex:indexPath.section] boolValue];
    isBoolValue = !isBoolValue;
    
    [self.claimsExpandCollapseHistory replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:isBoolValue]];
    NSRange range = NSMakeRange(indexPath.section, 1);
    NSIndexSet *set  = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:set withRowAnimation:UITableViewAutomaticDimension];
    
}
#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
